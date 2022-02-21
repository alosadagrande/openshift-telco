# TestPMD

[testPMD](https://doc.dpdk.org/guides/testpmd_app_ug/) is an application used to test DPDK in a packet forwarding mode and also to access NIC hardware features such as Flow Director. 

> :exclamation: testPMD is only provided as a simple example of how to build a more fully-featured application using the DPDK base image.

## Build:

You can build the application from the Dockerfile which is based on the work of [Sebastian Scheinkman](https://github.com/SchSeba/dpdk-testpm-trex-example)

> ❗Notice that you can adjust the DPDK version built in the container image by setting the DPDK_VER variable.

```
$ podman build . -t quay.io/alosadag/testpmd:21.11.1 -f Dockerfile 
```

## Deployment:

#### Create the namespace

```bash
oc create ns testpmd
```

#### Performance profile

[PAO documentation](https://docs.openshift.com/container-platform/4.9/scalability_and_performance/cnf-performance-addon-operator-for-low-latency-nodes.html). 

Testpmd requires from PAO hugepages, a guaranteed Pod (number of resources requests equals to limits) and memory available. 

Example:

```yaml
apiVersion: performance.openshift.io/v2
kind: PerformanceProfile
metadata:
  annotations:
    kubeletconfig.experimental: |
      {"topologyManagerScope": "pod",
       "systemReserved": {"memory": "10.5Gi"}
      }
    ran.openshift.io/ztp-deploy-wave: "10"
  creationTimestamp: "2022-02-18T15:03:16Z"
  finalizers:
  - foreground-deletion
  generation: 1
  name: performance-sno
  resourceVersion: "38562"
  uid: 0e3a50c6-c49b-4f15-8584-5fb1782d26d4
spec:
  additionalKernelArgs:
  - firmware_class.path=/var/lib/firmware/
  - idle=poll
  - rcupdate.rcu_normal_after_boot=0
  - nohz_full=4-51,56-103
  - crashkernel=1024M
  cpu:
    isolated: 4-51,56-103
    reserved: 0-3,52-55
  globallyDisableIrqLoadBalancing: false
  hugepages:
    defaultHugepagesSize: 1G
    pages:
    - count: 32
      size: 1G
  machineConfigPoolSelector:
    pools.operator.machineconfiguration.openshift.io/master: ""
  net:
    userLevelNetworking: true
  nodeSelector:
    node-role.kubernetes.io/master: ""
  numa:
    topologyPolicy: single-numa-node
  realTimeKernel:
    enabled: true
```

Also it's important to request the topologyPolicy to be `single-numa-node`

#### SR-IOV configuration

For the sriov configuration it is important to understand the interface vendor
and match the configuration, take a look on the [openshift documentation](https://docs.openshift.com/container-platform/4.9/networking/hardware_networks/using-dpdk-and-rdma.html)

Exmaple of SriovNetwork CR:

```yaml
apiVersion: sriovnetwork.openshift.io/v1
kind: SriovNetwork
metadata:
  annotations:
    operator.sriovnetwork.openshift.io/last-network-namespace: openshift-sriov-network-operator
  creationTimestamp: "2022-02-18T15:39:26Z"
  finalizers:
  - netattdef.finalizers.sriovnetwork.openshift.io
  generation: 1
  name: sriov-nw-du-vfio-ens2f0
  namespace: openshift-sriov-network-operator
  resourceVersion: "56583"
  uid: 3648a77d-3c94-4184-8ad2-4f589f8f2fa4
spec:
  ipam: '{"type": "host-local","ranges": [[{"subnet": "10.0.20.0/24"}]],"dataDir":
      "/run/my-orchestrator/container-ipam-state-1"}'
  networkNamespace: openshift-sriov-network-operator
  resourceName: xxv710_ens2f0
  spoofChk: "off"
  trust: "on"
```

Example of 
```yaml
apiVersion: sriovnetwork.openshift.io/v1
kind: SriovNetworkNodePolicy
metadata:
  annotations:
    ran.openshift.io/ztp-deploy-wave: "100"
  creationTimestamp: "2022-02-18T15:39:26Z"
  generation: 1
  name: xxv710-ens2f0
  namespace: openshift-sriov-network-operator
  resourceVersion: "56584"
  uid: 79afaf3b-dcc1-4411-895a-6aa399dbed69
spec:
  deviceType: vfio-pci
  isRdma: false
  linkType: eth
  mtu: 1500
  nicSelector:
    pfNames:
    - ens2f0
  nodeSelector:
    node-role.kubernetes.io/master: ""
  numVfs: 8
  priority: 10
  resourceName: xxv710_ens2f0
```

### Testpmd

It is possible to build u/s dpdk using the following command, the image is also available
under `quay.io/schseba/dpdk:latest`. But for best performance it's better to use the image provided in the redhat
registry `registry.redhat.io/openshift4/dpdk-base-rhel8:latest`

```bash
build-dpdk
```

## Run testpmd

### Manual

It is possible to run testpmd by accessing the container after it's running but that can impact the performance because the exec command is not attached to one CPU and can create interrupts

Update the networks name depending on the sriovNetwork CR applied on the cluster before and then create the pod

```
oc apply -f manifests/deployment-testpmd.yaml.yaml
```

When the container is running exec into it and run the testpmd application

```bash
export CPU=$(cat /sys/fs/cgroup/cpuset/cpuset.cpus)
echo ${CPU}
testpmd -l ${CPU} -a ${PCIDEVICE_OPENSHIFT_IO_XXV710_ENS7F0} -a ${PCIDEVICE_OPENSHIFT_IO_XXV710_ENS7F1} -n 4 -- -i --nb-cores=15 --rxd=4096 --txd=4096 --rxq=7 --txq=7 --forward-mode=mac --eth-peer=0,50:00:00:00:00:01 --eth-peer=1,50:00:00:00:00:02

EAL: Detected 104 lcore(s)
EAL: Detected 2 NUMA nodes
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: No available hugepages reported in hugepages-2048kB
EAL: Probing VFIO support...
EAL: VFIO support initialized
EAL:   using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_i40e_vf (8086:154c) device: 0000:89:02.0 (socket 1)
EAL: Probe PCI driver: net_i40e_vf (8086:154c) device: 0000:89:0a.6 (socket 1)
EAL: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set mac packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=171456, size=2176, socket=1
testpmd: preferred mempool ops selected: ring_mp_mc
Configuring Port 0 (socket 1)

Port 1: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event

Port 0: link state change event
Port 0: 12:F4:BF:08:66:08
Configuring Port 1 (socket 1)

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event

Port 1: link state change event
Port 1: 72:82:65:CF:BE:69
Checking link statuses...
Done
testpmd> 
```

> :exclamation: Change the `PCIDEVICE_OPENSHIFT_IO_DPDK_NIC_*` depending on the sriovNetwork you it was attached to the pod
(it's possible to check it using `env | grep PCIDEVICE_OPENSHIFT_IO`)

> :exclamation: it's good to check that allocated CPUs are all from the same numa and siblings, also check they are on the same
numa as the network nics and the hugepages

To check cpu list, siblings and numa

```bash
sh-4.4# lscpu -e
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE
0   0    0      0    0:0:0:0       yes
1   1    1      1    1:1:1:1       yes
2   0    0      2    2:2:2:0       yes
3   1    1      3    3:3:3:1       yes
4   0    0      4    4:4:4:0       yes
5   1    1      5    5:5:5:1       yes
6   0    0      6    6:6:6:0       yes
7   1    1      7    7:7:7:1       yes
8   0    0      8    8:8:8:0       yes
9   1    1      9    9:9:9:1       yes
10  0    0      10   10:10:10:0    yes
11  1    1      11   11:11:11:1    yes
12  0    0      12   12:12:12:0    yes
13  1    1      13   13:13:13:1    yes
...
```

To check numa for an interface

```bash
lspci -v -nn -mm -k -s ${PCIDEVICE_OPENSHIFT_IO_DPDK_NIC_3}
Slot:	5e:00.6
Class:	Ethernet controller [0200]
Vendor:	Mellanox Technologies [15b3]
Device:	MT27800 Family [ConnectX-5 Virtual Function] [1018]
SVendor:	Mellanox Technologies [15b3]
SDevice:	Device [0091]
Driver:	mlx5_core
lspci: Unable to load libkmod resources: error -12
NUMANode:	0
IOMMUGroup:	160
```

When testpmd is up is good to disable the promiscuous mode by running `set promisc all off`

Last step is to run the testpmd
```bash
start
mac packet forwarding - ports=2 - cores=15 - streams=30 - NUMA support enabled, MP allocation mode: native
Logical Core 24 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=0 (socket 0) -> TX P=1/Q=0 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=50:00:00:00:00:01
Logical Core 26 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=1 (socket 0) -> TX P=1/Q=1 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=50:00:00:00:00:01
Logical Core 28 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=1/Q=2 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=50:00:00:00:00:01
Logical Core 30 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=3 (socket 0) -> TX P=1/Q=3 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=50:00:00:00:00:01
Logical Core 32 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=4 (socket 0) -> TX P=1/Q=4 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=4 (socket 0) -> TX P=0/Q=4 (socket 0) peer=50:00:00:00:00:01
Logical Core 34 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=5 (socket 0) -> TX P=1/Q=5 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=5 (socket 0) -> TX P=0/Q=5 (socket 0) peer=50:00:00:00:00:01
Logical Core 36 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=6 (socket 0) -> TX P=1/Q=6 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=6 (socket 0) -> TX P=0/Q=6 (socket 0) peer=50:00:00:00:00:01
Logical Core 74 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=7 (socket 0) -> TX P=1/Q=7 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=7 (socket 0) -> TX P=0/Q=7 (socket 0) peer=50:00:00:00:00:01
Logical Core 76 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=8 (socket 0) -> TX P=1/Q=8 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=8 (socket 0) -> TX P=0/Q=8 (socket 0) peer=50:00:00:00:00:01
Logical Core 78 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=9 (socket 0) -> TX P=1/Q=9 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=9 (socket 0) -> TX P=0/Q=9 (socket 0) peer=50:00:00:00:00:01
Logical Core 80 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=10 (socket 0) -> TX P=1/Q=10 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=10 (socket 0) -> TX P=0/Q=10 (socket 0) peer=50:00:00:00:00:01
Logical Core 82 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=11 (socket 0) -> TX P=1/Q=11 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=11 (socket 0) -> TX P=0/Q=11 (socket 0) peer=50:00:00:00:00:01
Logical Core 84 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=12 (socket 0) -> TX P=1/Q=12 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=12 (socket 0) -> TX P=0/Q=12 (socket 0) peer=50:00:00:00:00:01
Logical Core 86 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=13 (socket 0) -> TX P=1/Q=13 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=13 (socket 0) -> TX P=0/Q=13 (socket 0) peer=50:00:00:00:00:01
Logical Core 88 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=14 (socket 0) -> TX P=1/Q=14 (socket 0) peer=50:00:00:00:00:02
  RX P=1/Q=14 (socket 0) -> TX P=0/Q=14 (socket 0) peer=50:00:00:00:00:01

  mac packet forwarding packets/burst=32
  nb forwarding cores=15 - nb forwarding ports=2
  port 0: RX queue number: 15 Tx queue number: 15
    Rx offloads=0x0 Tx offloads=0x0
    RX queue: 0
      RX desc=4096 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=4096 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x0 - TX RS bit threshold=0
  port 1: RX queue number: 15 Tx queue number: 15
    Rx offloads=0x0 Tx offloads=0x0
    RX queue: 0
      RX desc=4096 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=4096 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x0 - TX RS bit threshold=0
```

Useful commands to check status:

```bash
show port stats all

show port xstats all

show fwd stats all

show config fwd
```

To stop just run `stop` and for exiting testpmd run `quit`

### Automatic

TDB
