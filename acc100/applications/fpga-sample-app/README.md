# Run a FPGA test application 

> ❗It has been tested successfully on a SNO cluster version 4.9.19.

The purpose of this folder is being able to verify that the ACC100 FEC has been configured properly in your OpenShift cluster. First, we need to compile the bbdev application and for that you need the proper real time kernel devel packages.

Then we can just apply the following pod example [manifest](../manifests/pod-bbdev-sample.app.yaml)

## Configure ACC100 in OpenShift

In the [smart-edge-open/openshift-operator](https://github.com/smart-edge-open/openshift-operator/blob/main/spec/openshift-sriov-fec-operator.md) you can find all the information required to deploy the latest FEC operator. Moreover, there is a troubleshooting guide and some information that might be relevant for your task.

# Compile

First you need to download the proper kernel real-time devel rpm into the file folder and configure the RTK variable inside the Dockerfile. It can be found in [brew](https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=3727).

The value must be the output of the $(uname -r) command in a node inside your cluster.
Notice then, that the rtk-devel rpm must be the same kernel version. It must placed inside the files/ folder.

Here you have an expected output of the build process for the bbdev application:

```sh
$ podman build . -t quay.io/alosadag/bbdev-sample-app
[1/2] STEP 1/16: FROM centos:7.9.2009 AS builder
[1/2] STEP 2/16: ENV http_proxy=$http_proxy
--> Using cache 52cfe7e87058249f765481e3823716dd30392795b73a46b34f2d1aea33b8ef24
--> 52cfe7e8705
[1/2] STEP 3/16: ENV https_proxy=$https_proxy
--> Using cache fbcbd51f68b8624ab8a8438763d47635db9b84267487ad5926f846121208dd2f
--> fbcbd51f68b
[1/2] STEP 4/16: ENV DPDK_FILENAME=dpdk-20.11.tar.xz
--> Using cache c1515f27ec175cb0f86715d6118e1bf63e6b50b93cd68e4b459ae9b5cb5282bd
--> c1515f27ec1
[1/2] STEP 5/16: ENV DPDK_LINK=https://fast.dpdk.org/rel/dpdk-20.11.tar.xz
--> Using cache a7288034d305dbcb19b96a3e401e8eefd2f67eb912c73bedbec8b23f14c5c78a
--> a7288034d30
[1/2] STEP 6/16: ENV RTE_SDK=/root/dpdk-20.11/
--> Using cache 5e4b9cefc6fb1b7b896283d111283452f614cdf6154e6a14bc86e3a38fd5eb51
--> 5e4b9cefc6f
[1/2] STEP 7/16: ENV RTK=4.18.0-305.34.2.rt7.107.el8_4.x86_64
--> 15a09aa697a
[1/2] STEP 8/16: WORKDIR /root/
--> 5af1ae0a314
[1/2] STEP 9/16: COPY /files /root/files
--> f62e2ac867b
[1/2] STEP 10/16: RUN yum install -y gcc-c++ make git xz-utils wget numactl-devel epel-release && yum install -y meson
--> Finished Dependency Resolution
Dependencies Resolved
Complete!
--> d2b214ee372
[1/2] STEP 11/16: RUN wget $DPDK_LINK
--2022-02-10 10:02:05--  https://fast.dpdk.org/rel/dpdk-20.11.tar.xz
Resolving fast.dpdk.org (fast.dpdk.org)... 151.101.2.49, 151.101.66.49, 151.101.130.49, ...
Connecting to fast.dpdk.org (fast.dpdk.org)|151.101.2.49|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 13967436 (13M) [application/octet-stream]
Saving to: 'dpdk-20.11.tar.xz'

     0K .......... .......... .......... .......... ..........  0% 3.95M 3s
 13600K .......... .......... .......... ..........           100% 5.10M=0.2s

2022-02-10 10:02:06 (56.2 MB/s) - 'dpdk-20.11.tar.xz' saved [13967436/13967436]

--> 870f8f57585
[1/2] STEP 12/16: RUN tar -xf $DPDK_FILENAME 
--> b1aaf54bc2c
[1/2] STEP 13/16: RUN yum localinstall files/kernel-rt-devel-${RTK}.rpm -y
Installed:
  kernel-rt-devel.x86_64 0:4.18.0-305.34.2.rt7.107.el8_4                        
Complete!
--> 16955b76d1d
[1/2] STEP 14/16: RUN mkdir -p /lib/modules/${RTK}
--> e02cd7d7c31
[1/2] STEP 15/16: RUN ln -s /usr/src/kernels/${RTK} /lib/modules/${RTK}/build
--> 4ab66bbda2c
[1/2] STEP 16/16: RUN cd $RTE_SDK && meson build && cd build && ninja
The Meson build system
Version: 0.55.1
Source dir: /root/dpdk-20.11
Build dir: /root/dpdk-20.11/build
Build type: native build
Program cat found: YES
Project name: DPDK
Project version: 20.11.0
C compiler for the host machine: cc (gcc 4.8.5 "cc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)")
C linker for the host machine: cc ld.bfd 2.27-44
Host machine cpu family: x86_64
Host machine cpu: x86_64
Program pkg-config found: YES
Program gen-pmdinfo-cfile.sh found: YES
Program list-dir-globs.py found: YES
Program check-symbols.sh found: YES
Program options-ibverbs-static.sh found: YES
Program binutils-avx512-check.sh found: YES
Program python3 found: YES (/usr/bin/python3)
Program cat found: YES
Program ../buildtools/symlink-drivers-solibs.sh found: YES (/bin/sh /root/dpdk-20.11/config/../buildtools/symlink-drivers-solibs.sh)
Checking for size of "void *" : 8
Checking for size of "void *" : 8
Library m found: YES
Library numa found: YES
Has header "numaif.h" : YES 
Library libfdt found: NO
Found pkg-config: /usr/bin/pkg-config (0.27.1)
Did not find CMake 'cmake'
Found CMake: NO
Run-time dependency libbsd found: NO (tried pkgconfig and cmake)
Run-time dependency libpcap found: NO (tried pkgconfig)
Library pcap found: NO
Compiler for C supports arguments -Wextra: YES 
config/meson.build:231: WARNING: Consider using the built-in warning_level option instead of using "-Wextra".
Message: 
=================
Libraries Enabled
=================

libs:
	kvargs, telemetry, eal, ring, rcu, mempool, mbuf, net, 
	meter, ethdev, pci, cmdline, metrics, hash, timer, acl, 
	bbdev, bitratestats, cfgfile, compressdev, cryptodev, distributor, efd, eventdev, 
	gro, gso, ip_frag, jobstats, kni, latencystats, lpm, member, 
	power, pdump, rawdev, regexdev, rib, reorder, sched, security, 
	stack, vhost, ipsec, fib, port, table, pipeline, flow_classify, 
	bpf, graph, node, 

Message: 
===============
Drivers Enabled
===============

common:
	cpt, dpaax, iavf, octeontx, octeontx2, sfc_efx, qat, 
bus:
	dpaa, fslmc, ifpga, pci, vdev, vmbus, 
mempool:
	bucket, dpaa, dpaa2, octeontx, octeontx2, ring, stack, 
net:
	af_packet, ark, atlantic, avp, axgbe, bond, bnxt, cxgbe, 
	dpaa, dpaa2, e1000, ena, enetc, enic, failsafe, fm10k, 
	i40e, hinic, hns3, iavf, ice, igc, ixgbe, kni, 
	liquidio, memif, netvsc, nfp, null, octeontx, octeontx2, pfe, 
	qede, ring, sfc, softnic, tap, thunderx, txgbe, vdev_netvsc, 
	vhost, virtio, vmxnet3, 
raw:
	dpaa2_cmdif, dpaa2_qdma, ioat, ntb, octeontx2_dma, octeontx2_ep, skeleton, 
crypto:
	bcmfs, caam_jr, dpaa_sec, dpaa2_sec, nitrox, null, octeontx, octeontx2, 
	scheduler, virtio, 
compress:
	octeontx, 
regex:
	octeontx2, 
vdpa:
	ifc, 
event:
	dlb, dlb2, dpaa, dpaa2, octeontx2, opdl, skeleton, sw, 
	dsw, octeontx, 
baseband:
	null, turbo_sw, fpga_lte_fec, fpga_5gnr_fec, acc100, 

Message: 
=================
Content Skipped
=================

libs:
	
drivers:
	common/mvep:	missing dependency, "libmusdk"
	common/mlx5:	missing dependency, "mlx5"
	crypto/qat:	missing dependency, libcrypto
	net/af_xdp:	missing dependency, "libbpf"
	net/bnx2x:	missing dependency, "zlib"
	net/ipn3ke:	missing dependency, "libfdt"
	net/mlx4:	missing dependency, "mlx4"
	net/mlx5:	missing internal dependency, "common_mlx5"
	net/mvneta:	missing dependency, "libmusdk"
	net/mvpp2:	missing dependency, "libmusdk"
	net/nfb:	missing dependency, "libnfb"
	net/pcap:	missing dependency, "libpcap"
	net/szedata2:	missing dependency, "libsze2"
	raw/ifpga:	missing dependency, "libfdt"
	crypto/aesni_gcm:	missing dependency, "libIPSec_MB"
	crypto/aesni_mb:	missing dependency, "libIPSec_MB"
	crypto/armv8:	missing dependency, "libAArch64crypto"
	crypto/ccp:	missing dependency, "libcrypto"
	crypto/kasumi:	missing dependency, "libIPSec_MB"
	crypto/mvsam:	missing dependency, "libmusdk"
	crypto/openssl:	missing dependency, "libcrypto"
	crypto/snow3g:	missing dependency, "libIPSec_MB"
	crypto/zuc:	missing dependency, "libIPSec_MB"
	compress/isal:	missing dependency, "libisal"
	compress/zlib:	missing dependency, "zlib"
	regex/mlx5:	missing internal dependency, "common_mlx5"
	vdpa/mlx5:	missing internal dependency, "common_mlx5"
	

Build targets in project: 970

Found ninja-1.10.2 at /usr/bin/ninja
[1/2405] Generating rte_kvargs_mingw with a custom command
[2/2405] Generating rte_kvargs_def with a custom command
[3/2405] Generating rte_telemetry_mingw with a custom command
[4/2405] Generating rte_telemetry_def with a custom command
[5/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_cpuflags.c.o
[2404/2405] Linking target app/dpdk-test-sad
[2405/2405] Linking target app/test/dpdk-test
--> 899665fe123
[2/2] STEP 1/7: FROM centos:7.9.2009
[2/2] STEP 2/7: ENV RTE_SDK=/root/dpdk-20.11/
--> 682fa90f8d4
[2/2] STEP 3/7: WORKDIR /root/
--> 6580ab22eec
[2/2] STEP 4/7: RUN yum install -y numactl-devel python3
Loaded plugins: fastestmirror, ovl
Dependencies Resolved
Install  2 Packages (+5 Dependent packages)
Complete!
--> ea71f8e1d21
[2/2] STEP 5/7: COPY --from=builder /${RTE_SDK}/app/test-bbdev/test-bbdev.py .
--> b87632e1347
[2/2] STEP 6/7: COPY --from=builder /${RTE_SDK}/app/test-bbdev/test_vectors/ .
--> 7b83520bd09
[2/2] STEP 7/7: COPY --from=builder /${RTE_SDK}/build/app/dpdk-test-bbdev  .
[2/2] COMMIT quay.io/alosadag/bbdev-sample-app
--> a81cce09d75
Successfully tagged quay.io/alosadag/bbdev-sample-app:latest
a81cce09d751277806ea48ec53838c1800d4ab2cd7852be2dbb162a74726d058
```

## Test the application

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
$ oc rsh pod-bbdev-sample-app
sh-4.2# ./test-bbdev.py --testapp-path ./dpdk-test-bbdev -e="-w ${PCIDEVICE_INTEL_COM_INTEL_FEC_ACC100}" -i -n 1 -b 1 -l 1 -c validation -v ldpc_dec_v7813.data
Executing: ./dpdk-test-bbdev -w 0000:87:00.6 -- -n 1 -l 1 -c validation -i -v ldpc_dec_v7813.data -b 1
EAL: Detected 104 lcore(s)
EAL: Detected 2 NUMA nodes
Option -w, --pci-whitelist is deprecated, use -a, --allow option instead
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: No available hugepages reported in hugepages-2048kB
EAL: Probing VFIO support...
EAL: VFIO support initialized
EAL:   using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: intel_acc100_vf (8086:d5d) device: 0000:87:00.6 (socket 1)
EAL: No legacy callbacks, legacy socket not created

===========================================================
Starting Test Suite : BBdev Validation Tests
Test vector file = ldpc_dec_v7813.data
Device 0 queue 16 setup failed
Allocated all queues (id=16) at prio0 on dev0
Device 0 queue 32 setup failed
Allocated all queues (id=32) at prio1 on dev0
Device 0 queue 48 setup failed
Allocated all queues (id=48) at prio2 on dev0
Device 0 queue 64 setup failed
Allocated all queues (id=64) at prio3 on dev0
Device 0 queue 64 setup failed
All queues on dev 0 allocated: 64
+ ------------------------------------------------------- +
== test: validation
dev:0000:87:00.6, burst size: 1, num ops: 1, op type: RTE_BBDEV_OP_LDPC_DEC
Operation latency:
	avg: 20388 cycles, 9.70857 us
	min: 20388 cycles, 9.70857 us
	max: 20388 cycles, 9.70857 us
TestCase [ 0] : validation_tc passed
 + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ +
 + Test Suite Summary : BBdev Validation Tests
 + Tests Total :        1
 + Tests Skipped :      0
 + Tests Passed :       1
 + Tests Failed :       0
 + Tests Lasted :       130.169 ms
 + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ +
```
