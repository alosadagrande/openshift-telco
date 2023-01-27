# Run a FPGA test application 

> ❗It has been tested successfully on a SNO cluster version 4.12.0

The purpose of this folder is being able to verify that the ACC100 FEC has been configured properly in your OpenShift cluster. First, we need to compile the bbdev application and for that you need the proper real time kernel devel packages.

Then we can just apply the following pod example [manifest](../manifests/pod-bbdev-sample.app.yaml)

## Configure ACC100 in OpenShift

In the [smart-edge-open/openshift-operator](https://github.com/smart-edge-open/sriov-fec-operator/blob/main/spec/sriov-fec-operator.md) you can find all the information required to deploy the latest FEC operator. Moreover, there is a troubleshooting guide and some information that might be relevant for your task.

# Compile

First you need to download the proper kernel real-time devel rpm into the file folder and configure the RTK variable inside the Dockerfile. It can be found in [brew](https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=3727).

The value must be the output of the $(uname -r) command in a node inside your cluster.
Notice then, that the rtk-devel rpm must be the same kernel version. It must placed inside the files/ folder.

Here you have an expected output of the build process for the bbdev application:

```sh
$ podman build . -t quay.io/alosadag/bbdev-sample-app:4.18.0-372.40.1.rt7.197.el8_6.x86_64
[1/2] STEP 1/18: FROM centos:7 AS builder
[1/2] STEP 2/18: ENV http_proxy=$http_proxy
--> Using cache bf7bc7693513030308a67cce197fc3a86e37621010cb75163a08e38c8df0baff
--> bf7bc769351
[1/2] STEP 3/18: ENV https_proxy=$https_proxy
--> Using cache ea2df05aa614718bc3631e3e4627c8e8d02e1102121f4869aec4142cd608ffdb
--> ea2df05aa61
[1/2] STEP 4/18: ENV DPDK_FILENAME=dpdk-22.11.1.tar.xz
--> Using cache f38d82b6755525c646c56553e76c45447570d0e189153761abbf4ba51a79cdb7
--> f38d82b6755
[1/2] STEP 5/18: ENV DPDK_LINK=http://fast.dpdk.org/rel/${DPDK_FILENAME}
--> Using cache 8ab6907fa9234ec858cd1f95653a59d54a717dd878e7c9087117458bbe276f9f
--> 8ab6907fa92
[1/2] STEP 6/18: ENV RTE_SDK=/root/dpdk-stable-22.11.1/
--> Using cache cc2f3e4abc11ed24421c233aa366459876d7371d52668a13f45c59e08e2fc118
--> cc2f3e4abc1
[1/2] STEP 7/18: ENV RTK=4.18.0-372.40.1.rt7.197.el8_6.x86_64
--> Using cache 762b5da014e8197529d0749bfa8f0372fb8599e2472fbc092229c3be71211fcd
--> 762b5da014e
[1/2] STEP 8/18: WORKDIR /root/
--> Using cache 6b6fc41073c3d5b0cf1de34c643d5257604be395b588fe8630b3c80fcc02ca71
--> 6b6fc41073c
[1/2] STEP 9/18: COPY /files /root/files
--> Using cache a5e91fb8073778192f4c0d96107aa43fcc91420cd2396da8b31b49b827ade0ec
--> a5e91fb8073
[1/2] STEP 10/18: RUN yum update -y
--> Using cache c614173e9064c59a0240d4e70731b0651512f6a33e85f661d1e9b8a4db31bf35
--> c614173e906
[1/2] STEP 11/18: RUN yum install -y gcc-c++ make git xz-utils wget numactl-devel epel-release && yum install -y meson python3-pip
Loaded plugins: fastestmirror, ovl
Complete!
[1/2] STEP 12/18: RUN pip3 install pyelftools
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting pyelftools
  Downloading https://files.pythonhosted.org/packages/04/7c/867630e6e6293793f838b31034aa1875e1c3bd8c1ec34a0929a2506f350c/pyelftools-0.29-py2.py3-none-any.whl (174kB)
Installing collected packages: pyelftools
Successfully installed pyelftools-0.29
--> fba4b386a8a
[1/2] STEP 13/18: RUN wget $DPDK_LINK
--2023-01-27 08:45:03--  http://fast.dpdk.org/rel/dpdk-22.11.1.tar.xz
Resolving fast.dpdk.org (fast.dpdk.org)... 151.101.2.49, 151.101.66.49, 151.101.130.49, ...
Connecting to fast.dpdk.org (fast.dpdk.org)|151.101.2.49|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 15582084 (15M) [application/octet-stream]
Saving to: 'dpdk-22.11.1.tar.xz'

     0K .......... .......... .......... .......... ..........  0% 4.89M 3s
    50K .......... .......... .......... .......... ..........  0% 4.70M 3s
2023-01-27 08:45:03 (65.7 MB/s) - 'dpdk-22.11.1.tar.xz' saved [15582084/15582084]

--> 8dd39003ee6
[1/2] STEP 14/18: RUN tar -xf $DPDK_FILENAME 
--> 47cc03d1471
[1/2] STEP 15/18: RUN yum localinstall files/kernel-rt-devel-${RTK}.rpm -y
Loaded plugins: fastestmirror, ovl
Examining files/kernel-rt-devel-4.18.0-372.40.1.rt7.197.el8_6.x86_64.rpm: kernel-rt-devel-4.18.0-372.40.1.rt7.197.el8_6.x86_64
Marking files/kernel-rt-devel-4.18.0-372.40.1.rt7.197.el8_6.x86_64.rpm to be installed
Resolving Dependencies
Installed:
  kernel-rt-devel.x86_64 0:4.18.0-372.40.1.rt7.197.el8_6                        

Complete!
--> 32effea25b8
[1/2] STEP 16/18: RUN mkdir -p /lib/modules/${RTK}
--> d99381c8df5
[1/2] STEP 17/18: RUN ln -s /usr/src/kernels/${RTK} /lib/modules/${RTK}/build
--> 5eefde40173
[1/2] STEP 18/18: RUN cd $RTE_SDK && meson build && cd build && ninja
The Meson build system
Version: 0.55.1
Source dir: /root/dpdk-stable-22.11.1
Build dir: /root/dpdk-stable-22.11.1/build
Build type: native build
Program cat found: YES
Project name: DPDK
Project version: 22.11.1
C compiler for the host machine: cc (gcc 4.8.5 "cc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)")
C linker for the host machine: cc ld.bfd 2.27-44
Host machine cpu family: x86_64
Host machine cpu: x86_64
Program pkg-config found: YES
Program check-symbols.sh found: YES
Program options-ibverbs-static.sh found: YES
Program objdump found: YES
Program python3 found: YES (/usr/bin/python3)
Program cat found: YES
Program ../buildtools/symlink-drivers-solibs.sh found: YES (/bin/sh /root/dpdk-stable-22.11.1/config/../buildtools/symlink-drivers-solibs.sh)
Checking for size of "void *" : 8
Checking for size of "void *" : 8
Library m found: YES
Library numa found: YES
Has header "numaif.h" : YES 
Library libfdt found: NO
Library libexecinfo found: NO
Found pkg-config: /usr/bin/pkg-config (0.27.1)
Run-time dependency libarchive found: NO (tried pkgconfig)
Run-time dependency libbsd found: NO (tried pkgconfig)
Run-time dependency jansson found: NO (tried pkgconfig)
Run-time dependency openssl found: NO (tried pkgconfig)
Run-time depenConfiguring rte_build_config.h using configuration
Message: 
=================
Applications Enabled
=================

apps:
	pdump, proc-info, test-acl, test-bbdev, test-cmdline, test-compress-perf, test-crypto-perf, test-eventdev, 
	test-fib, test-flow-perf, test-gpudev, test-pipeline, test-pmd, test-regex, test-sad, test-security-perf, 
	

Message: 
=================
Libraries Enabled
=================

libs:
	kvargs, telemetry, eal, ring, rcu, mempool, mbuf, net, 
	meter, ethdev, pci, cmdline, metrics, hash, timer, acl, 
	bbdev, bitratestats, bpf, cfgfile, compressdev, cryptodev, distributor, efd, 
	eventdev, gpudev, gro, gso, ip_frag, jobstats, latencystats, lpm, 
	member, pcapng, power, rawdev, regexdev, dmadev, rib, reorder, 
	sched, security, stack, vhost, ipsec, fib, port, pdump, 
	table, pipeline, graph, node, 

Message: 
===============
Drivers Enabled
===============

common:
	cpt, dpaax, iavf, idpf, octeontx, cnxk, qat, sfc_efx, 
	
bus:
	auxiliary, dpaa, fslmc, ifpga, pci, vdev, vmbus, 
mempool:
	bucket, cnxk, dpaa, dpaa2, octeontx, ring, stack, 
dma:
	cnxk, dpaa, dpaa2, hisilicon, idxd, ioat, skeleton, 
net:
	af_packet, ark, atlantic, avp, axgbe, bnxt, bond, cnxk, 
	cxgbe, dpaa, dpaa2, e1000, ena, enetc, enetfec, enic, 
	failsafe, fm10k, gve, hinic, hns3, i40e, iavf, ice, 
	idpf, igc, ionic, ixgbe, liquidio, memif, netvsc, nfp, 
	ngbe, null, octeontx, octeon_ep, pfe, qede, ring, softnic, 
	tap, thunderx, txgbe, vdev_netvsc, vhost, virtio, vmxnet3, 
raw:
	cnxk_bphy, cnxk_gpio, dpaa2_cmdif, ntb, skeleton, 
crypto:
	bcmfs, caam_jr, cnxk, dpaa_sec, dpaa2_sec, nitrox, null, octeontx, 
	scheduler, virtio, 
compress:
	octeontx, 
regex:
	cn9k, 
vdpa:
	ifc, sfc, 
event:
	cnxk, dlb2, dpaa, dpaa2, dsw, opdl, skeleton, sw, 
	octeontx, 
baseband:
	acc, fpga_5gnr_fec, fpga_lte_fec, la12xx, null, turbo_sw, 
gpu:
	Message: 
=================
Content Skipped
=================

apps:
	dumpcap:	missing dependency, "libpcap"
	
libs:
	kni:	explicitly disabled via build config (deprecated lib)
	flow_classify:	explicitly disabled via build config (deprecated lib)
	
drivers:
	common/mvep:	missing dependency, "libmusdk"
	common/mlx5:	missing dependency, "mlx5"
	crypto/qat:	missing dependency, libcrypto
	net/af_xdp:	missing header, "linux/if_xdp.h"
	net/bnx2x:	missing dependency, "zlib"
	net/ipn3ke:	missing dependency, "libfdt"
	net/kni:	missing internal dependency, "kni" (deprecated lib)
	net/mlx4:	missing dependency, "mlx4"
	net/mlx5:	missing internal dependency, "common_mlx5"
	net/mvneta:	missing dependency, "libmusdk"
	net/mvpp2:	missing dependency, "libmusdk"
	net/nfb:	missing dependency, "libnfb"
	net/pcap:	missing dependency, "libpcap"
	net/sfc:	broken dependency, "libatomic"
	raw/ifpga:	missing dependency, "libfdt"
	crypto/armv8:	missing dependency, "libAArch64crypto"
	crypto/ccp:	missing dependency, "libcrypto"
	crypto/ipsec_mb:	missing dependency, "libIPSec_MB"
	crypto/mlx5:	missing internal dependency, "common_mlx5"
	crypto/mvsam:	missing dependency, "libmusdk"
	crypto/openssl:	missing dependency, "libcrypto"
	crypto/uadk:	missing dependency, "libwd"
	compress/isal:	missing dependency, "libisal"
	compress/mlx5:	missing internal dependency, "common_mlx5"
	compress/zlib:	missing dependency, "zlib"
	regex/mlx5:	missing internal dependency, "common_mlx5"
	vdpa/mlx5:	missing internal dependency, "common_mlx5"
	gpu/cuda:	missing dependency, "cuda.h"
	

Build targets in project: 899
Found ninja-1.10.2 at /usr/bin/ninja
[1/3128] Generating rte_mempool_mingw with a custom command
[2/3128] Generating rte_kvargs_def with a custom command
[3/3128] Generating rte_telemetry_def with a custom command
[4/3128] Generating rte_kvargs_mingw with a custom command
[5/3128] Generating rte_telemetry_mingw with a custom command
[6/3128] Compiling C object lib/librte_eal.a.p/eal_common_eal_common_class.c.o
...
[3128/3128] Linking target app/test/dpdk-test
--> 9f5aa640ac4
[2/2] STEP 1/7: FROM centos:7.9.2009
[2/2] STEP 2/7: ENV RTE_SDK=/root/dpdk-stable-22.11.1/
--> 03de73add32
[2/2] STEP 3/7: WORKDIR /root/
--> b3260f2a806
[2/2] STEP 4/7: RUN yum install -y numactl-devel python3
...
Complete!
--> ea8daea86e9
[2/2] STEP 5/7: COPY --from=builder /${RTE_SDK}/app/test-bbdev/test-bbdev.py .
--> 1fd15c113c9
[2/2] STEP 6/7: COPY --from=builder /${RTE_SDK}/app/test-bbdev/test_vectors/ .
--> 631d3f7031a
[2/2] STEP 7/7: COPY --from=builder /${RTE_SDK}/build/app/dpdk-test-bbdev  .
[2/2] COMMIT quay.io/alosadag/bbdev-sample-app:4.18.0-372.40.1.rt7.197.el8_6.x86_64
--> fa9d83ea2dd
Successfully tagged quay.io/alosadag/bbdev-sample-app:4.18.0-372.40.1.rt7.197.el8_6.x86_64
```



# Deploy

In order to deploy the application you can just apply the pod specification stored in the manifests folder.

> :warning: Notice that the Pod manifests does not have any namespace value set. It will be deployed on the ns you are pointing at.

```
$ oc apply -f manifests/pod-bbdev-sample.app.yaml
```


# Test the application

Here are detailed the manual steps to execute the bbdev application. You can just include the execution command in the Pod spec if you prefer.


```sh
$ oc get pods
NAME                                            READY   STATUS    RESTARTS      AGE
accelerator-discovery-crjv7                     1/1     Running   3             22h
pod-bbdev-sample-app                            1/1     Running   1             50m
sriov-device-plugin-n4rnz                       1/1     Running   0             12m
sriov-fec-controller-manager-5486fd4f77-fdlx6   2/2     Running   7             22h
sriov-fec-controller-manager-5486fd4f77-skfcf   2/2     Running   7             22h
sriov-fec-daemonset-9sqwt                       1/1     Running   8 (12m ago)   22h
```
```
sh-4.2# ./test-bbdev.py --testapp-path ./dpdk-test-bbdev -e="-a ${PCIDEVICE_INTEL_COM_INTEL_FEC_ACC100}" -i -n 1 -b 1 -l 1 -c validation -v ldpc_dec_v7813.data
Executing: ./dpdk-test-bbdev -a 0000:87:01.2 -- -n 1 -l 1 -c validation -i -v ldpc_dec_v7813.data -b 1
EAL: Detected CPU lcores: 104
EAL: Detected NUMA nodes: 2
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: intel_acc100_vf (8086:d5d) device: 0000:87:01.2 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created

===========================================================
Starting Test Suite : BBdev Validation Tests
Test vector file = ldpc_dec_v7813.data
Allocated all queues (id=16) at prio0 on dev0
Allocated all queues (id=32) at prio1 on dev0
Allocated all queues (id=48) at prio2 on dev0
Allocated all queues (id=64) at prio3 on dev0
All queues on dev 0 allocated: 64
+ ------------------------------------------------------- +
== test: validation
dev:0000:87:01.2, burst size: 1, num ops: 1, op type: RTE_BBDEV_OP_LDPC_DEC
Operation latency:
	avg: 33910 cycles, 16.1476 us
	min: 33910 cycles, 16.1476 us
	max: 33910 cycles, 16.1476 us
TestCase [ 0] : validation_tc passed
 + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ +
 + Test Suite Summary : BBdev Validation Tests
 + Tests Total :        1
 + Tests Skipped :      0
 + Tests Passed :       1
 + Tests Failed :       0
 + Tests Lasted :       133.666 ms
 + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ +
```
