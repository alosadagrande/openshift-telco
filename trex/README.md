# dpdk-testpm-trex-example

### Requirements

Check the testpmd [README](../testpmd/README.md) since the requirements are the same.

### Trex build

You can use the Dockerfile-trex to build a container image with t-rex.

> :exclamation: Set the Trex version to build into the container image by setting the TREX_VERSION variable.

```sh
$ podman build . -t quay.io/alosadag/trex:v2.95 -f Dockerfile-trex 
STEP 1/9: FROM quay.io/centos/centos:stream8
STEP 2/9: ARG TREX_VERSION=2.95
--> Using cache 5ec420437a89f4e74a297dbba1f9de9b38d82f51a08b7c7b104ef9b9e38bbfe9
--> 5ec420437a8
STEP 3/9: ENV TREX_VERSION ${TREX_VERSION}
--> Using cache 39cea95825fc28535504c11ad505112ca41c8614f8ff7271ba7019072b3dae3f
--> 39cea95825f
STEP 4/9: RUN dnf -y install --nodocs git wget procps python3 vim python3-pip pciutils gettext https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && dnf clean all
--> Using cache 135a02e83f9ebe74e38704e91a3715aa9d5d5376bc5d839eb599c1321d3f4f63
--> 135a02e83f9
STEP 5/9: RUN dnf install -y --nodocs hostname iproute net-tools ethtool nmap iputils perf numactl sysstat htop rdma-core-devel libibverbs libibverbs-devel net-tools && dnf clean all
--> Using cache 8fd8c8739deff61734f26d4d37d4050b0d77bcd6d43869db96577ffe3fae06fb
--> 8fd8c8739de
STEP 6/9: WORKDIR /opt/
--> Using cache c9c9461f1bc80b78e6441a2496d462fa8b9686998675f47f14f4ae06a5aa4794
--> c9c9461f1bc
STEP 7/9: RUN wget --no-check-certificate https://trex-tgn.cisco.com/trex/release/v${TREX_VERSION}.tar.gz &&     tar -xzf v${TREX_VERSION}.tar.gz &&     mv v${TREX_VERSION} trex &&     rm v${TREX_VERSION}.tar.gz
--> Using cache e065c03414f0aa41b4a3cab449edb235ad9a2ab82c927faa3cbebca3e198521f
--> e065c03414f
STEP 8/9: COPY scripts /opt/scripts
--> 694783ba9c9
STEP 9/9: WORKDIR /opt/trex
COMMIT quay.io/alosadag/trex:v2.95
--> 279d4fdb55a
Successfully tagged quay.io/alosadag/trex:v2.95
279d4fdb55a72c73f643929861f342f2490a24687f44ec33b09a0821c2958f2e
```

### Deployment:

#### Create the namespace

```bash
oc create ns trex
```

Before deployment T-rex make sure you modify the trex.yaml Pod manifest to macht you environment:

* numa selection `SOCKET: "1"`- depends on your SR-IOV configuration and huge pages allocation
* interface environments `interfaces: ["${PCIDEVICE_OPENSHIFT_IO_DPDK_ENS2F0}","${PCIDEVICE_OPENSHIFT_IO_DPDK_ENS2F1}"]`
* networks in the pod annotation definition:

```
    k8s.v1.cni.cncf.io/networks: '[
      {
       "name": "sriov-nw-du-vfio-ens2f0",
       "mac": "50:00:00:00:00:01",
       "namespace": "openshift-sriov-network-operator"
      },
      {
       "name": "sriov-nw-du-vfio-ens2f1",
       "mac": "50:00:00:00:00:02",
       "namespace": "openshift-sriov-network-operator"
      }
    ]'
```

Change also the mac_telco0 and mac_telco1 variables by the value of the MAC address assigned to the testpmd SR-IOV interfaces. It is required so that T-rex knows what MAC address needs to send and receive traffic.

> :exclamation: The value of these MAC address can be extracted from the output of testpmd once you execute the start command.

Then deploy the Pod manifest:

```bash
$ oc apply -f trex.yaml 
configmap/trex-info-for-config created
configmap/trex-config-template created
configmap/trex-tests created
pod/trex created
```


## Start Trex

> :warning: This is manual start, so the entrypoint of the T-rex Pod is sleep bash command

```sh
$ oc rsh trex 
sh-4.4# cp /opt/tests/testpmd* /tmp/.
```

If you did not set the proper mac addresses you can do it now again. 

```sh
sh-4.4# vim /tmp/testpmd_addr.py 

# wild second XL710 mac
mac_telco0 = '12:E6:42:28:FC:64'
# we don't care of the IP in this phase
ip_telco0  = '10.0.0.1'
# wild first XL710 mac
mac_telco1 = '8E:B7:D1:79:83:76'
ip_telco1 = '10.1.1.1'
```
Next, you can double check the T-rex configuration set automatically when we applied the manifests:

* Check that the PCI interfaces are the ones assigned to the SR-IOV devices
* Check that the resources are aligned in the socket number specified

```yaml
- port_limit: 2
  version: 2
  interfaces:
    - 0000:5e:02.0
    - 0000:5e:0a.5
  port_bandwidth_gb: 25
  port_info:
    - ip: 10.10.10.2
      default_gw: 10.10.10.1
    - ip: 10.10.20.2
      default_gw: 10.10.20.1
  platform:
    master_thread_id: 20
    latency_thread_id: 22
    dual_if:
      - socket: 0
        threads: [24,26,28,30,32,34,72,74,76,78,80,82,84,86]
```
* Adjust the threads. It is recommeded that both the master and latency threads are siblings of the same core. Remember then to remove the master_thread_id sibling from the threads array and include the latency_thread_id.

> :exclamation: This is a 52 core server. So the result modification is set to:

```sh
- port_limit: 2
  version: 2
  interfaces:
    - 0000:5e:02.0
    - 0000:5e:0a.5
  port_bandwidth_gb: 25
  port_info:
    - ip: 10.10.10.2
      default_gw: 10.10.10.1
    - ip: 10.10.20.2
      default_gw: 10.10.20.1
  platform:
    master_thread_id: 20
    latency_thread_id: 72
    dual_if:
      - socket: 0
        threads: [22,24,26,28,30,32,34,74,76,78,80,82,84,86]
```

Finally execute the following command that will start the T-rex web service:

```sh
sh-4.4# ./t-rex-64 --no-ofed-check --no-hw-flow-stat -i -c 14
sh: /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages: Read-only file system
WARNING: tried to configure 2048 hugepages for socket 0, but result is: 0
sh: /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages: Read-only file system
WARNING: tried to configure 2048 hugepages for socket 1, but result is: 0
Starting Scapy server..... Scapy server is started
The ports are bound/configured.
Starting  TRex v2.95 please wait  ... 
 set driver name net_i40e_vf 
 driver capability  : TCP_UDP_OFFLOAD  TSO 
 set dpdk queues mode to MULTI_QUE 
 Number of ports found: 2
zmq publisher at: tcp://*:4500
 wait 1 sec .
port : 0 
------------
link         :  link : Link Up - speed 25000 Mbps - full-duplex
promiscuous  : 0 
port : 1 
------------
link         :  link : Link Up - speed 25000 Mbps - full-duplex
promiscuous  : 0 
 number of ports         : 2 
 max cores for 2 ports   : 14 
 tx queues per port      : 16 
 -------------------------------
RX core uses TX queue number 65535 on all ports
 core, c-port, c-queue, s-port, s-queue, lat-queue
 ------------------------------------------
 1        0      0       1       0      0  
 2        0      1       1       1    255  
 3        0      2       1       2    255  
 4        0      3       1       3    255  
 5        0      4       1       4    255  
 6        0      5       1       5    255  
 7        0      6       1       6    255  
 8        0      7       1       7    255  
 9        0      8       1       8    255  
 10        0      9       1       9    255  
 11        0     10       1      10    255  
 12        0     11       1      11    255  
 13        0     12       1      12    255  
 14        0     13       1      13    255  
 -------------------------------
```

Next, open a second terminal where we are going to start the traffic test:

```sh
sh-4.4# ./trex-console

Using 'python3' as Python interpeter


Connecting to RPC server on localhost:4501                   [SUCCESS]


Connecting to publisher server on localhost:4500             [SUCCESS]


Acquiring ports [0, 1]:                                      [SUCCESS]

*** Warning - Port 0 destination is unresolved ***
*** Warning - Port 1 destination is unresolved ***

Server Info:

Server version:   v2.95 @ STL
Server mode:      Stateless
Server CPU:       14 x Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz
Ports count:      2 x 25.0Gbps @ Ethernet Virtual Function 700 Series	

-=TRex Console v3.0=-

Type 'help' or '?' for supported actions

trex>
```

```sh
trex> tui
Global Statistics

connection   : localhost, Port 4501                       total_tx_L2  : 0 bps                          
version      : STL @ v2.95                                total_tx_L1  : 0 bps                          
cpu_util.    : 0.0% @ 14 cores (14 per dual port)         total_rx     : 8.61 Kbps                      
rx_cpu_util. : 0.0% / 0 pps                               total_pps    : 0 pps                          
async_util.  : 0% / 0.29 bps                              drop_rate    : 0 bps                          
total_cps.   : 0 cps                                      queue_full   : 0 pkts                         

Port Statistics

   port    |         0         |         1         |       total       
-----------+-------------------+-------------------+------------------
owner      |              root |              root |                   
link       |                UP |                UP |                   
state      |              IDLE |              IDLE |                   
speed      |           25 Gb/s |           25 Gb/s |                   
CPU util.  |              0.0% |              0.0% |                   
--         |                   |                   |                   
Tx bps L2  |             0 bps |             0 bps |             0 bps 
Tx bps L1  |             0 bps |             0 bps |             0 bps 
Tx pps     |             0 pps |             0 pps |             0 pps 
Line Util. |               0 % |               0 % |                   
---        |                   |                   |                   
Rx bps     |         4.31 Kbps |          4.3 Kbps |         8.61 Kbps 
Rx pps     |          1.63 pps |          1.63 pps |          3.26 pps 
----       |                   |                   |                   
opackets   |                 0 |                 0 |                 0 
ipackets   |                58 |                58 |               116 
obytes     |                 0 |                 0 |                 0 
ibytes     |             19170 |             19170 |             38340 
tx-pkts    |            0 pkts |            0 pkts |            0 pkts 
rx-pkts    |           58 pkts |           58 pkts |          116 pkts 
tx-bytes   |               0 B |               0 B |               0 B 
rx-bytes   |          19.17 KB |          19.17 KB |          38.34 KB 
-----      |                   |                   |                   
oerrors    |                 0 |                 0 |                 0 
ierrors    |                 0 |                 0 |                 0 

status:  |

Press 'ESC' for navigation panel...
status: 

tui>
```

Start the test by sending 1 million packets per second to testpmd application on port 0:

```
trex> start -f /tmp/testpmd.py -m 1mpps -p0

Global Statistics

connection   : localhost, Port 4501                       total_tx_L2  : 388.97 Mbps ▲▲▲                
version      : STL @ v2.95                                total_tx_L1  : 510.52 Mbps ▲▲▲                
cpu_util.    : 0.94% @ 14 cores (14 per dual port)        total_rx     : 665.92 Mbps ▲▲▲                
rx_cpu_util. : 0.0% / 0 pps                               total_pps    : 759.7 Kpps ▲▲▲                 
async_util.  : 0% / 16.08 bps                             drop_rate    : 0 bps                          
total_cps.   : 0 cps                                      queue_full   : 0 pkts                         

Port Statistics

   port    |         0         |         1         |       total       
-----------+-------------------+-------------------+------------------
owner      |              root |              root |                   
link       |                UP |                UP |                   
state      |      TRANSMITTING |              IDLE |                   
speed      |           25 Gb/s |           25 Gb/s |                   
CPU util.  |             0.94% |              0.0% |                   
--         |                   |                   |                   
Tx bps L2  |   ▲▲▲ 388.97 Mbps |             0 bps |   ▲▲▲ 388.97 Mbps 
Tx bps L1  |   ▲▲▲ 510.52 Mbps |             0 bps |   ▲▲▲ 510.52 Mbps 
Tx pps     |    ▲▲▲ 759.7 Kpps |             0 pps |    ▲▲▲ 759.7 Kpps 
Line Util. |            2.04 % |               0 % |                   
---        |                   |                   |                   
Rx bps     |   ▲▲▲ 347.91 Mbps |   ▲▲▲ 318.01 Mbps |   ▲▲▲ 665.92 Mbps 
Rx pps     |   ▲▲▲ 679.51 Kpps |   ▲▲▲ 621.12 Kpps |      ▲▲▲ 1.3 Mpps 
----       |                   |                   |                   
opackets   |           3914424 |                 0 |           3914424 
ipackets   |           3425935 |           3220462 |           6646397 
obytes     |         250523136 |                 0 |         250523136 
ibytes     |         219278648 |         206128760 |         425407408 
tx-pkts    |        3.91 Mpkts |            0 pkts |        3.91 Mpkts 
rx-pkts    |        3.43 Mpkts |        3.22 Mpkts |        6.65 Mpkts 
tx-bytes   |         250.52 MB |               0 B |         250.52 MB 
rx-bytes   |         219.28 MB |         206.13 MB |         425.41 MB 
-----      |                   |                   |                   
oerrors    |                 0 |                 0 |                 0 
ierrors    |            83,242 |            84,736 |           167,978 
```

See testpmd stats:

```
testpmd> show port stats all 

  ######################## NIC statistics for port 0  ########################
  RX-packets: 787142398  RX-missed: 4276327    RX-bytes:  248566470037
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 726660676  TX-errors: 0          TX-bytes:  230023059711

  Throughput (since last show)
  Rx-pps:       829960          Rx-bps:    398380992
  Tx-pps:       718165          Tx-bps:    344719656
  ############################################################################

  ######################## NIC statistics for port 1  ########################
  RX-packets: 731332796  RX-missed: 4665805    RX-bytes:  230303386591
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 782865472  TX-errors: 0          TX-bytes:  248309854797

  Throughput (since last show)
  Rx-pps:       816816          Rx-bps:    392071944
  Tx-pps:       721522          Tx-bps:    346330616
  ############################################################################
```

