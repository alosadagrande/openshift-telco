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
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: ftp.csuc.cat
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
No package xz-utils available.
Resolving Dependencies
--> Running transaction check
---> Package epel-release.noarch 0:7-11 will be installed
---> Package gcc-c++.x86_64 0:4.8.5-44.el7 will be installed
--> Processing Dependency: libstdc++-devel = 4.8.5-44.el7 for package: gcc-c++-4.8.5-44.el7.x86_64
--> Processing Dependency: gcc = 4.8.5-44.el7 for package: gcc-c++-4.8.5-44.el7.x86_64
--> Processing Dependency: libmpfr.so.4()(64bit) for package: gcc-c++-4.8.5-44.el7.x86_64
--> Processing Dependency: libmpc.so.3()(64bit) for package: gcc-c++-4.8.5-44.el7.x86_64
---> Package git.x86_64 0:1.8.3.1-23.el7_8 will be installed
--> Processing Dependency: perl-Git = 1.8.3.1-23.el7_8 for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl >= 5.008 for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: rsync for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(warnings) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(vars) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(strict) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(lib) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(Term::ReadKey) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(Git) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(Getopt::Long) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::stat) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Temp) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Spec) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Path) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Find) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Copy) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(File::Basename) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(Exporter) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: perl(Error) for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: openssh-clients for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: less for package: git-1.8.3.1-23.el7_8.x86_64
--> Processing Dependency: /usr/bin/perl for package: git-1.8.3.1-23.el7_8.x86_64
---> Package make.x86_64 1:3.82-24.el7 will be installed
---> Package numactl-devel.x86_64 0:2.0.12-5.el7 will be installed
--> Processing Dependency: numactl-libs = 2.0.12-5.el7 for package: numactl-devel-2.0.12-5.el7.x86_64
--> Processing Dependency: libnuma.so.1()(64bit) for package: numactl-devel-2.0.12-5.el7.x86_64
---> Package wget.x86_64 0:1.14-18.el7_6.1 will be installed
--> Running transaction check
---> Package gcc.x86_64 0:4.8.5-44.el7 will be installed
--> Processing Dependency: libgomp = 4.8.5-44.el7 for package: gcc-4.8.5-44.el7.x86_64
--> Processing Dependency: cpp = 4.8.5-44.el7 for package: gcc-4.8.5-44.el7.x86_64
--> Processing Dependency: glibc-devel >= 2.2.90-12 for package: gcc-4.8.5-44.el7.x86_64
--> Processing Dependency: libgomp.so.1()(64bit) for package: gcc-4.8.5-44.el7.x86_64
---> Package less.x86_64 0:458-9.el7 will be installed
--> Processing Dependency: groff-base for package: less-458-9.el7.x86_64
---> Package libmpc.x86_64 0:1.0.1-3.el7 will be installed
---> Package libstdc++-devel.x86_64 0:4.8.5-44.el7 will be installed
---> Package mpfr.x86_64 0:3.1.1-4.el7 will be installed
---> Package numactl-libs.x86_64 0:2.0.12-5.el7 will be installed
---> Package openssh-clients.x86_64 0:7.4p1-22.el7_9 will be installed
--> Processing Dependency: openssh = 7.4p1-22.el7_9 for package: openssh-clients-7.4p1-22.el7_9.x86_64
--> Processing Dependency: fipscheck-lib(x86-64) >= 1.3.0 for package: openssh-clients-7.4p1-22.el7_9.x86_64
--> Processing Dependency: libfipscheck.so.1()(64bit) for package: openssh-clients-7.4p1-22.el7_9.x86_64
--> Processing Dependency: libedit.so.0()(64bit) for package: openssh-clients-7.4p1-22.el7_9.x86_64
---> Package perl.x86_64 4:5.16.3-299.el7_9 will be installed
--> Processing Dependency: perl-libs = 4:5.16.3-299.el7_9 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl-macros for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl-libs for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Carp) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.16.3-299.el7_9.x86_64
---> Package perl-Error.noarch 1:0.17020-2.el7 will be installed
---> Package perl-Exporter.noarch 0:5.68-3.el7 will be installed
---> Package perl-File-Path.noarch 0:2.09-2.el7 will be installed
---> Package perl-File-Temp.noarch 0:0.23.01-3.el7 will be installed
---> Package perl-Getopt-Long.noarch 0:2.40-3.el7 will be installed
--> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-3.el7.noarch
--> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-3.el7.noarch
---> Package perl-Git.noarch 0:1.8.3.1-23.el7_8 will be installed
---> Package perl-PathTools.x86_64 0:3.40-5.el7 will be installed
---> Package perl-TermReadKey.x86_64 0:2.30-20.el7 will be installed
---> Package rsync.x86_64 0:3.1.2-10.el7 will be installed
--> Running transaction check
---> Package cpp.x86_64 0:4.8.5-44.el7 will be installed
---> Package fipscheck-lib.x86_64 0:1.4.1-6.el7 will be installed
--> Processing Dependency: /usr/bin/fipscheck for package: fipscheck-lib-1.4.1-6.el7.x86_64
---> Package glibc-devel.x86_64 0:2.17-325.el7_9 will be installed
--> Processing Dependency: glibc-headers = 2.17-325.el7_9 for package: glibc-devel-2.17-325.el7_9.x86_64
--> Processing Dependency: glibc = 2.17-325.el7_9 for package: glibc-devel-2.17-325.el7_9.x86_64
--> Processing Dependency: glibc-headers for package: glibc-devel-2.17-325.el7_9.x86_64
---> Package groff-base.x86_64 0:1.22.2-8.el7 will be installed
---> Package libedit.x86_64 0:3.0-12.20121213cvs.el7 will be installed
---> Package libgomp.x86_64 0:4.8.5-44.el7 will be installed
---> Package openssh.x86_64 0:7.4p1-22.el7_9 will be installed
---> Package perl-Carp.noarch 0:1.26-244.el7 will be installed
---> Package perl-Filter.x86_64 0:1.49-3.el7 will be installed
---> Package perl-Pod-Simple.noarch 1:3.28-4.el7 will be installed
--> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
--> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
---> Package perl-Pod-Usage.noarch 0:1.63-3.el7 will be installed
--> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.el7.noarch
--> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.el7.noarch
---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.el7 will be installed
---> Package perl-Socket.x86_64 0:2.010-5.el7 will be installed
---> Package perl-Storable.x86_64 0:2.45-3.el7 will be installed
---> Package perl-Text-ParseWords.noarch 0:3.29-4.el7 will be installed
---> Package perl-Time-HiRes.x86_64 4:1.9725-3.el7 will be installed
---> Package perl-Time-Local.noarch 0:1.2300-2.el7 will be installed
---> Package perl-constant.noarch 0:1.27-2.el7 will be installed
---> Package perl-libs.x86_64 4:5.16.3-299.el7_9 will be installed
---> Package perl-macros.x86_64 4:5.16.3-299.el7_9 will be installed
---> Package perl-threads.x86_64 0:1.87-4.el7 will be installed
---> Package perl-threads-shared.x86_64 0:1.43-6.el7 will be installed
--> Running transaction check
---> Package fipscheck.x86_64 0:1.4.1-6.el7 will be installed
---> Package glibc.x86_64 0:2.17-317.el7 will be updated
--> Processing Dependency: glibc = 2.17-317.el7 for package: glibc-common-2.17-317.el7.x86_64
---> Package glibc.x86_64 0:2.17-325.el7_9 will be an update
---> Package glibc-headers.x86_64 0:2.17-325.el7_9 will be installed
--> Processing Dependency: kernel-headers >= 2.2.1 for package: glibc-headers-2.17-325.el7_9.x86_64
--> Processing Dependency: kernel-headers for package: glibc-headers-2.17-325.el7_9.x86_64
---> Package perl-Encode.x86_64 0:2.51-7.el7 will be installed
---> Package perl-Pod-Escapes.noarch 1:1.04-299.el7_9 will be installed
---> Package perl-Pod-Perldoc.noarch 0:3.20-4.el7 will be installed
--> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
--> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
---> Package perl-podlators.noarch 0:2.5.1-3.el7 will be installed
--> Running transaction check
---> Package glibc-common.x86_64 0:2.17-317.el7 will be updated
---> Package glibc-common.x86_64 0:2.17-325.el7_9 will be an update
---> Package kernel-headers.x86_64 0:3.10.0-1160.53.1.el7 will be installed
---> Package perl-HTTP-Tiny.noarch 0:0.033-3.el7 will be installed
---> Package perl-parent.noarch 1:0.225-244.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                   Arch      Version                   Repository  Size
================================================================================
Installing:
 epel-release              noarch    7-11                      extras      15 k
 gcc-c++                   x86_64    4.8.5-44.el7              base       7.2 M
 git                       x86_64    1.8.3.1-23.el7_8          base       4.4 M
 make                      x86_64    1:3.82-24.el7             base       421 k
 numactl-devel             x86_64    2.0.12-5.el7              base        24 k
 wget                      x86_64    1.14-18.el7_6.1           base       547 k
Installing for dependencies:
 cpp                       x86_64    4.8.5-44.el7              base       5.9 M
 fipscheck                 x86_64    1.4.1-6.el7               base        21 k
 fipscheck-lib             x86_64    1.4.1-6.el7               base        11 k
 gcc                       x86_64    4.8.5-44.el7              base        16 M
 glibc-devel               x86_64    2.17-325.el7_9            updates    1.1 M
 glibc-headers             x86_64    2.17-325.el7_9            updates    691 k
 groff-base                x86_64    1.22.2-8.el7              base       942 k
 kernel-headers            x86_64    3.10.0-1160.53.1.el7      updates    9.0 M
 less                      x86_64    458-9.el7                 base       120 k
 libedit                   x86_64    3.0-12.20121213cvs.el7    base        92 k
 libgomp                   x86_64    4.8.5-44.el7              base       159 k
 libmpc                    x86_64    1.0.1-3.el7               base        51 k
 libstdc++-devel           x86_64    4.8.5-44.el7              base       1.5 M
 mpfr                      x86_64    3.1.1-4.el7               base       203 k
 numactl-libs              x86_64    2.0.12-5.el7              base        30 k
 openssh                   x86_64    7.4p1-22.el7_9            updates    510 k
 openssh-clients           x86_64    7.4p1-22.el7_9            updates    655 k
 perl                      x86_64    4:5.16.3-299.el7_9        updates    8.0 M
 perl-Carp                 noarch    1.26-244.el7              base        19 k
 perl-Encode               x86_64    2.51-7.el7                base       1.5 M
 perl-Error                noarch    1:0.17020-2.el7           base        32 k
 perl-Exporter             noarch    5.68-3.el7                base        28 k
 perl-File-Path            noarch    2.09-2.el7                base        26 k
 perl-File-Temp            noarch    0.23.01-3.el7             base        56 k
 perl-Filter               x86_64    1.49-3.el7                base        76 k
 perl-Getopt-Long          noarch    2.40-3.el7                base        56 k
 perl-Git                  noarch    1.8.3.1-23.el7_8          base        56 k
 perl-HTTP-Tiny            noarch    0.033-3.el7               base        38 k
 perl-PathTools            x86_64    3.40-5.el7                base        82 k
 perl-Pod-Escapes          noarch    1:1.04-299.el7_9          updates     52 k
 perl-Pod-Perldoc          noarch    3.20-4.el7                base        87 k
 perl-Pod-Simple           noarch    1:3.28-4.el7              base       216 k
 perl-Pod-Usage            noarch    1.63-3.el7                base        27 k
 perl-Scalar-List-Utils    x86_64    1.27-248.el7              base        36 k
 perl-Socket               x86_64    2.010-5.el7               base        49 k
 perl-Storable             x86_64    2.45-3.el7                base        77 k
 perl-TermReadKey          x86_64    2.30-20.el7               base        31 k
 perl-Text-ParseWords      noarch    3.29-4.el7                base        14 k
 perl-Time-HiRes           x86_64    4:1.9725-3.el7            base        45 k
 perl-Time-Local           noarch    1.2300-2.el7              base        24 k
 perl-constant             noarch    1.27-2.el7                base        19 k
 perl-libs                 x86_64    4:5.16.3-299.el7_9        updates    690 k
 perl-macros               x86_64    4:5.16.3-299.el7_9        updates     44 k
 perl-parent               noarch    1:0.225-244.el7           base        12 k
 perl-podlators            noarch    2.5.1-3.el7               base       112 k
 perl-threads              x86_64    1.87-4.el7                base        49 k
 perl-threads-shared       x86_64    1.43-6.el7                base        39 k
 rsync                     x86_64    3.1.2-10.el7              base       404 k
Updating for dependencies:
 glibc                     x86_64    2.17-325.el7_9            updates    3.6 M
 glibc-common              x86_64    2.17-325.el7_9            updates     12 M

Transaction Summary
================================================================================
Install  6 Packages (+48 Dependent packages)
Upgrade             (  2 Dependent packages)

Total download size: 77 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
warning: /var/cache/yum/x86_64/7/extras/packages/epel-release-7-11.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for epel-release-7-11.noarch.rpm is not installed
Public key for fipscheck-lib-1.4.1-6.el7.x86_64.rpm is not installed
Public key for glibc-devel-2.17-325.el7_9.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               43 MB/s |  77 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : glibc-2.17-325.el7_9.x86_64                                 1/58 
  Updating   : glibc-common-2.17-325.el7_9.x86_64                          2/58 
  Installing : mpfr-3.1.1-4.el7.x86_64                                     3/58 
  Installing : libmpc-1.0.1-3.el7.x86_64                                   4/58 
  Installing : fipscheck-1.4.1-6.el7.x86_64                                5/58 
  Installing : fipscheck-lib-1.4.1-6.el7.x86_64                            6/58 
  Installing : groff-base-1.22.2-8.el7.x86_64                              7/58 
  Installing : 1:perl-parent-0.225-244.el7.noarch                          8/58 
  Installing : perl-HTTP-Tiny-0.033-3.el7.noarch                           9/58 
  Installing : perl-podlators-2.5.1-3.el7.noarch                          10/58 
  Installing : perl-Pod-Perldoc-3.20-4.el7.noarch                         11/58 
  Installing : 1:perl-Pod-Escapes-1.04-299.el7_9.noarch                   12/58 
  Installing : perl-Text-ParseWords-3.29-4.el7.noarch                     13/58 
  Installing : perl-Encode-2.51-7.el7.x86_64                              14/58 
  Installing : perl-Pod-Usage-1.63-3.el7.noarch                           15/58 
  Installing : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                      16/58 
  Installing : perl-Exporter-5.68-3.el7.noarch                            17/58 
  Installing : perl-constant-1.27-2.el7.noarch                            18/58 
  Installing : perl-threads-1.87-4.el7.x86_64                             19/58 
  Installing : perl-Socket-2.010-5.el7.x86_64                             20/58 
  Installing : perl-Time-Local-1.2300-2.el7.noarch                        21/58 
  Installing : perl-Carp-1.26-244.el7.noarch                              22/58 
  Installing : 4:perl-macros-5.16.3-299.el7_9.x86_64                      23/58 
  Installing : perl-Storable-2.45-3.el7.x86_64                            24/58 
  Installing : perl-threads-shared-1.43-6.el7.x86_64                      25/58 
  Installing : perl-PathTools-3.40-5.el7.x86_64                           26/58 
  Installing : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 27/58 
  Installing : 1:perl-Pod-Simple-3.28-4.el7.noarch                        28/58 
  Installing : perl-File-Temp-0.23.01-3.el7.noarch                        29/58 
  Installing : perl-File-Path-2.09-2.el7.noarch                           30/58 
  Installing : perl-Filter-1.49-3.el7.x86_64                              31/58 
  Installing : 4:perl-libs-5.16.3-299.el7_9.x86_64                        32/58 
  Installing : perl-Getopt-Long-2.40-3.el7.noarch                         33/58 
  Installing : 4:perl-5.16.3-299.el7_9.x86_64                             34/58 
  Installing : 1:perl-Error-0.17020-2.el7.noarch                          35/58 
  Installing : perl-TermReadKey-2.30-20.el7.x86_64                        36/58 
  Installing : less-458-9.el7.x86_64                                      37/58 
  Installing : openssh-7.4p1-22.el7_9.x86_64                              38/58 
  Installing : cpp-4.8.5-44.el7.x86_64                                    39/58 
  Installing : numactl-libs-2.0.12-5.el7.x86_64                           40/58 
  Installing : libedit-3.0-12.20121213cvs.el7.x86_64                      41/58 
  Installing : openssh-clients-7.4p1-22.el7_9.x86_64                      42/58 
  Installing : rsync-3.1.2-10.el7.x86_64                                  43/58 
  Installing : perl-Git-1.8.3.1-23.el7_8.noarch                           44/58 
  Installing : git-1.8.3.1-23.el7_8.x86_64                                45/58 
  Installing : libgomp-4.8.5-44.el7.x86_64                                46/58 
  Installing : libstdc++-devel-4.8.5-44.el7.x86_64                        47/58 
  Installing : kernel-headers-3.10.0-1160.53.1.el7.x86_64                 48/58 
  Installing : glibc-headers-2.17-325.el7_9.x86_64                        49/58 
  Installing : glibc-devel-2.17-325.el7_9.x86_64                          50/58 
  Installing : gcc-4.8.5-44.el7.x86_64                                    51/58 
  Installing : gcc-c++-4.8.5-44.el7.x86_64                                52/58 
  Installing : numactl-devel-2.0.12-5.el7.x86_64                          53/58 
  Installing : 1:make-3.82-24.el7.x86_64                                  54/58 
  Installing : wget-1.14-18.el7_6.1.x86_64                                55/58 
install-info: No such file or directory for /usr/share/info/wget.info.gz
  Installing : epel-release-7-11.noarch                                   56/58 
  Cleanup    : glibc-2.17-317.el7.x86_64                                  57/58 
  Cleanup    : glibc-common-2.17-317.el7.x86_64                           58/58 
  Verifying  : fipscheck-lib-1.4.1-6.el7.x86_64                            1/58 
  Verifying  : perl-HTTP-Tiny-0.033-3.el7.noarch                           2/58 
  Verifying  : gcc-c++-4.8.5-44.el7.x86_64                                 3/58 
  Verifying  : perl-threads-shared-1.43-6.el7.x86_64                       4/58 
  Verifying  : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                       5/58 
  Verifying  : openssh-clients-7.4p1-22.el7_9.x86_64                       6/58 
  Verifying  : groff-base-1.22.2-8.el7.x86_64                              7/58 
  Verifying  : perl-Exporter-5.68-3.el7.noarch                             8/58 
  Verifying  : perl-constant-1.27-2.el7.noarch                             9/58 
  Verifying  : perl-PathTools-3.40-5.el7.x86_64                           10/58 
  Verifying  : perl-threads-1.87-4.el7.x86_64                             11/58 
  Verifying  : kernel-headers-3.10.0-1160.53.1.el7.x86_64                 12/58 
  Verifying  : openssh-7.4p1-22.el7_9.x86_64                              13/58 
  Verifying  : cpp-4.8.5-44.el7.x86_64                                    14/58 
  Verifying  : git-1.8.3.1-23.el7_8.x86_64                                15/58 
  Verifying  : 1:perl-parent-0.225-244.el7.noarch                         16/58 
  Verifying  : perl-Socket-2.010-5.el7.x86_64                             17/58 
  Verifying  : epel-release-7-11.noarch                                   18/58 
  Verifying  : perl-TermReadKey-2.30-20.el7.x86_64                        19/58 
  Verifying  : fipscheck-1.4.1-6.el7.x86_64                               20/58 
  Verifying  : glibc-devel-2.17-325.el7_9.x86_64                          21/58 
  Verifying  : perl-File-Temp-0.23.01-3.el7.noarch                        22/58 
  Verifying  : 1:perl-Pod-Simple-3.28-4.el7.noarch                        23/58 
  Verifying  : numactl-libs-2.0.12-5.el7.x86_64                           24/58 
  Verifying  : perl-Time-Local-1.2300-2.el7.noarch                        25/58 
  Verifying  : 1:make-3.82-24.el7.x86_64                                  26/58 
  Verifying  : 1:perl-Pod-Escapes-1.04-299.el7_9.noarch                   27/58 
  Verifying  : perl-Text-ParseWords-3.29-4.el7.noarch                     28/58 
  Verifying  : perl-Git-1.8.3.1-23.el7_8.noarch                           29/58 
  Verifying  : perl-Carp-1.26-244.el7.noarch                              30/58 
  Verifying  : 1:perl-Error-0.17020-2.el7.noarch                          31/58 
  Verifying  : glibc-common-2.17-325.el7_9.x86_64                         32/58 
  Verifying  : 4:perl-macros-5.16.3-299.el7_9.x86_64                      33/58 
  Verifying  : perl-Storable-2.45-3.el7.x86_64                            34/58 
  Verifying  : gcc-4.8.5-44.el7.x86_64                                    35/58 
  Verifying  : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 36/58 
  Verifying  : libmpc-1.0.1-3.el7.x86_64                                  37/58 
  Verifying  : numactl-devel-2.0.12-5.el7.x86_64                          38/58 
  Verifying  : glibc-2.17-325.el7_9.x86_64                                39/58 
  Verifying  : perl-Pod-Usage-1.63-3.el7.noarch                           40/58 
  Verifying  : perl-Encode-2.51-7.el7.x86_64                              41/58 
  Verifying  : perl-Pod-Perldoc-3.20-4.el7.noarch                         42/58 
  Verifying  : perl-podlators-2.5.1-3.el7.noarch                          43/58 
  Verifying  : 4:perl-5.16.3-299.el7_9.x86_64                             44/58 
  Verifying  : perl-File-Path-2.09-2.el7.noarch                           45/58 
  Verifying  : libedit-3.0-12.20121213cvs.el7.x86_64                      46/58 
  Verifying  : mpfr-3.1.1-4.el7.x86_64                                    47/58 
  Verifying  : rsync-3.1.2-10.el7.x86_64                                  48/58 
  Verifying  : glibc-headers-2.17-325.el7_9.x86_64                        49/58 
  Verifying  : perl-Filter-1.49-3.el7.x86_64                              50/58 
  Verifying  : perl-Getopt-Long-2.40-3.el7.noarch                         51/58 
  Verifying  : libstdc++-devel-4.8.5-44.el7.x86_64                        52/58 
  Verifying  : wget-1.14-18.el7_6.1.x86_64                                53/58 
  Verifying  : 4:perl-libs-5.16.3-299.el7_9.x86_64                        54/58 
  Verifying  : libgomp-4.8.5-44.el7.x86_64                                55/58 
  Verifying  : less-458-9.el7.x86_64                                      56/58 
  Verifying  : glibc-2.17-317.el7.x86_64                                  57/58 
  Verifying  : glibc-common-2.17-317.el7.x86_64                           58/58 

Installed:
  epel-release.noarch 0:7-11                gcc-c++.x86_64 0:4.8.5-44.el7      
  git.x86_64 0:1.8.3.1-23.el7_8             make.x86_64 1:3.82-24.el7          
  numactl-devel.x86_64 0:2.0.12-5.el7       wget.x86_64 0:1.14-18.el7_6.1      

Dependency Installed:
  cpp.x86_64 0:4.8.5-44.el7                                                     
  fipscheck.x86_64 0:1.4.1-6.el7                                                
  fipscheck-lib.x86_64 0:1.4.1-6.el7                                            
  gcc.x86_64 0:4.8.5-44.el7                                                     
  glibc-devel.x86_64 0:2.17-325.el7_9                                           
  glibc-headers.x86_64 0:2.17-325.el7_9                                         
  groff-base.x86_64 0:1.22.2-8.el7                                              
  kernel-headers.x86_64 0:3.10.0-1160.53.1.el7                                  
  less.x86_64 0:458-9.el7                                                       
  libedit.x86_64 0:3.0-12.20121213cvs.el7                                       
  libgomp.x86_64 0:4.8.5-44.el7                                                 
  libmpc.x86_64 0:1.0.1-3.el7                                                   
  libstdc++-devel.x86_64 0:4.8.5-44.el7                                         
  mpfr.x86_64 0:3.1.1-4.el7                                                     
  numactl-libs.x86_64 0:2.0.12-5.el7                                            
  openssh.x86_64 0:7.4p1-22.el7_9                                               
  openssh-clients.x86_64 0:7.4p1-22.el7_9                                       
  perl.x86_64 4:5.16.3-299.el7_9                                                
  perl-Carp.noarch 0:1.26-244.el7                                               
  perl-Encode.x86_64 0:2.51-7.el7                                               
  perl-Error.noarch 1:0.17020-2.el7                                             
  perl-Exporter.noarch 0:5.68-3.el7                                             
  perl-File-Path.noarch 0:2.09-2.el7                                            
  perl-File-Temp.noarch 0:0.23.01-3.el7                                         
  perl-Filter.x86_64 0:1.49-3.el7                                               
  perl-Getopt-Long.noarch 0:2.40-3.el7                                          
  perl-Git.noarch 0:1.8.3.1-23.el7_8                                            
  perl-HTTP-Tiny.noarch 0:0.033-3.el7                                           
  perl-PathTools.x86_64 0:3.40-5.el7                                            
  perl-Pod-Escapes.noarch 1:1.04-299.el7_9                                      
  perl-Pod-Perldoc.noarch 0:3.20-4.el7                                          
  perl-Pod-Simple.noarch 1:3.28-4.el7                                           
  perl-Pod-Usage.noarch 0:1.63-3.el7                                            
  perl-Scalar-List-Utils.x86_64 0:1.27-248.el7                                  
  perl-Socket.x86_64 0:2.010-5.el7                                              
  perl-Storable.x86_64 0:2.45-3.el7                                             
  perl-TermReadKey.x86_64 0:2.30-20.el7                                         
  perl-Text-ParseWords.noarch 0:3.29-4.el7                                      
  perl-Time-HiRes.x86_64 4:1.9725-3.el7                                         
  perl-Time-Local.noarch 0:1.2300-2.el7                                         
  perl-constant.noarch 0:1.27-2.el7                                             
  perl-libs.x86_64 4:5.16.3-299.el7_9                                           
  perl-macros.x86_64 4:5.16.3-299.el7_9                                         
  perl-parent.noarch 1:0.225-244.el7                                            
  perl-podlators.noarch 0:2.5.1-3.el7                                           
  perl-threads.x86_64 0:1.87-4.el7                                              
  perl-threads-shared.x86_64 0:1.43-6.el7                                       
  rsync.x86_64 0:3.1.2-10.el7                                                   

Dependency Updated:
  glibc.x86_64 0:2.17-325.el7_9       glibc-common.x86_64 0:2.17-325.el7_9      

Complete!
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: ftp.csuc.cat
 * epel: mirror.nl.leaseweb.net
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
Resolving Dependencies
--> Running transaction check
---> Package meson.noarch 0:0.55.1-1.el7 will be installed
--> Processing Dependency: python(abi) = 3.6 for package: meson-0.55.1-1.el7.noarch
--> Processing Dependency: /usr/bin/python3 for package: meson-0.55.1-1.el7.noarch
--> Processing Dependency: ninja-build for package: meson-0.55.1-1.el7.noarch
--> Processing Dependency: python3.6dist(setuptools) for package: meson-0.55.1-1.el7.noarch
--> Running transaction check
---> Package ninja-build.x86_64 0:1.10.2-3.el7 will be installed
--> Processing Dependency: emacs-filesystem for package: ninja-build-1.10.2-3.el7.x86_64
--> Processing Dependency: vim-filesystem for package: ninja-build-1.10.2-3.el7.x86_64
---> Package python3.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: python3-libs(x86-64) = 3.6.8-18.el7 for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-pip for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: libpython3.6m.so.1.0()(64bit) for package: python3-3.6.8-18.el7.x86_64
---> Package python3-setuptools.noarch 0:39.2.0-10.el7 will be installed
--> Running transaction check
---> Package emacs-filesystem.noarch 1:24.3-23.el7 will be installed
---> Package python3-libs.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: libtirpc.so.1()(64bit) for package: python3-libs-3.6.8-18.el7.x86_64
---> Package python3-pip.noarch 0:9.0.3-8.el7 will be installed
---> Package vim-filesystem.x86_64 2:7.4.629-8.el7_9 will be installed
--> Running transaction check
---> Package libtirpc.x86_64 0:0.2.4-0.16.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                 Arch        Version                 Repository    Size
================================================================================
Installing:
 meson                   noarch      0.55.1-1.el7            epel         1.1 M
Installing for dependencies:
 emacs-filesystem        noarch      1:24.3-23.el7           base          58 k
 libtirpc                x86_64      0.2.4-0.16.el7          base          89 k
 ninja-build             x86_64      1.10.2-3.el7            epel         144 k
 python3                 x86_64      3.6.8-18.el7            updates       70 k
 python3-libs            x86_64      3.6.8-18.el7            updates      6.9 M
 python3-pip             noarch      9.0.3-8.el7             base         1.6 M
 python3-setuptools      noarch      39.2.0-10.el7           base         629 k
 vim-filesystem          x86_64      2:7.4.629-8.el7_9       updates       11 k

Transaction Summary
================================================================================
Install  1 Package (+8 Dependent packages)

Total download size: 11 M
Installed size: 54 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/epel/packages/meson-0.55.1-1.el7.noarch.rpm: Header V4 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Public key for meson-0.55.1-1.el7.noarch.rpm is not installed
--------------------------------------------------------------------------------
Total                                              6.1 MB/s |  11 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Importing GPG key 0x352C64E5:
 Userid     : "Fedora EPEL (7) <epel@fedoraproject.org>"
 Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
 Package    : epel-release-7-11.noarch (@extras)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 2:vim-filesystem-7.4.629-8.el7_9.x86_64                      1/9 
  Installing : 1:emacs-filesystem-24.3-23.el7.noarch                        2/9 
  Installing : ninja-build-1.10.2-3.el7.x86_64                              3/9 
  Installing : libtirpc-0.2.4-0.16.el7.x86_64                               4/9 
  Installing : python3-setuptools-39.2.0-10.el7.noarch                      5/9 
  Installing : python3-pip-9.0.3-8.el7.noarch                               6/9 
  Installing : python3-3.6.8-18.el7.x86_64                                  7/9 
  Installing : python3-libs-3.6.8-18.el7.x86_64                             8/9 
  Installing : meson-0.55.1-1.el7.noarch                                    9/9 
  Verifying  : libtirpc-0.2.4-0.16.el7.x86_64                               1/9 
  Verifying  : ninja-build-1.10.2-3.el7.x86_64                              2/9 
  Verifying  : python3-3.6.8-18.el7.x86_64                                  3/9 
  Verifying  : python3-libs-3.6.8-18.el7.x86_64                             4/9 
  Verifying  : 1:emacs-filesystem-24.3-23.el7.noarch                        5/9 
  Verifying  : 2:vim-filesystem-7.4.629-8.el7_9.x86_64                      6/9 
  Verifying  : python3-setuptools-39.2.0-10.el7.noarch                      7/9 
  Verifying  : python3-pip-9.0.3-8.el7.noarch                               8/9 
  Verifying  : meson-0.55.1-1.el7.noarch                                    9/9 

Installed:
  meson.noarch 0:0.55.1-1.el7                                                   

Dependency Installed:
  emacs-filesystem.noarch 1:24.3-23.el7                                         
  libtirpc.x86_64 0:0.2.4-0.16.el7                                              
  ninja-build.x86_64 0:1.10.2-3.el7                                             
  python3.x86_64 0:3.6.8-18.el7                                                 
  python3-libs.x86_64 0:3.6.8-18.el7                                            
  python3-pip.noarch 0:9.0.3-8.el7                                              
  python3-setuptools.noarch 0:39.2.0-10.el7                                     
  vim-filesystem.x86_64 2:7.4.629-8.el7_9                                       

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
    50K .......... .......... .......... .......... ..........  0% 5.11M 3s
   100K .......... .......... .......... .......... ..........  1% 13.2M 2s
   150K .......... .......... .......... .......... ..........  1% 9.11M 2s
   200K .......... .......... .......... .......... ..........  1% 28.2M 2s
   250K .......... .......... .......... .......... ..........  2% 48.6M 1s
   300K .......... .......... .......... .......... ..........  2% 31.5M 1s
   350K .......... .......... .......... .......... ..........  2% 31.4M 1s
   400K .......... .......... .......... .......... ..........  3% 9.59M 1s
   450K .......... .......... .......... .......... ..........  3% 34.8M 1s
   500K .......... .......... .......... .......... ..........  4% 57.9M 1s
   550K .......... .......... .......... .......... ..........  4%  124M 1s
   600K .......... .......... .......... .......... ..........  4% 33.0M 1s
   650K .......... .......... .......... .......... ..........  5% 87.8M 1s
   700K .......... .......... .......... .......... ..........  5% 75.4M 1s
   750K .......... .......... .......... .......... ..........  5%  119M 1s
   800K .......... .......... .......... .......... ..........  6%  112M 1s
   850K .......... .......... .......... .......... ..........  6% 11.1M 1s
   900K .......... .......... .......... .......... ..........  6%  118M 1s
   950K .......... .......... .......... .......... ..........  7% 42.5M 1s
  1000K .......... .......... .......... .......... ..........  7%  118M 1s
  1050K .......... .......... .......... .......... ..........  8% 91.1M 1s
  1100K .......... .......... .......... .......... ..........  8% 83.4M 1s
  1150K .......... .......... .......... .......... ..........  8%  173M 1s
  1200K .......... .......... .......... .......... ..........  9% 90.4M 1s
  1250K .......... .......... .......... .......... ..........  9% 99.0M 1s
  1300K .......... .......... .......... .......... ..........  9%  104M 1s
  1350K .......... .......... .......... .......... .......... 10% 95.7M 1s
  1400K .......... .......... .......... .......... .......... 10%  141M 0s
  1450K .......... .......... .......... .......... .......... 10%  115M 0s
  1500K .......... .......... .......... .......... .......... 11% 90.8M 0s
  1550K .......... .......... .......... .......... .......... 11%  138M 0s
  1600K .......... .......... .......... .......... .......... 12% 3.60M 1s
  1650K .......... .......... .......... .......... .......... 12% 26.0M 1s
  1700K .......... .......... .......... .......... .......... 12% 37.1M 1s
  1750K .......... .......... .......... .......... .......... 13%  151M 1s
  1800K .......... .......... .......... .......... .......... 13%  168M 0s
  1850K .......... .......... .......... .......... .......... 13%  128M 0s
  1900K .......... .......... .......... .......... .......... 14%  109M 0s
  1950K .......... .......... .......... .......... .......... 14%  139M 0s
  2000K .......... .......... .......... .......... .......... 15%  158M 0s
  2050K .......... .......... .......... .......... .......... 15%  134M 0s
  2100K .......... .......... .......... .......... .......... 15%  131M 0s
  2150K .......... .......... .......... .......... .......... 16%  102M 0s
  2200K .......... .......... .......... .......... .......... 16%  132M 0s
  2250K .......... .......... .......... .......... .......... 16%  124M 0s
  2300K .......... .......... .......... .......... .......... 17%  118M 0s
  2350K .......... .......... .......... .......... .......... 17%  135M 0s
  2400K .......... .......... .......... .......... .......... 17%  149M 0s
  2450K .......... .......... .......... .......... .......... 18%  165M 0s
  2500K .......... .......... .......... .......... .......... 18%  121M 0s
  2550K .......... .......... .......... .......... .......... 19%  156M 0s
  2600K .......... .......... .......... .......... .......... 19%  151M 0s
  2650K .......... .......... .......... .......... .......... 19%  158M 0s
  2700K .......... .......... .......... .......... .......... 20%  144M 0s
  2750K .......... .......... .......... .......... .......... 20%  164M 0s
  2800K .......... .......... .......... .......... .......... 20%  156M 0s
  2850K .......... .......... .......... .......... .......... 21%  160M 0s
  2900K .......... .......... .......... .......... .......... 21%  137M 0s
  2950K .......... .......... .......... .......... .......... 21%  169M 0s
  3000K .......... .......... .......... .......... .......... 22%  172M 0s
  3050K .......... .......... .......... .......... .......... 22%  157M 0s
  3100K .......... .......... .......... .......... .......... 23%  151M 0s
  3150K .......... .......... .......... .......... .......... 23%  161M 0s
  3200K .......... .......... .......... .......... .......... 23% 82.3M 0s
  3250K .......... .......... .......... .......... .......... 24%  105M 0s
  3300K .......... .......... .......... .......... .......... 24%  103M 0s
  3350K .......... .......... .......... .......... .......... 24% 86.1M 0s
  3400K .......... .......... .......... .......... .......... 25%  113M 0s
  3450K .......... .......... .......... .......... .......... 25%  109M 0s
  3500K .......... .......... .......... .......... .......... 26%  122M 0s
  3550K .......... .......... .......... .......... .......... 26%  118M 0s
  3600K .......... .......... .......... .......... .......... 26% 94.6M 0s
  3650K .......... .......... .......... .......... .......... 27%  101M 0s
  3700K .......... .......... .......... .......... .......... 27%  145M 0s
  3750K .......... .......... .......... .......... .......... 27% 93.4M 0s
  3800K .......... .......... .......... .......... .......... 28%  151M 0s
  3850K .......... .......... .......... .......... .......... 28% 85.2M 0s
  3900K .......... .......... .......... .......... .......... 28%  139M 0s
  3950K .......... .......... .......... .......... .......... 29% 88.6M 0s
  4000K .......... .......... .......... .......... .......... 29%  118M 0s
  4050K .......... .......... .......... .......... .......... 30%  105M 0s
  4100K .......... .......... .......... .......... .......... 30%  128M 0s
  4150K .......... .......... .......... .......... .......... 30% 97.0M 0s
  4200K .......... .......... .......... .......... .......... 31% 3.80M 0s
  4250K .......... .......... .......... .......... .......... 31%  159M 0s
  4300K .......... .......... .......... .......... .......... 31%  176M 0s
  4350K .......... .......... .......... .......... .......... 32%  150M 0s
  4400K .......... .......... .......... .......... .......... 32%  167M 0s
  4450K .......... .......... .......... .......... .......... 32%  167M 0s
  4500K .......... .......... .......... .......... .......... 33%  152M 0s
  4550K .......... .......... .......... .......... .......... 33%  164M 0s
  4600K .......... .......... .......... .......... .......... 34%  162M 0s
  4650K .......... .......... .......... .......... .......... 34%  142M 0s
  4700K .......... .......... .......... .......... .......... 34%  172M 0s
  4750K .......... .......... .......... .......... .......... 35%  175M 0s
  4800K .......... .......... .......... .......... .......... 35%  166M 0s
  4850K .......... .......... .......... .......... .......... 35%  152M 0s
  4900K .......... .......... .......... .......... .......... 36%  171M 0s
  4950K .......... .......... .......... .......... .......... 36%  174M 0s
  5000K .......... .......... .......... .......... .......... 37%  144M 0s
  5050K .......... .......... .......... .......... .......... 37%  174M 0s
  5100K .......... .......... .......... .......... .......... 37%  179M 0s
  5150K .......... .......... .......... .......... .......... 38% 97.1M 0s
  5200K .......... .......... .......... .......... .......... 38%  110M 0s
  5250K .......... .......... .......... .......... .......... 38%  109M 0s
  5300K .......... .......... .......... .......... .......... 39% 66.6M 0s
  5350K .......... .......... .......... .......... .......... 39%  178M 0s
  5400K .......... .......... .......... .......... .......... 39%  197M 0s
  5450K .......... .......... .......... .......... .......... 40%  165M 0s
  5500K .......... .......... .......... .......... .......... 40%  167M 0s
  5550K .......... .......... .......... .......... .......... 41%  196M 0s
  5600K .......... .......... .......... .......... .......... 41%  186M 0s
  5650K .......... .......... .......... .......... .......... 41%  175M 0s
  5700K .......... .......... .......... .......... .......... 42% 54.6M 0s
  5750K .......... .......... .......... .......... .......... 42%  129M 0s
  5800K .......... .......... .......... .......... .......... 42% 76.7M 0s
  5850K .......... .......... .......... .......... .......... 43% 86.0M 0s
  5900K .......... .......... .......... .......... .......... 43% 70.1M 0s
  5950K .......... .......... .......... .......... .......... 43%  124M 0s
  6000K .......... .......... .......... .......... .......... 44% 68.3M 0s
  6050K .......... .......... .......... .......... .......... 44% 78.3M 0s
  6100K .......... .......... .......... .......... .......... 45% 84.8M 0s
  6150K .......... .......... .......... .......... .......... 45% 76.9M 0s
  6200K .......... .......... .......... .......... .......... 45%  131M 0s
  6250K .......... .......... .......... .......... .......... 46% 68.9M 0s
  6300K .......... .......... .......... .......... .......... 46% 76.5M 0s
  6350K .......... .......... .......... .......... .......... 46%  122M 0s
  6400K .......... .......... .......... .......... .......... 47% 73.3M 0s
  6450K .......... .......... .......... .......... .......... 47% 26.3M 0s
  6500K .......... .......... .......... .......... .......... 48% 66.0M 0s
  6550K .......... .......... .......... .......... .......... 48% 43.9M 0s
  6600K .......... .......... .......... .......... .......... 48% 96.6M 0s
  6650K .......... .......... .......... .......... .......... 49% 67.9M 0s
  6700K .......... .......... .......... .......... .......... 49% 96.5M 0s
  6750K .......... .......... .......... .......... .......... 49%  144M 0s
  6800K .......... .......... .......... .......... .......... 50% 54.2M 0s
  6850K .......... .......... .......... .......... .......... 50%  152M 0s
  6900K .......... .......... .......... .......... .......... 50% 53.2M 0s
  6950K .......... .......... .......... .......... .......... 51%  132M 0s
  7000K .......... .......... .......... .......... .......... 51% 93.9M 0s
  7050K .......... .......... .......... .......... .......... 52% 69.1M 0s
  7100K .......... .......... .......... .......... .......... 52%  110M 0s
  7150K .......... .......... .......... .......... .......... 52% 96.3M 0s
  7200K .......... .......... .......... .......... .......... 53%  134M 0s
  7250K .......... .......... .......... .......... .......... 53% 27.0M 0s
  7300K .......... .......... .......... .......... .......... 53% 12.6M 0s
  7350K .......... .......... .......... .......... .......... 54%  169M 0s
  7400K .......... .......... .......... .......... .......... 54%  175M 0s
  7450K .......... .......... .......... .......... .......... 54%  148M 0s
  7500K .......... .......... .......... .......... .......... 55%  181M 0s
  7550K .......... .......... .......... .......... .......... 55%  184M 0s
  7600K .......... .......... .......... .......... .......... 56%  171M 0s
  7650K .......... .......... .......... .......... .......... 56%  138M 0s
  7700K .......... .......... .......... .......... .......... 56%  161M 0s
  7750K .......... .......... .......... .......... .......... 57%  147M 0s
  7800K .......... .......... .......... .......... .......... 57% 58.4M 0s
  7850K .......... .......... .......... .......... .......... 57%  107M 0s
  7900K .......... .......... .......... .......... .......... 58% 96.5M 0s
  7950K .......... .......... .......... .......... .......... 58%  127M 0s
  8000K .......... .......... .......... .......... .......... 59% 27.2M 0s
  8050K .......... .......... .......... .......... .......... 59% 36.7M 0s
  8100K .......... .......... .......... .......... .......... 59%  107M 0s
  8150K .......... .......... .......... .......... .......... 60%  149M 0s
  8200K .......... .......... .......... .......... .......... 60% 52.5M 0s
  8250K .......... .......... .......... .......... .......... 60% 68.7M 0s
  8300K .......... .......... .......... .......... .......... 61% 86.6M 0s
  8350K .......... .......... .......... .......... .......... 61%  121M 0s
  8400K .......... .......... .......... .......... .......... 61%  115M 0s
  8450K .......... .......... .......... .......... .......... 62% 56.5M 0s
  8500K .......... .......... .......... .......... .......... 62%  107M 0s
  8550K .......... .......... .......... .......... .......... 63% 64.5M 0s
  8600K .......... .......... .......... .......... .......... 63% 48.8M 0s
  8650K .......... .......... .......... .......... .......... 63%  147M 0s
  8700K .......... .......... .......... .......... .......... 64%  117M 0s
  8750K .......... .......... .......... .......... .......... 64% 34.6M 0s
  8800K .......... .......... .......... .......... .......... 64% 35.0M 0s
  8850K .......... .......... .......... .......... .......... 65%  145M 0s
  8900K .......... .......... .......... .......... .......... 65% 99.4M 0s
  8950K .......... .......... .......... .......... .......... 65% 63.8M 0s
  9000K .......... .......... .......... .......... .......... 66% 50.0M 0s
  9050K .......... .......... .......... .......... .......... 66% 96.4M 0s
  9100K .......... .......... .......... .......... .......... 67%  103M 0s
  9150K .......... .......... .......... .......... .......... 67%  134M 0s
  9200K .......... .......... .......... .......... .......... 67% 65.2M 0s
  9250K .......... .......... .......... .......... .......... 68% 76.8M 0s
  9300K .......... .......... .......... .......... .......... 68% 84.2M 0s
  9350K .......... .......... .......... .......... .......... 68%  153M 0s
  9400K .......... .......... .......... .......... .......... 69% 43.4M 0s
  9450K .......... .......... .......... .......... .......... 69%  113M 0s
  9500K .......... .......... .......... .......... .......... 70% 38.3M 0s
  9550K .......... .......... .......... .......... .......... 70% 35.8M 0s
  9600K .......... .......... .......... .......... .......... 70%  117M 0s
  9650K .......... .......... .......... .......... .......... 71% 53.3M 0s
  9700K .......... .......... .......... .......... .......... 71%  147M 0s
  9750K .......... .......... .......... .......... .......... 71% 53.7M 0s
  9800K .......... .......... .......... .......... .......... 72% 50.5M 0s
  9850K .......... .......... .......... .......... .......... 72%  144M 0s
  9900K .......... .......... .......... .......... .......... 72%  114M 0s
  9950K .......... .......... .......... .......... .......... 73% 89.7M 0s
 10000K .......... .......... .......... .......... .......... 73% 67.6M 0s
 10050K .......... .......... .......... .......... .......... 74% 97.1M 0s
 10100K .......... .......... .......... .......... .......... 74%  137M 0s
 10150K .......... .......... .......... .......... .......... 74% 37.9M 0s
 10200K .......... .......... .......... .......... .......... 75% 77.8M 0s
 10250K .......... .......... .......... .......... .......... 75% 70.9M 0s
 10300K .......... .......... .......... .......... .......... 75%  115M 0s
 10350K .......... .......... .......... .......... .......... 76% 37.4M 0s
 10400K .......... .......... .......... .......... .......... 76% 54.1M 0s
 10450K .......... .......... .......... .......... .......... 76% 94.6M 0s
 10500K .......... .......... .......... .......... .......... 77% 53.5M 0s
 10550K .......... .......... .......... .......... .......... 77%  150M 0s
 10600K .......... .......... .......... .......... .......... 78% 44.5M 0s
 10650K .......... .......... .......... .......... .......... 78%  143M 0s
 10700K .......... .......... .......... .......... .......... 78% 56.3M 0s
 10750K .......... .......... .......... .......... .......... 79%  126M 0s
 10800K .......... .......... .......... .......... .......... 79%  105M 0s
 10850K .......... .......... .......... .......... .......... 79%  105M 0s
 10900K .......... .......... .......... .......... .......... 80% 44.3M 0s
 10950K .......... .......... .......... .......... .......... 80% 54.2M 0s
 11000K .......... .......... .......... .......... .......... 81% 83.7M 0s
 11050K .......... .......... .......... .......... .......... 81%  170M 0s
 11100K .......... .......... .......... .......... .......... 81% 34.8M 0s
 11150K .......... .......... .......... .......... .......... 82% 55.0M 0s
 11200K .......... .......... .......... .......... .......... 82%  112M 0s
 11250K .......... .......... .......... .......... .......... 82%  113M 0s
 11300K .......... .......... .......... .......... .......... 83% 60.0M 0s
 11350K .......... .......... .......... .......... .......... 83% 50.9M 0s
 11400K .......... .......... .......... .......... .......... 83%  142M 0s
 11450K .......... .......... .......... .......... .......... 84% 50.7M 0s
 11500K .......... .......... .......... .......... .......... 84%  167M 0s
 11550K .......... .......... .......... .......... .......... 85% 99.8M 0s
 11600K .......... .......... .......... .......... .......... 85%  123M 0s
 11650K .......... .......... .......... .......... .......... 85% 38.2M 0s
 11700K .......... .......... .......... .......... .......... 86% 82.6M 0s
 11750K .......... .......... .......... .......... .......... 86% 72.1M 0s
 11800K .......... .......... .......... .......... .......... 86%  103M 0s
 11850K .......... .......... .......... .......... .......... 87% 33.7M 0s
 11900K .......... .......... .......... .......... .......... 87% 62.4M 0s
 11950K .......... .......... .......... .......... .......... 87% 51.3M 0s
 12000K .......... .......... .......... .......... .......... 88% 97.0M 0s
 12050K .......... .......... .......... .......... .......... 88%  138M 0s
 12100K .......... .......... .......... .......... .......... 89% 55.1M 0s
 12150K .......... .......... .......... .......... .......... 89% 56.2M 0s
 12200K .......... .......... .......... .......... .......... 89%  130M 0s
 12250K .......... .......... .......... .......... .......... 90% 96.8M 0s
 12300K .......... .......... .......... .......... .......... 90%  128M 0s
 12350K .......... .......... .......... .......... .......... 90% 75.6M 0s
 12400K .......... .......... .......... .......... .......... 91% 45.8M 0s
 12450K .......... .......... .......... .......... .......... 91%  139M 0s
 12500K .......... .......... .......... .......... .......... 92% 52.0M 0s
 12550K .......... .......... .......... .......... .......... 92%  105M 0s
 12600K .......... .......... .......... .......... .......... 92% 36.2M 0s
 12650K .......... .......... .......... .......... .......... 93% 55.0M 0s
 12700K .......... .......... .......... .......... .......... 93%  128M 0s
 12750K .......... .......... .......... .......... .......... 93% 53.4M 0s
 12800K .......... .......... .......... .......... .......... 94%  119M 0s
 12850K .......... .......... .......... .......... .......... 94% 59.3M 0s
 12900K .......... .......... .......... .......... .......... 94% 51.9M 0s
 12950K .......... .......... .......... .......... .......... 95%  138M 0s
 13000K .......... .......... .......... .......... .......... 95%  105M 0s
 13050K .......... .......... .......... .......... .......... 96%  115M 0s
 13100K .......... .......... .......... .......... .......... 96% 88.8M 0s
 13150K .......... .......... .......... .......... .......... 96% 41.8M 0s
 13200K .......... .......... .......... .......... .......... 97%  126M 0s
 13250K .......... .......... .......... .......... .......... 97% 51.6M 0s
 13300K .......... .......... .......... .......... .......... 97%  112M 0s
 13350K .......... .......... .......... .......... .......... 98% 38.9M 0s
 13400K .......... .......... .......... .......... .......... 98%  173M 0s
 13450K .......... .......... .......... .......... .......... 98% 47.8M 0s
 13500K .......... .......... .......... .......... .......... 99% 51.6M 0s
 13550K .......... .......... .......... .......... .......... 99% 19.4M 0s
 13600K .......... .......... .......... ..........           100% 5.10M=0.2s

2022-02-10 10:02:06 (56.2 MB/s) - 'dpdk-20.11.tar.xz' saved [13967436/13967436]

--> 870f8f57585
[1/2] STEP 12/16: RUN tar -xf $DPDK_FILENAME 
--> b1aaf54bc2c
[1/2] STEP 13/16: RUN yum localinstall files/files/kernel-rt-devel-${RTK}.rpm
Loaded plugins: fastestmirror, ovl
Cannot open: files/files/kernel-rt-devel-4.18.0-305.34.2.rt7.107.el8_4.x86_64.rpm. Skipping.
Nothing to do
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
Compiler for C supports arguments -Wcast-qual: YES 
Compiler for C supports arguments -Wdeprecated: YES 
Compiler for C supports arguments -Wformat: YES 
Compiler for C supports arguments -Wformat-nonliteral: YES 
Compiler for C supports arguments -Wformat-security: YES 
Compiler for C supports arguments -Wmissing-declarations: YES 
Compiler for C supports arguments -Wmissing-prototypes: YES 
Compiler for C supports arguments -Wnested-externs: YES 
Compiler for C supports arguments -Wold-style-definition: YES 
Compiler for C supports arguments -Wpointer-arith: YES 
Compiler for C supports arguments -Wsign-compare: YES 
Compiler for C supports arguments -Wstrict-prototypes: YES 
Compiler for C supports arguments -Wundef: YES 
Compiler for C supports arguments -Wwrite-strings: YES 
Compiler for C supports arguments -Wno-address-of-packed-member -Waddress-of-packed-member: NO 
Compiler for C supports arguments -Wno-packed-not-aligned -Wpacked-not-aligned: NO 
Compiler for C supports arguments -Wno-missing-field-initializers -Wmissing-field-initializers: YES 
Fetching value of define "__SSE4_2__" : 1 
Fetching value of define "__AES__" : 1 
Fetching value of define "__AVX__" : 1 
Fetching value of define "__AVX2__" : 1 
Fetching value of define "__AVX512BW__" :  
Fetching value of define "__AVX512CD__" :  
Fetching value of define "__AVX512DQ__" :  
Fetching value of define "__AVX512F__" :  
Fetching value of define "__AVX512VL__" :  
Fetching value of define "__PCLMUL__" : 1 
Fetching value of define "__RDRND__" : 1 
Fetching value of define "__RDSEED__" : 1 
Fetching value of define "__VPCLMULQDQ__" :  
Compiler for C supports arguments -Wno-format-truncation -Wformat-truncation: NO 
Message: lib/librte_kvargs: Defining dependency "kvargs"
Message: lib/librte_telemetry: Defining dependency "telemetry"
Checking for function "getentropy" : NO 
Message: lib/librte_eal: Defining dependency "eal"
Message: lib/librte_ring: Defining dependency "ring"
Message: lib/librte_rcu: Defining dependency "rcu"
Message: lib/librte_mempool: Defining dependency "mempool"
Message: lib/librte_mbuf: Defining dependency "mbuf"
Fetching value of define "__PCLMUL__" : 1 (cached)
Fetching value of define "__AVX512F__" :  (cached)
Compiler for C supports arguments -mpclmul: YES 
Compiler for C supports arguments -maes: YES 
Compiler for C supports arguments -mavx512f: NO 
Message: lib/librte_net: Defining dependency "net"
Message: lib/librte_meter: Defining dependency "meter"
Message: lib/librte_ethdev: Defining dependency "ethdev"
Message: lib/librte_pci: Defining dependency "pci"
Message: lib/librte_cmdline: Defining dependency "cmdline"
Run-time dependency jansson found: NO (tried pkgconfig and cmake)
Message: lib/librte_metrics: Defining dependency "metrics"
Message: lib/librte_hash: Defining dependency "hash"
Message: lib/librte_timer: Defining dependency "timer"
Fetching value of define "__AVX2__" : 1 (cached)
Fetching value of define "__AVX512F__" :  (cached)
Fetching value of define "__AVX512VL__" :  (cached)
Fetching value of define "__AVX512CD__" :  (cached)
Fetching value of define "__AVX512BW__" :  (cached)
Compiler for C supports arguments -mavx512f -mavx512vl -mavx512cd -mavx512bw: NO 
Message: lib/librte_acl: Defining dependency "acl"
Message: lib/librte_bbdev: Defining dependency "bbdev"
Message: lib/librte_bitratestats: Defining dependency "bitratestats"
Message: lib/librte_cfgfile: Defining dependency "cfgfile"
Message: lib/librte_compressdev: Defining dependency "compressdev"
Message: lib/librte_cryptodev: Defining dependency "cryptodev"
Message: lib/librte_distributor: Defining dependency "distributor"
Message: lib/librte_efd: Defining dependency "efd"
Message: lib/librte_eventdev: Defining dependency "eventdev"
Message: lib/librte_gro: Defining dependency "gro"
Message: lib/librte_gso: Defining dependency "gso"
Message: lib/librte_ip_frag: Defining dependency "ip_frag"
Message: lib/librte_jobstats: Defining dependency "jobstats"
Message: lib/librte_kni: Defining dependency "kni"
Message: lib/librte_latencystats: Defining dependency "latencystats"
Message: lib/librte_lpm: Defining dependency "lpm"
Message: lib/librte_member: Defining dependency "member"
Message: lib/librte_power: Defining dependency "power"
Message: lib/librte_pdump: Defining dependency "pdump"
Message: lib/librte_rawdev: Defining dependency "rawdev"
Message: lib/librte_regexdev: Defining dependency "regexdev"
Message: lib/librte_rib: Defining dependency "rib"
Message: lib/librte_reorder: Defining dependency "reorder"
Message: lib/librte_sched: Defining dependency "sched"
Message: lib/librte_security: Defining dependency "security"
Message: lib/librte_stack: Defining dependency "stack"
Has header "linux/userfaultfd.h" : YES 
Message: lib/librte_vhost: Defining dependency "vhost"
Message: lib/librte_ipsec: Defining dependency "ipsec"
Fetching value of define "__AVX512F__" :  (cached)
Fetching value of define "__AVX512DQ__" :  (cached)
Compiler for C supports arguments -mavx512f -mavx512dq: NO 
Message: lib/librte_fib: Defining dependency "fib"
Message: lib/librte_port: Defining dependency "port"
Message: lib/librte_table: Defining dependency "table"
Message: lib/librte_pipeline: Defining dependency "pipeline"
Message: lib/librte_flow_classify: Defining dependency "flow_classify"
Run-time dependency libelf found: NO (tried pkgconfig and cmake)
Message: lib/librte_bpf: Defining dependency "bpf"
Message: lib/librte_graph: Defining dependency "graph"
Message: lib/librte_node: Defining dependency "node"
Compiler for C supports arguments -Wno-format-truncation -Wformat-truncation: NO (cached)
Message: drivers/common/cpt: Defining dependency "common_cpt"
Compiler for C supports arguments -Wno-cast-qual -Wcast-qual: YES 
Compiler for C supports arguments -Wno-pointer-arith -Wpointer-arith: YES 
Message: drivers/common/dpaax: Defining dependency "common_dpaax"
Compiler for C supports arguments -Wno-pointer-to-int-cast -Wpointer-to-int-cast: YES 
Message: drivers/common/iavf: Defining dependency "common_iavf"
Library libmusdk found: NO
Message: drivers/common/octeontx: Defining dependency "common_octeontx"
Message: drivers/common/octeontx2: Defining dependency "common_octeontx2"
Compiler for C supports arguments -Wdisabled-optimization: YES 
Compiler for C supports arguments -Waggregate-return: YES 
Compiler for C supports arguments -Wbad-function-cast: YES 
Compiler for C supports arguments -Wno-sign-compare -Wsign-compare: YES 
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES 
Compiler for C supports arguments -Wno-unused-variable -Wunused-variable: YES 
Compiler for C supports arguments -Wno-empty-body -Wempty-body: YES 
Compiler for C supports arguments -Wno-unused-but-set-variable -Wunused-but-set-variable: YES 
Message: drivers/common/sfc_efx: Defining dependency "common_sfc_efx"
Compiler for C supports arguments -Wno-cast-qual -Wcast-qual: YES (cached)
Compiler for C supports arguments -Wno-pointer-arith -Wpointer-arith: YES (cached)
Message: drivers/bus/dpaa: Defining dependency "bus_dpaa"
Message: drivers/bus/fslmc: Defining dependency "bus_fslmc"
Message: drivers/bus/ifpga: Defining dependency "bus_ifpga"
Message: drivers/bus/pci: Defining dependency "bus_pci"
Message: drivers/bus/vdev: Defining dependency "bus_vdev"
Message: drivers/bus/vmbus: Defining dependency "bus_vmbus"
Compiler for C supports arguments -std=c11: YES 
Compiler for C supports arguments -Wno-strict-prototypes -Wstrict-prototypes: YES 
Compiler for C supports arguments -D_BSD_SOURCE: YES 
Compiler for C supports arguments -D_DEFAULT_SOURCE: YES 
Compiler for C supports arguments -D_XOPEN_SOURCE=600: YES 
Run-time dependency libmlx5 found: NO (tried pkgconfig and cmake)
Library mlx5 found: NO
Run-time dependency libcrypto found: NO (tried pkgconfig and cmake)
Message: drivers/common/qat: Defining dependency "common_qat"
Message: drivers/mempool/bucket: Defining dependency "mempool_bucket"
Message: drivers/mempool/dpaa: Defining dependency "mempool_dpaa"
Message: drivers/mempool/dpaa2: Defining dependency "mempool_dpaa2"
Message: drivers/mempool/octeontx: Defining dependency "mempool_octeontx"
Message: drivers/mempool/octeontx2: Defining dependency "mempool_octeontx2"
Message: drivers/mempool/ring: Defining dependency "mempool_ring"
Message: drivers/mempool/stack: Defining dependency "mempool_stack"
Message: drivers/net/af_packet: Defining dependency "net_af_packet"
Run-time dependency libbpf found: NO (tried pkgconfig and cmake)
Library bpf found: NO
Message: drivers/net/ark: Defining dependency "net_ark"
Message: drivers/net/atlantic: Defining dependency "net_atlantic"
Message: drivers/net/avp: Defining dependency "net_avp"
Message: drivers/net/axgbe: Defining dependency "net_axgbe"
Message: drivers/net/bonding: Defining dependency "net_bond"
Run-time dependency zlib found: NO (tried pkgconfig and cmake)
Message: drivers/net/bnxt: Defining dependency "net_bnxt"
Message: drivers/net/cxgbe: Defining dependency "net_cxgbe"
Compiler for C supports arguments -Wno-pointer-arith -Wpointer-arith: YES (cached)
Message: drivers/net/dpaa: Defining dependency "net_dpaa"
Message: drivers/net/dpaa2: Defining dependency "net_dpaa2"
Compiler for C supports arguments -Wno-uninitialized -Wuninitialized: YES 
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Compiler for C supports arguments -Wno-unused-variable -Wunused-variable: YES (cached)
Compiler for C supports arguments -Wno-misleading-indentation -Wmisleading-indentation: NO 
Compiler for C supports arguments -Wno-implicit-fallthrough -Wimplicit-fallthrough: NO 
Message: drivers/net/e1000: Defining dependency "net_e1000"
Message: drivers/net/ena: Defining dependency "net_ena"
Message: drivers/net/enetc: Defining dependency "net_enetc"
Fetching value of define "__AVX2__" : 1 (cached)
Message: drivers/net/enic: Defining dependency "net_enic"
Message: drivers/net/failsafe: Defining dependency "net_failsafe"
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES 
Compiler for C supports arguments -Wno-strict-aliasing -Wstrict-aliasing: YES 
Compiler for C supports arguments -Wno-format-extra-args -Wformat-extra-args: YES 
Compiler for C supports arguments -Wno-unused-variable -Wunused-variable: YES (cached)
Compiler for C supports arguments -Wno-implicit-fallthrough -Wimplicit-fallthrough: NO (cached)
Message: drivers/net/fm10k: Defining dependency "net_fm10k"
Compiler for C supports arguments -Wno-sign-compare -Wsign-compare: YES (cached)
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES (cached)
Compiler for C supports arguments -Wno-format -Wformat: YES 
Compiler for C supports arguments -Wno-format-security -Wformat-security: YES 
Compiler for C supports arguments -Wno-format-nonliteral -Wformat-nonliteral: YES 
Compiler for C supports arguments -Wno-strict-aliasing -Wstrict-aliasing: YES (cached)
Compiler for C supports arguments -Wno-unused-but-set-variable -Wunused-but-set-variable: YES (cached)
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Fetching value of define "__AVX2__" : 1 (cached)
Message: drivers/net/i40e: Defining dependency "net_i40e"
Message: drivers/net/hinic: Defining dependency "net_hinic"
Message: drivers/net/hns3: Defining dependency "net_hns3"
Fetching value of define "__AVX2__" : 1 (cached)
Fetching value of define "__AVX512F__" :  (cached)
Compiler for C supports arguments -mavx512f: NO (cached)
Message: drivers/net/iavf: Defining dependency "net_iavf"
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES (cached)
Compiler for C supports arguments -Wno-unused-but-set-variable -Wunused-but-set-variable: YES (cached)
Compiler for C supports arguments -Wno-unused-variable -Wunused-variable: YES (cached)
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Fetching value of define "__AVX2__" : 1 (cached)
Fetching value of define "__AVX512F__" :  (cached)
Compiler for C supports arguments -mavx512f: NO (cached)
Message: drivers/net/ice: Defining dependency "net_ice"
Message: drivers/net/igc: Defining dependency "net_igc"
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES (cached)
Compiler for C supports arguments -Wno-unused-but-set-variable -Wunused-but-set-variable: YES (cached)
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Message: drivers/net/ixgbe: Defining dependency "net_ixgbe"
Message: drivers/net/kni: Defining dependency "net_kni"
Message: drivers/net/liquidio: Defining dependency "net_liquidio"
Message: drivers/net/memif: Defining dependency "net_memif"
Run-time dependency libmlx4 found: NO (tried pkgconfig and cmake)
Library mlx4 found: NO
Compiler for C supports arguments -std=c11: YES (cached)
Compiler for C supports arguments -Wno-strict-prototypes -Wstrict-prototypes: YES (cached)
Compiler for C supports arguments -D_BSD_SOURCE: YES (cached)
Compiler for C supports arguments -D_DEFAULT_SOURCE: YES (cached)
Compiler for C supports arguments -D_XOPEN_SOURCE=600: YES (cached)
Message: Disabling mlx5 [drivers/net/mlx5]: missing internal dependency "common_mlx5"
Library libmusdk found: NO
Library libmusdk found: NO
Message: drivers/net/netvsc: Defining dependency "net_netvsc"
Run-time dependency netcope-common found: NO (tried pkgconfig and cmake)
Message: drivers/net/nfp: Defining dependency "net_nfp"
Message: drivers/net/null: Defining dependency "net_null"
Message: drivers/net/octeontx: Defining dependency "net_octeontx"
Compiler for C supports arguments -flax-vector-conversions: YES 
Message: drivers/net/octeontx2: Defining dependency "net_octeontx2"
Compiler for C supports arguments -Wno-pointer-arith -Wpointer-arith: YES (cached)
Message: drivers/net/pfe: Defining dependency "net_pfe"
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Compiler for C supports arguments -Wno-sign-compare -Wsign-compare: YES (cached)
Compiler for C supports arguments -Wno-missing-prototypes -Wmissing-prototypes: YES 
Compiler for C supports arguments -Wno-cast-qual -Wcast-qual: YES (cached)
Compiler for C supports arguments -Wno-unused-function -Wunused-function: YES 
Compiler for C supports arguments -Wno-unused-variable -Wunused-variable: YES (cached)
Compiler for C supports arguments -Wno-strict-aliasing -Wstrict-aliasing: YES (cached)
Compiler for C supports arguments -Wno-missing-prototypes -Wmissing-prototypes: YES (cached)
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES (cached)
Compiler for C supports arguments -Wno-format-nonliteral -Wformat-nonliteral: YES (cached)
Compiler for C supports arguments -Wno-shift-negative-value -Wshift-negative-value: NO 
Compiler for C supports arguments -Wno-unused-but-set-variable -Wunused-but-set-variable: YES (cached)
Compiler for C supports arguments -Wno-missing-declarations -Wmissing-declarations: YES 
Compiler for C supports arguments -Wno-maybe-uninitialized -Wmaybe-uninitialized: YES 
Compiler for C supports arguments -Wno-strict-prototypes -Wstrict-prototypes: YES (cached)
Compiler for C supports arguments -Wno-shift-negative-value -Wshift-negative-value: NO (cached)
Compiler for C supports arguments -Wno-implicit-fallthrough -Wimplicit-fallthrough: NO (cached)
Compiler for C supports arguments -Wno-format-extra-args -Wformat-extra-args: YES (cached)
Compiler for C supports arguments -Wno-visibility -Wvisibility: NO 
Compiler for C supports arguments -Wno-empty-body -Wempty-body: YES (cached)
Compiler for C supports arguments -Wno-invalid-source-encoding -Winvalid-source-encoding: NO 
Compiler for C supports arguments -Wno-sometimes-uninitialized -Wsometimes-uninitialized: NO 
Compiler for C supports arguments -Wno-pointer-bool-conversion -Wpointer-bool-conversion: NO 
Compiler for C supports arguments -Wno-format-nonliteral -Wformat-nonliteral: YES (cached)
Message: drivers/net/qede: Defining dependency "net_qede"
Message: drivers/net/ring: Defining dependency "net_ring"
Compiler for C supports arguments -Wno-strict-aliasing -Wstrict-aliasing: YES (cached)
Compiler for C supports arguments -Wdisabled-optimization: YES (cached)
Compiler for C supports arguments -Waggregate-return: YES (cached)
Compiler for C supports arguments -Wbad-function-cast: YES (cached)
Message: drivers/net/sfc: Defining dependency "net_sfc"
Message: drivers/net/softnic: Defining dependency "net_softnic"
Run-time dependency libsze2 found: NO (tried pkgconfig and cmake)
Header <linux/pkt_cls.h> has symbol "TCA_FLOWER_UNSPEC" : YES 
Header <linux/pkt_cls.h> has symbol "TCA_FLOWER_KEY_VLAN_PRIO" : YES 
Header <linux/pkt_cls.h> has symbol "TCA_BPF_UNSPEC" : YES 
Header <linux/pkt_cls.h> has symbol "TCA_BPF_FD" : NO 
Header <linux/tc_act/tc_bpf.h> has symbol "TCA_ACT_BPF_UNSPEC" : NO 
Header <linux/tc_act/tc_bpf.h> has symbol "TCA_ACT_BPF_FD" : NO 
Configuring tap_autoconf.h using configuration
Message: drivers/net/tap: Defining dependency "net_tap"
Compiler for C supports arguments -fno-prefetch-loop-arrays: YES 
Compiler for C supports arguments -Wno-maybe-uninitialized -Wmaybe-uninitialized: YES (cached)
Message: drivers/net/thunderx: Defining dependency "net_thunderx"
Message: drivers/net/txgbe: Defining dependency "net_txgbe"
Compiler for C supports arguments -D_BSD_SOURCE: YES (cached)
Compiler for C supports arguments -D_DEFAULT_SOURCE: YES (cached)
Compiler for C supports arguments -D_XOPEN_SOURCE=600: YES (cached)
Message: drivers/net/vdev_netvsc: Defining dependency "net_vdev_netvsc"
Message: drivers/net/vhost: Defining dependency "net_vhost"
Compiler for C supports arguments -mavx512f: NO (cached)
Message: drivers/net/virtio: Defining dependency "net_virtio"
Compiler for C supports arguments -Wno-unused-parameter -Wunused-parameter: YES (cached)
Compiler for C supports arguments -Wno-unused-value -Wunused-value: YES (cached)
Compiler for C supports arguments -Wno-strict-aliasing -Wstrict-aliasing: YES (cached)
Compiler for C supports arguments -Wno-format-extra-args -Wformat-extra-args: YES (cached)
Message: drivers/net/vmxnet3: Defining dependency "net_vmxnet3"
Message: drivers/raw/dpaa2_cmdif: Defining dependency "raw_dpaa2_cmdif"
Message: drivers/raw/dpaa2_qdma: Defining dependency "raw_dpaa2_qdma"
Message: drivers/raw/ioat: Defining dependency "raw_ioat"
Message: drivers/raw/ntb: Defining dependency "raw_ntb"
Message: drivers/raw/octeontx2_dma: Defining dependency "raw_octeontx2_dma"
Message: drivers/raw/octeontx2_ep: Defining dependency "raw_octeontx2_ep"
Message: drivers/raw/skeleton: Defining dependency "raw_skeleton"
Library IPSec_MB found: NO
Library IPSec_MB found: NO
Run-time dependency libaarch64crypto found: NO (tried pkgconfig and cmake)
Message: drivers/crypto/bcmfs: Defining dependency "crypto_bcmfs"
Message: drivers/crypto/caam_jr: Defining dependency "crypto_caam_jr"
Run-time dependency libcrypto found: NO (tried pkgconfig and cmake)
Message: drivers/crypto/dpaa_sec: Defining dependency "crypto_dpaa_sec"
Message: drivers/crypto/dpaa2_sec: Defining dependency "crypto_dpaa2_sec"
Library IPSec_MB found: NO
Library libmusdk found: NO
Message: drivers/crypto/nitrox: Defining dependency "crypto_nitrox"
Message: drivers/crypto/null: Defining dependency "crypto_null"
Message: drivers/crypto/octeontx: Defining dependency "crypto_octeontx"
Message: drivers/crypto/octeontx2: Defining dependency "crypto_octeontx2"
Run-time dependency libcrypto found: NO (tried pkgconfig and cmake)
Message: drivers/crypto/scheduler: Defining dependency "crypto_scheduler"
Library IPSec_MB found: NO
Message: drivers/crypto/virtio: Defining dependency "crypto_virtio"
Library IPSec_MB found: NO
Run-time dependency libisal found: NO (tried pkgconfig and cmake)
Message: drivers/compress/octeontx: Defining dependency "compress_octeontx"
Run-time dependency zlib found: NO (tried pkgconfig and cmake)
Compiler for C supports arguments -std=c11: YES (cached)
Compiler for C supports arguments -Wno-strict-prototypes -Wstrict-prototypes: YES (cached)
Compiler for C supports arguments -D_BSD_SOURCE: YES (cached)
Compiler for C supports arguments -D_DEFAULT_SOURCE: YES (cached)
Compiler for C supports arguments -D_XOPEN_SOURCE=600: YES (cached)
Message: Disabling mlx5 [drivers/regex/mlx5]: missing internal dependency "common_mlx5"
Library librxp_compiler found: NO
Message: drivers/regex/octeontx2: Defining dependency "regex_octeontx2"
Message: drivers/vdpa/ifc: Defining dependency "vdpa_ifc"
Compiler for C supports arguments -std=c11: YES (cached)
Compiler for C supports arguments -Wno-strict-prototypes -Wstrict-prototypes: YES (cached)
Compiler for C supports arguments -D_BSD_SOURCE: YES (cached)
Compiler for C supports arguments -D_DEFAULT_SOURCE: YES (cached)
Compiler for C supports arguments -D_XOPEN_SOURCE=600: YES (cached)
Message: Disabling mlx5 [drivers/vdpa/mlx5]: missing internal dependency "common_mlx5"
Message: drivers/event/dlb: Defining dependency "event_dlb"
Message: drivers/event/dlb2: Defining dependency "event_dlb2"
Message: drivers/event/dpaa: Defining dependency "event_dpaa"
Message: drivers/event/dpaa2: Defining dependency "event_dpaa2"
Message: drivers/event/octeontx2: Defining dependency "event_octeontx2"
Message: drivers/event/opdl: Defining dependency "event_opdl"
Message: drivers/event/skeleton: Defining dependency "event_skeleton"
Message: drivers/event/sw: Defining dependency "event_sw"
Compiler for C supports arguments -Wno-format-nonliteral -Wformat-nonliteral: YES (cached)
Message: drivers/event/dsw: Defining dependency "event_dsw"
Message: drivers/event/octeontx: Defining dependency "event_octeontx"
Message: drivers/baseband/null: Defining dependency "baseband_null"
Library libturbo found: NO
Library libldpc_decoder_5gnr found: NO
Message: drivers/baseband/turbo_sw: Defining dependency "baseband_turbo_sw"
Message: drivers/baseband/fpga_lte_fec: Defining dependency "baseband_fpga_lte_fec"
Message: drivers/baseband/fpga_5gnr_fec: Defining dependency "baseband_fpga_5gnr_fec"
Message: drivers/baseband/acc100: Defining dependency "baseband_acc100"
Library execinfo found: NO
Compiler for C supports arguments -Wno-format-truncation -Wformat-truncation: NO (cached)
Run-time dependency zlib found: NO (tried pkgconfig and cmake)
Library execinfo found: NO
Message: hugepage availability: false
Program get-coremask.sh found: YES
Program doxygen found: NO
Program sphinx-build found: NO
Library execinfo found: NO
Configuring rte_build_config.h using configuration
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
[6/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_class.c.o
[7/2405] Compiling C object lib/librte_telemetry.a.p/librte_telemetry_telemetry_data.c.o
[8/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_debug.c.o
[9/2405] Compiling C object lib/librte_kvargs.a.p/librte_kvargs_rte_kvargs.c.o
[10/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_hypervisor.c.o
[11/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_errno.c.o
[12/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_config.c.o
[13/2405] Linking static target lib/librte_kvargs.a
[14/2405] Compiling C object lib/librte_telemetry.a.p/librte_telemetry_telemetry_legacy.c.o
[15/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_bus.c.o
[16/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_hexdump.c.o
[17/2405] Compiling C object buildtools/pmdinfogen/pmdinfogen.p/pmdinfogen.c.o
[18/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_devargs.c.o
[19/2405] Compiling C object lib/librte_mbuf.a.p/librte_mbuf_rte_mbuf_ptype.c.o
[20/2405] Compiling C object lib/librte_telemetry.a.p/librte_telemetry_telemetry.c.o
[21/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_launch.c.o
[22/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_dev.c.o
[23/2405] Linking target buildtools/pmdinfogen/pmdinfogen
[24/2405] Linking static target lib/librte_telemetry.a
[25/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_mcfg.c.o
[26/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_log.c.o
[27/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_string_fns.c.o
[28/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_memalloc.c.o
[29/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_lcore.c.o
[30/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_tailqs.c.o
[31/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_memzone.c.o
[32/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_timer.c.o
[33/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_fbarray.c.o
[34/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_memory.c.o
[35/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_thread.c.o
[36/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_trace_ctf.c.o
[37/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_trace.c.o
[38/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_uuid.c.o
[39/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_trace_utils.c.o
[40/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_trace_points.c.o
[41/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_proc.c.o
[42/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_hotplug_mp.c.o
[43/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_rte_reciprocal.c.o
[44/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_rte_keepalive.c.o
[45/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_malloc_elem.c.o
[46/2405] Compiling C object lib/librte_mbuf.a.p/librte_mbuf_rte_mbuf.c.o
[47/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_malloc_mp.c.o
[48/2405] Compiling C object lib/librte_eal.a.p/librte_eal_unix_eal_unix_memory.c.o
[49/2405] Compiling C object lib/librte_eal.a.p/librte_eal_unix_eal_file.c.o
[50/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_rte_random.c.o
[51/2405] Compiling C object lib/librte_eal.a.p/librte_eal_unix_eal_unix_timer.c.o
[52/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_cpuflags.c.o
[53/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_dynmem.c.o
[54/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_debug.c.o
[55/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_alarm.c.o
[56/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_rte_malloc.c.o
[57/2405] Generating kvargs.sym_chk with a meson_exe.py custom command
[58/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_malloc_heap.c.o
[59/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_rte_service.c.o
[60/2405] Linking target lib/librte_kvargs.so.21.0
[61/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_lcore.c.o
[62/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_dev.c.o
[63/2405] Compiling C object lib/librte_eal.a.p/librte_eal_common_eal_common_options.c.o
[64/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_log.c.o
[65/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_hugepage_info.c.o
[66/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_timer.c.o
[67/2405] Compiling C object lib/librte_eal.a.p/librte_eal_x86_rte_spinlock.c.o
[68/2405] Generating rte_eal_mingw with a custom command
[69/2405] Compiling C object lib/librte_eal.a.p/librte_eal_x86_rte_cpuflags.c.o
[70/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_thread.c.o
[71/2405] Compiling C object lib/librte_eal.a.p/librte_eal_x86_rte_hypervisor.c.o
[72/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal.c.o
[73/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_vfio_mp_sync.c.o
[74/2405] Generating rte_ring_def with a custom command
[75/2405] Generating rte_ring_mingw with a custom command
[76/2405] Generating rte_eal_def with a custom command
[77/2405] Compiling C object lib/librte_eal.a.p/librte_eal_x86_rte_cycles.c.o
[78/2405] Generating rte_rcu_mingw with a custom command
[79/2405] Generating rte_rcu_def with a custom command
[80/2405] Generating rte_meter_mingw with a custom command
[81/2405] Generating rte_mempool_def with a custom command
[82/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_interrupts.c.o
[83/2405] Generating rte_mempool_mingw with a custom command
[84/2405] Generating rte_cryptodev_def with a custom command
[85/2405] Compiling C object lib/librte_ring.a.p/librte_ring_rte_ring.c.o
[86/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_memalloc.c.o
[87/2405] Linking static target lib/librte_ring.a
[88/2405] Compiling C object lib/librte_mempool.a.p/librte_mempool_rte_mempool_ops_default.c.o
[89/2405] Compiling C object lib/librte_mempool.a.p/librte_mempool_mempool_trace_points.c.o
[90/2405] Compiling C object lib/librte_mempool.a.p/librte_mempool_rte_mempool_ops.c.o
[91/2405] Generating rte_mbuf_def with a custom command
[92/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_memory.c.o
[93/2405] Generating telemetry.sym_chk with a meson_exe.py custom command
[94/2405] Generating rte_mbuf_mingw with a custom command
[95/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_ethdev_private.c.o
[96/2405] Compiling C object lib/librte_mbuf.a.p/librte_mbuf_rte_mbuf_pool_ops.c.o
[97/2405] Compiling C object lib/librte_eal.a.p/librte_eal_linux_eal_vfio.c.o
[98/2405] Compiling C object lib/librte_cryptodev.a.p/librte_cryptodev_cryptodev_trace_points.c.o
[99/2405] Linking target lib/librte_telemetry.so.21.0
[100/2405] Generating rte_net_def with a custom command
[101/2405] Linking static target lib/librte_eal.a
[102/2405] Compiling C object lib/librte_mempool.a.p/librte_mempool_rte_mempool.c.o
[103/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline.c.o
[104/2405] Generating rte_net_mingw with a custom command
[105/2405] Linking static target lib/librte_mempool.a
[106/2405] Generating symbol file lib/librte_kvargs.so.21.0.p/librte_kvargs.so.21.0.symbols
[107/2405] Compiling C object lib/librte_net.a.p/librte_net_net_crc_sse.c.o
[108/2405] Compiling C object lib/librte_net.a.p/librte_net_rte_ether.c.o
[109/2405] Compiling C object lib/librte_net.a.p/librte_net_rte_net_crc.c.o
[110/2405] Generating rte_meter_def with a custom command
[111/2405] Compiling C object lib/librte_mbuf.a.p/librte_mbuf_rte_mbuf_dyn.c.o
[112/2405] Generating rte_bbdev_mingw with a custom command
[113/2405] Linking static target lib/librte_mbuf.a
[114/2405] Compiling C object lib/librte_net.a.p/librte_net_rte_arp.c.o
[115/2405] Compiling C object lib/librte_rcu.a.p/librte_rcu_rte_rcu_qsbr.c.o
[116/2405] Linking static target lib/librte_rcu.a
[117/2405] Compiling C object lib/librte_net.a.p/librte_net_rte_net.c.o
[118/2405] Compiling C object lib/librte_meter.a.p/librte_meter_rte_meter.c.o
[119/2405] Linking static target lib/librte_meter.a
[120/2405] Linking static target lib/librte_net.a
[121/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_ethdev_profile.c.o
[122/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_ethdev_trace_points.c.o
[123/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_rte_class_eth.c.o
[124/2405] Generating ring.sym_chk with a meson_exe.py custom command
[125/2405] Generating rte_ethdev_def with a custom command
[126/2405] Generating symbol file lib/librte_telemetry.so.21.0.p/librte_telemetry.so.21.0.symbols
[127/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_rte_mtr.c.o
[128/2405] Generating rte_ethdev_mingw with a custom command
[129/2405] Generating rte_pci_def with a custom command
[130/2405] Generating rte_pci_mingw with a custom command
[131/2405] Compiling C object lib/librte_pdump.a.p/librte_pdump_rte_pdump.c.o
[132/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_rte_tm.c.o
[133/2405] Compiling C object lib/librte_pci.a.p/librte_pci_rte_pci.c.o
[134/2405] Linking static target lib/librte_pci.a
[135/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_cirbuf.c.o
[136/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse_ipaddr.c.o
[137/2405] Generating mempool.sym_chk with a meson_exe.py custom command
[138/2405] Compiling C object lib/librte_efd.a.p/librte_efd_rte_efd.c.o
[139/2405] Compiling C object lib/librte_compressdev.a.p/librte_compressdev_rte_comp.c.o
[140/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse.c.o
[141/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse_num.c.o
[142/2405] Generating rcu.sym_chk with a meson_exe.py custom command
[143/2405] Generating meter.sym_chk with a meson_exe.py custom command
[144/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse_portlist.c.o
[145/2405] Generating net.sym_chk with a meson_exe.py custom command
[146/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse_string.c.o
[147/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_parse_etheraddr.c.o
[148/2405] Generating rte_cmdline_def with a custom command
[149/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_socket.c.o
[150/2405] Generating rte_cmdline_mingw with a custom command
[151/2405] Generating rte_metrics_def with a custom command
[152/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_rte_flow.c.o
[153/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_vt100.c.o
[154/2405] Generating rte_metrics_mingw with a custom command
[155/2405] Generating rte_hash_def with a custom command
[156/2405] Generating rte_hash_mingw with a custom command
[157/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_os_unix.c.o
[158/2405] Generating rte_timer_def with a custom command
[159/2405] Generating rte_timer_mingw with a custom command
[160/2405] Generating mbuf.sym_chk with a meson_exe.py custom command
[161/2405] Compiling C object lib/librte_cmdline.a.p/librte_cmdline_cmdline_rdline.c.o
[162/2405] Linking static target lib/librte_cmdline.a
[163/2405] Compiling C object lib/librte_hash.a.p/librte_hash_rte_fbk_hash.c.o
[164/2405] Compiling C object lib/librte_metrics.a.p/librte_metrics_rte_metrics.c.o
[165/2405] Linking static target lib/librte_metrics.a
[166/2405] Compiling C object lib/librte_acl.a.p/librte_acl_tb_mem.c.o
[167/2405] Compiling C object lib/librte_acl.a.p/librte_acl_rte_acl.c.o
[168/2405] Generating rte_acl_def with a custom command
[169/2405] Compiling C object lib/librte_timer.a.p/librte_timer_rte_timer.c.o
[170/2405] Compiling C object lib/librte_acl.a.p/librte_acl_acl_gen.c.o
[171/2405] Linking static target lib/librte_timer.a
[172/2405] Generating rte_acl_mingw with a custom command
[173/2405] Compiling C object lib/librte_acl.a.p/librte_acl_acl_run_scalar.c.o
[174/2405] Generating rte_bbdev_def with a custom command
[175/2405] Generating rte_bitratestats_mingw with a custom command
[176/2405] Generating rte_bitratestats_def with a custom command
[177/2405] Generating pci.sym_chk with a meson_exe.py custom command
[178/2405] Generating rte_cfgfile_def with a custom command
[179/2405] Generating rte_cfgfile_mingw with a custom command
[180/2405] Compiling C object lib/librte_bbdev.a.p/librte_bbdev_rte_bbdev.c.o
[181/2405] Compiling C object lib/librte_bitratestats.a.p/librte_bitratestats_rte_bitrate.c.o
[182/2405] Linking static target lib/librte_bbdev.a
[183/2405] Compiling C object lib/librte_cfgfile.a.p/librte_cfgfile_rte_cfgfile.c.o
[184/2405] Linking static target lib/librte_bitratestats.a
[185/2405] Compiling C object lib/librte_compressdev.a.p/librte_compressdev_rte_compressdev_pmd.c.o
[186/2405] Linking static target lib/librte_cfgfile.a
[187/2405] Generating rte_compressdev_mingw with a custom command
[188/2405] Compiling C object lib/librte_ethdev.a.p/librte_ethdev_rte_ethdev.c.o
[189/2405] Generating rte_compressdev_def with a custom command
[190/2405] Linking static target lib/librte_ethdev.a
[191/2405] Compiling C object lib/librte_compressdev.a.p/librte_compressdev_rte_compressdev.c.o
[192/2405] Linking static target lib/librte_compressdev.a
[193/2405] Generating cmdline.sym_chk with a meson_exe.py custom command
[194/2405] Compiling C object lib/librte_acl.a.p/librte_acl_acl_run_sse.c.o
[195/2405] Generating metrics.sym_chk with a meson_exe.py custom command
[196/2405] Compiling C object lib/librte_acl.a.p/librte_acl_acl_run_avx2.c.o
[197/2405] Generating rte_cryptodev_mingw with a custom command
[198/2405] Compiling C object lib/librte_cryptodev.a.p/librte_cryptodev_rte_cryptodev_pmd.c.o
[199/2405] Generating timer.sym_chk with a meson_exe.py custom command
[200/2405] Compiling C object lib/librte_acl.a.p/librte_acl_acl_bld.c.o
[201/2405] Linking static target lib/librte_acl.a
[202/2405] Compiling C object lib/librte_distributor.a.p/librte_distributor_rte_distributor_match_sse.c.o
[203/2405] Generating rte_distributor_mingw with a custom command
[204/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_swx_ctl.c.o
[205/2405] Compiling C object lib/librte_distributor.a.p/librte_distributor_rte_distributor_single.c.o
[206/2405] Generating rte_distributor_def with a custom command
[207/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_swx_pipeline_spec.c.o
[208/2405] Generating cfgfile.sym_chk with a meson_exe.py custom command
[209/2405] Linking static target lib/librte_efd.a
[210/2405] Generating bitratestats.sym_chk with a meson_exe.py custom command
[211/2405] Generating rte_efd_def with a custom command
[212/2405] Generating rte_efd_mingw with a custom command
[213/2405] Compiling C object lib/librte_distributor.a.p/librte_distributor_rte_distributor.c.o
[214/2405] Compiling C object lib/librte_cryptodev.a.p/librte_cryptodev_rte_cryptodev.c.o
[215/2405] Linking static target lib/librte_distributor.a
[216/2405] Linking static target lib/librte_cryptodev.a
[217/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf_load.c.o
[218/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_event_ring.c.o
[219/2405] Compiling C object lib/librte_gro.a.p/librte_gro_gro_tcp4.c.o
[220/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf_exec.c.o
[221/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_eventdev_trace_points.c.o
[222/2405] Generating acl.sym_chk with a meson_exe.py custom command
[223/2405] Generating bbdev.sym_chk with a meson_exe.py custom command
[224/2405] Generating rte_eventdev_def with a custom command
[225/2405] Generating rte_eventdev_mingw with a custom command
[226/2405] Compiling C object lib/librte_hash.a.p/librte_hash_rte_cuckoo_hash.c.o
[227/2405] Linking static target lib/librte_hash.a
[228/2405] Generating efd.sym_chk with a meson_exe.py custom command
[229/2405] Generating compressdev.sym_chk with a meson_exe.py custom command
[230/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_eventdev.c.o
[231/2405] Generating distributor.sym_chk with a meson_exe.py custom command
[232/2405] Generating rte_gro_mingw with a custom command
[233/2405] Generating rte_gro_def with a custom command
[234/2405] Compiling C object lib/librte_gro.a.p/librte_gro_rte_gro.c.o
[235/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_event_timer_adapter.c.o
[236/2405] Compiling C object lib/librte_gro.a.p/librte_gro_gro_udp4.c.o
[237/2405] Compiling C object lib/librte_gro.a.p/librte_gro_gro_vxlan_tcp4.c.o
[238/2405] Generating rte_gso_def with a custom command
[239/2405] Compiling C object lib/librte_gso.a.p/librte_gso_gso_udp4.c.o
[240/2405] Compiling C object lib/librte_gso.a.p/librte_gso_gso_tcp4.c.o
[241/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_event_eth_tx_adapter.c.o
[242/2405] Generating rte_gso_mingw with a custom command
[243/2405] Compiling C object lib/librte_gso.a.p/librte_gso_gso_tunnel_tcp4.c.o
[244/2405] Compiling C object lib/librte_gro.a.p/librte_gro_gro_vxlan_udp4.c.o
[245/2405] Compiling C object lib/librte_gso.a.p/librte_gso_rte_gso.c.o
[246/2405] Linking static target lib/librte_gro.a
[247/2405] Generating eal.sym_chk with a meson_exe.py custom command
[248/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_rte_ipv4_reassembly.c.o
[249/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_rte_ipv6_reassembly.c.o
[250/2405] Linking target lib/librte_eal.so.21.0
[251/2405] Generating rte_ip_frag_def with a custom command
[252/2405] Generating rte_ip_frag_mingw with a custom command
[253/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_ip_frag_internal.c.o
[254/2405] Generating cryptodev.sym_chk with a meson_exe.py custom command
[255/2405] Compiling C object lib/librte_gso.a.p/librte_gso_gso_common.c.o
[256/2405] Linking static target lib/librte_gso.a
[257/2405] Generating rte_jobstats_def with a custom command
[258/2405] Generating rte_jobstats_mingw with a custom command
[259/2405] Generating hash.sym_chk with a meson_exe.py custom command
[260/2405] Generating rte_kni_def with a custom command
[261/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_rte_ip_frag_common.c.o
[262/2405] Generating rte_kni_mingw with a custom command
[263/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_event_eth_rx_adapter.c.o
[264/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_rte_ipv6_fragmentation.c.o
[265/2405] Compiling C object lib/librte_ip_frag.a.p/librte_ip_frag_rte_ipv4_fragmentation.c.o
[266/2405] Generating rte_latencystats_def with a custom command
[267/2405] Linking static target lib/librte_ip_frag.a
[268/2405] Generating rte_latencystats_mingw with a custom command
[269/2405] Compiling C object lib/librte_jobstats.a.p/librte_jobstats_rte_jobstats.c.o
[270/2405] Linking static target lib/librte_jobstats.a
[271/2405] Generating rte_lpm_def with a custom command
[272/2405] Compiling C object lib/librte_eventdev.a.p/librte_eventdev_rte_event_crypto_adapter.c.o
[273/2405] Generating rte_lpm_mingw with a custom command
[274/2405] Linking static target lib/librte_eventdev.a
[275/2405] Compiling C object lib/librte_flow_classify.a.p/librte_flow_classify_rte_flow_classify.c.o
[276/2405] Compiling C object lib/librte_member.a.p/librte_member_rte_member.c.o
[277/2405] Generating rte_member_def with a custom command
[278/2405] Generating rte_member_mingw with a custom command
[279/2405] Compiling C object lib/librte_latencystats.a.p/librte_latencystats_rte_latencystats.c.o
[280/2405] Generating gro.sym_chk with a meson_exe.py custom command
[281/2405] Linking static target lib/librte_latencystats.a
[282/2405] Compiling C object lib/librte_lpm.a.p/librte_lpm_rte_lpm.c.o
[283/2405] Generating symbol file lib/librte_eal.so.21.0.p/librte_eal.so.21.0.symbols
[284/2405] Compiling C object lib/librte_power.a.p/librte_power_rte_power.c.o
[285/2405] Compiling C object lib/librte_power.a.p/librte_power_power_kvm_vm.c.o
[286/2405] Compiling C object lib/librte_lpm.a.p/librte_lpm_rte_lpm6.c.o
[287/2405] Linking target lib/librte_ring.so.21.0
[288/2405] Compiling C object lib/librte_member.a.p/librte_member_rte_member_vbf.c.o
[289/2405] Linking target lib/librte_meter.so.21.0
[290/2405] Linking target lib/librte_pci.so.21.0
[291/2405] Linking target lib/librte_metrics.so.21.0
[292/2405] Linking target lib/librte_timer.so.21.0
[293/2405] Generating gso.sym_chk with a meson_exe.py custom command
[294/2405] Compiling C object lib/librte_kni.a.p/librte_kni_rte_kni.c.o
[295/2405] Linking target lib/librte_acl.so.21.0
[296/2405] Compiling C object lib/librte_power.a.p/librte_power_power_acpi_cpufreq.c.o
[297/2405] Linking target lib/librte_cfgfile.so.21.0
[298/2405] Linking static target lib/librte_lpm.a
[299/2405] Generating jobstats.sym_chk with a meson_exe.py custom command
[300/2405] Linking static target lib/librte_kni.a
[301/2405] Generating ip_frag.sym_chk with a meson_exe.py custom command
[302/2405] Linking target lib/librte_jobstats.so.21.0
[303/2405] Compiling C object lib/librte_member.a.p/librte_member_rte_member_ht.c.o
[304/2405] Linking static target lib/librte_member.a
[305/2405] Generating ethdev.sym_chk with a meson_exe.py custom command
[306/2405] Compiling C object lib/librte_power.a.p/librte_power_guest_channel.c.o
[307/2405] Generating eventdev.sym_chk with a meson_exe.py custom command
[308/2405] Compiling C object lib/librte_power.a.p/librte_power_power_common.c.o
[309/2405] Generating rte_power_mingw with a custom command
[310/2405] Generating rte_power_def with a custom command
[311/2405] Generating rte_mempool_bucket_mingw with a custom command
[312/2405] Compiling C object lib/librte_power.a.p/librte_power_rte_power_empty_poll.c.o
[313/2405] Linking static target lib/librte_pdump.a
[314/2405] Generating latencystats.sym_chk with a meson_exe.py custom command
[315/2405] Generating rte_pdump_def with a custom command
[316/2405] Generating rte_pdump_mingw with a custom command
[317/2405] Generating symbol file lib/librte_meter.so.21.0.p/librte_meter.so.21.0.symbols
[318/2405] Generating rte_rawdev_def with a custom command
[319/2405] Generating symbol file lib/librte_ring.so.21.0.p/librte_ring.so.21.0.symbols
[320/2405] Generating symbol file lib/librte_pci.so.21.0.p/librte_pci.so.21.0.symbols
[321/2405] Generating rte_rawdev_mingw with a custom command
[322/2405] Generating symbol file lib/librte_metrics.so.21.0.p/librte_metrics.so.21.0.symbols
[323/2405] Generating rte_regexdev_def with a custom command
[324/2405] Compiling C object lib/librte_power.a.p/librte_power_power_pstate_cpufreq.c.o
[325/2405] Generating rte_regexdev_mingw with a custom command
[326/2405] Linking target lib/librte_mempool.so.21.0
[327/2405] Generating symbol file lib/librte_timer.so.21.0.p/librte_timer.so.21.0.symbols
[328/2405] Linking target lib/librte_rcu.so.21.0
[329/2405] Linking static target lib/librte_power.a
[330/2405] Generating symbol file lib/librte_acl.so.21.0.p/librte_acl.so.21.0.symbols
[331/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_pmd.c.o
[332/2405] Generating rte_rib_def with a custom command
[333/2405] Generating rte_rib_mingw with a custom command
[334/2405] Generating lpm.sym_chk with a meson_exe.py custom command
[335/2405] Generating rte_reorder_mingw with a custom command
[336/2405] Generating rte_reorder_def with a custom command
[337/2405] Compiling C object lib/librte_rawdev.a.p/librte_rawdev_rte_rawdev.c.o
[338/2405] Generating kni.sym_chk with a meson_exe.py custom command
[339/2405] Linking static target lib/librte_rawdev.a
[340/2405] Compiling C object lib/librte_regexdev.a.p/librte_regexdev_rte_regexdev.c.o
[341/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx2.a.p/mempool_octeontx2_otx2_mempool_irq.c.o
[342/2405] Generating member.sym_chk with a meson_exe.py custom command
[343/2405] Linking static target lib/librte_regexdev.a
[344/2405] Compiling C object lib/librte_sched.a.p/librte_sched_rte_red.c.o
[345/2405] Compiling C object lib/librte_sched.a.p/librte_sched_rte_approx.c.o
[346/2405] Generating rte_sched_mingw with a custom command
[347/2405] Compiling C object lib/librte_rib.a.p/librte_rib_rte_rib.c.o
[348/2405] Generating rte_sched_def with a custom command
[349/2405] Generating rte_security_mingw with a custom command
[350/2405] Generating rte_security_def with a custom command
[351/2405] Generating rte_stack_def with a custom command
[352/2405] Compiling C object lib/librte_rib.a.p/librte_rib_rte_rib6.c.o
[353/2405] Linking static target lib/librte_rib.a
[354/2405] Compiling C object lib/librte_stack.a.p/librte_stack_rte_stack_std.c.o
[355/2405] Generating rte_stack_mingw with a custom command
[356/2405] Compiling C object lib/librte_stack.a.p/librte_stack_rte_stack_lf.c.o
[357/2405] Compiling C object lib/librte_stack.a.p/librte_stack_rte_stack.c.o
[358/2405] Generating pdump.sym_chk with a meson_exe.py custom command
[359/2405] Linking static target lib/librte_stack.a
[360/2405] Generating symbol file lib/librte_mempool.so.21.0.p/librte_mempool.so.21.0.symbols
[361/2405] Compiling C object lib/librte_security.a.p/librte_security_rte_security.c.o
[362/2405] Linking static target lib/librte_security.a
[363/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_fd_man.c.o
[364/2405] Compiling C object lib/librte_reorder.a.p/librte_reorder_rte_reorder.c.o
[365/2405] Linking target lib/librte_mbuf.so.21.0
[366/2405] Generating symbol file lib/librte_rcu.so.21.0.p/librte_rcu.so.21.0.symbols
[367/2405] Linking static target lib/librte_reorder.a
[368/2405] Linking target lib/librte_hash.so.21.0
[369/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_vdpa.c.o
[370/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_iotlb.c.o
[371/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_socket.c.o
[372/2405] Generating rawdev.sym_chk with a meson_exe.py custom command
[373/2405] Generating power.sym_chk with a meson_exe.py custom command
[374/2405] Linking target lib/librte_rawdev.so.21.0
[375/2405] Linking target lib/librte_power.so.21.0
[376/2405] Generating rte_vhost_def with a custom command
[377/2405] Generating rte_vhost_mingw with a custom command
[378/2405] Generating stack.sym_chk with a meson_exe.py custom command
[379/2405] Linking target lib/librte_stack.so.21.0
[380/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_vhost.c.o
[381/2405] Generating symbol file lib/librte_mbuf.so.21.0.p/librte_mbuf.so.21.0.symbols
[382/2405] Generating symbol file lib/librte_hash.so.21.0.p/librte_hash.so.21.0.symbols
[383/2405] Compiling C object lib/librte_sched.a.p/librte_sched_rte_sched.c.o
[384/2405] Linking target lib/librte_net.so.21.0
[385/2405] Generating reorder.sym_chk with a meson_exe.py custom command
[386/2405] Linking target lib/librte_bbdev.so.21.0
[387/2405] Linking target lib/librte_compressdev.so.21.0
[388/2405] Generating security.sym_chk with a meson_exe.py custom command
[389/2405] Linking target lib/librte_cryptodev.so.21.0
[390/2405] Linking target lib/librte_distributor.so.21.0
[391/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_vhost_user.c.o
[392/2405] Generating regexdev.sym_chk with a meson_exe.py custom command
[393/2405] Linking target lib/librte_efd.so.21.0
[394/2405] Linking target lib/librte_lpm.so.21.0
[395/2405] Generating symbol file lib/librte_rawdev.so.21.0.p/librte_rawdev.so.21.0.symbols
[396/2405] Linking target lib/librte_member.so.21.0
[397/2405] Linking target lib/librte_reorder.so.21.0
[398/2405] Linking static target lib/librte_sched.a
[399/2405] Linking target lib/librte_regexdev.so.21.0
[400/2405] Generating rib.sym_chk with a meson_exe.py custom command
[401/2405] Generating symbol file lib/librte_stack.so.21.0.p/librte_stack.so.21.0.symbols
[402/2405] Linking target lib/librte_rib.so.21.0
[403/2405] Generating symbol file lib/librte_net.so.21.0.p/librte_net.so.21.0.symbols
[404/2405] Compiling C object lib/librte_ipsec.a.p/librte_ipsec_esp_inb.c.o
[405/2405] Linking target lib/librte_ethdev.so.21.0
[406/2405] Linking target lib/librte_cmdline.so.21.0
[407/2405] Generating symbol file lib/librte_bbdev.so.21.0.p/librte_bbdev.so.21.0.symbols
[408/2405] Generating symbol file lib/librte_compressdev.so.21.0.p/librte_compressdev.so.21.0.symbols
[409/2405] Generating symbol file lib/librte_cryptodev.so.21.0.p/librte_cryptodev.so.21.0.symbols
[410/2405] Generating rte_ipsec_def with a custom command
[411/2405] Compiling C object lib/librte_ipsec.a.p/librte_ipsec_sa.c.o
[412/2405] Linking target lib/librte_security.so.21.0
[413/2405] Generating rte_ipsec_mingw with a custom command
[414/2405] Generating symbol file lib/librte_lpm.so.21.0.p/librte_lpm.so.21.0.symbols
[415/2405] Compiling C object lib/librte_ipsec.a.p/librte_ipsec_ses.c.o
[416/2405] Compiling C object lib/librte_fib.a.p/librte_fib_rte_fib.c.o
[417/2405] Generating symbol file lib/librte_regexdev.so.21.0.p/librte_regexdev.so.21.0.symbols
[418/2405] Compiling C object lib/librte_ipsec.a.p/librte_ipsec_esp_outb.c.o
[419/2405] Generating rte_fib_def with a custom command
[420/2405] Generating symbol file lib/librte_reorder.so.21.0.p/librte_reorder.so.21.0.symbols
[421/2405] Generating rte_fib_mingw with a custom command
[422/2405] Compiling C object lib/librte_fib.a.p/librte_fib_rte_fib6.c.o
[423/2405] Generating sched.sym_chk with a meson_exe.py custom command
[424/2405] Generating symbol file lib/librte_rib.so.21.0.p/librte_rib.so.21.0.symbols
[425/2405] Compiling C object lib/librte_ipsec.a.p/librte_ipsec_ipsec_sad.c.o
[426/2405] Linking target lib/librte_sched.so.21.0
[427/2405] Linking static target lib/librte_ipsec.a
[428/2405] Generating symbol file lib/librte_ethdev.so.21.0.p/librte_ethdev.so.21.0.symbols
[429/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_sched.c.o
[430/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_frag.c.o
[431/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_ras.c.o
[432/2405] Linking target lib/librte_bitratestats.so.21.0
[433/2405] Compiling C object lib/librte_fib.a.p/librte_fib_dir24_8.c.o
[434/2405] Linking target lib/librte_gro.so.21.0
[435/2405] Linking target lib/librte_eventdev.so.21.0
[436/2405] Linking target lib/librte_gso.so.21.0
[437/2405] Generating symbol file lib/librte_security.so.21.0.p/librte_security.so.21.0.symbols
[438/2405] Linking target lib/librte_kni.so.21.0
[439/2405] Linking target lib/librte_ip_frag.so.21.0
[440/2405] Linking target lib/librte_latencystats.so.21.0
[441/2405] Linking target lib/librte_pdump.so.21.0
[442/2405] Compiling C object lib/librte_fib.a.p/librte_fib_trie.c.o
[443/2405] Linking static target lib/librte_fib.a
[444/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_fd.c.o
[445/2405] Generating symbol file lib/librte_sched.so.21.0.p/librte_sched.so.21.0.symbols
[446/2405] Generating ipsec.sym_chk with a meson_exe.py custom command
[447/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_source_sink.c.o
[448/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_ethdev.c.o
[449/2405] Generating symbol file lib/librte_eventdev.so.21.0.p/librte_eventdev.so.21.0.symbols
[450/2405] Linking target lib/librte_ipsec.so.21.0
[451/2405] Generating symbol file lib/librte_ip_frag.so.21.0.p/librte_ip_frag.so.21.0.symbols
[452/2405] Generating symbol file lib/librte_gso.so.21.0.p/librte_gso.so.21.0.symbols
[453/2405] Generating rte_port_def with a custom command
[454/2405] Generating symbol file lib/librte_kni.so.21.0.p/librte_kni.so.21.0.symbols
[455/2405] Generating rte_port_mingw with a custom command
[456/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_swx_port_ethdev.c.o
[457/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_swx_port_source_sink.c.o
[458/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_lpm.c.o
[459/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_lpm_ipv6.c.o
[460/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_cuckoo.c.o
[461/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_acl.c.o
[462/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_sym_crypto.c.o
[463/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_ring.c.o
[464/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_stub.c.o
[465/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_array.c.o
[466/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_key8.c.o
[467/2405] Generating rte_table_def with a custom command
[468/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_key16.c.o
[469/2405] Generating rte_table_mingw with a custom command
[470/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_hash.c.o
[471/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_eventdev.c.o
[472/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_virtio_net.c.o
[473/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_swx_table_em.c.o
[474/2405] Generating rte_pipeline_def with a custom command
[475/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_key32.c.o
[476/2405] Generating fib.sym_chk with a meson_exe.py custom command
[477/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_ext.c.o
[478/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_hcapi_hcapi_cfa_p4.c.o
[479/2405] Compiling C object lib/librte_table.a.p/librte_table_rte_table_hash_lru.c.o
[480/2405] Linking static target lib/librte_table.a
[481/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_port_in_action.c.o
[482/2405] Generating rte_flow_classify_mingw with a custom command
[483/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_shadow_identifier.c.o
[484/2405] Generating rte_flow_classify_def with a custom command
[485/2405] Generating rte_pipeline_mingw with a custom command
[486/2405] Linking target lib/librte_fib.so.21.0
[487/2405] Compiling C object lib/librte_port.a.p/librte_port_rte_port_kni.c.o
[488/2405] Linking static target lib/librte_port.a
[489/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf.c.o
[490/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_pipeline.c.o
[491/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_matcher.c.o
[492/2405] Generating rte_bpf_def with a custom command
[493/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_bnxt_ulp.c.o
[494/2405] Compiling C object lib/librte_flow_classify.a.p/librte_flow_classify_rte_flow_classify_parse.c.o
[495/2405] Generating rte_bpf_mingw with a custom command
[496/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_port_db.c.o
[497/2405] Linking static target lib/librte_flow_classify.a
[498/2405] Compiling C object lib/librte_graph.a.p/librte_graph_graph_ops.c.o
[499/2405] Compiling C object lib/librte_graph.a.p/librte_graph_graph.c.o
[500/2405] Compiling C object lib/librte_graph.a.p/librte_graph_node.c.o
[501/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_rte_parser.c.o
[502/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf_pkt.c.o
[503/2405] Generating rte_graph_def with a custom command
[504/2405] Generating rte_graph_mingw with a custom command
[505/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf_validate.c.o
[506/2405] Compiling C object lib/librte_node.a.p/librte_node_null.c.o
[507/2405] Compiling C object lib/librte_graph.a.p/librte_graph_graph_debug.c.o
[508/2405] Generating table.sym_chk with a meson_exe.py custom command
[509/2405] Compiling C object lib/librte_graph.a.p/librte_graph_graph_populate.c.o
[510/2405] Compiling C object lib/librte_node.a.p/librte_node_log.c.o
[511/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_mapper.c.o
[512/2405] Compiling C object lib/librte_bpf.a.p/librte_bpf_bpf_jit_x86.c.o
[513/2405] Compiling C object lib/librte_graph.a.p/librte_graph_graph_stats.c.o
[514/2405] Linking static target lib/librte_graph.a
[515/2405] Linking static target lib/librte_bpf.a
[516/2405] Generating port.sym_chk with a meson_exe.py custom command
[517/2405] Compiling C object lib/librte_node.a.p/librte_node_ethdev_tx.c.o
[518/2405] Compiling C object lib/librte_node.a.p/librte_node_pkt_drop.c.o
[519/2405] Compiling C object lib/librte_node.a.p/librte_node_ethdev_rx.c.o
[520/2405] Generating rte_node_def with a custom command
[521/2405] Linking target lib/librte_port.so.21.0
[522/2405] Generating rte_node_mingw with a custom command
[523/2405] Compiling C object drivers/libtmp_rte_common_cpt.a.p/common_cpt_cpt_fpm_tables.c.o
[524/2405] Generating rte_common_cpt_mingw with a custom command
[525/2405] Compiling C object lib/librte_node.a.p/librte_node_ethdev_ctrl.c.o
[526/2405] Generating rte_common_cpt_def with a custom command
[527/2405] Compiling C object lib/librte_node.a.p/librte_node_ip4_lookup.c.o
[528/2405] Compiling C object drivers/libtmp_rte_common_cpt.a.p/common_cpt_cpt_pmd_ops_helper.c.o
[529/2405] Linking static target drivers/libtmp_rte_common_cpt.a
[530/2405] Generating rte_common_cpt.pmd.c with a custom command
[531/2405] Generating flow_classify.sym_chk with a meson_exe.py custom command
[532/2405] Compiling C object drivers/librte_common_cpt.a.p/meson-generated_.._rte_common_cpt.pmd.c.o
[533/2405] Compiling C object drivers/libtmp_rte_common_dpaax.a.p/common_dpaax_caamflib.c.o
[534/2405] Linking static target drivers/librte_common_cpt.a
[535/2405] Compiling C object drivers/librte_common_cpt.so.21.0.p/meson-generated_.._rte_common_cpt.pmd.c.o
[536/2405] Compiling C object drivers/libtmp_rte_common_dpaax.a.p/common_dpaax_dpaax_iova_table.c.o
[537/2405] Generating rte_common_dpaax_def with a custom command
[538/2405] Generating rte_common_dpaax_mingw with a custom command
[539/2405] Compiling C object lib/librte_node.a.p/librte_node_pkt_cls.c.o
[540/2405] Generating rte_common_iavf_def with a custom command
[541/2405] Compiling C object drivers/libtmp_rte_crypto_virtio.a.p/crypto_virtio_virtio_pci.c.o
[542/2405] Generating rte_common_iavf_mingw with a custom command
[543/2405] Compiling C object lib/librte_node.a.p/librte_node_ip4_rewrite.c.o
[544/2405] Compiling C object drivers/libtmp_rte_common_dpaax.a.p/common_dpaax_dpaa_of.c.o
[545/2405] Linking static target lib/librte_node.a
[546/2405] Linking static target drivers/libtmp_rte_common_dpaax.a
[547/2405] Generating rte_common_octeontx_def with a custom command
[548/2405] Compiling C object drivers/libtmp_rte_common_iavf.a.p/common_iavf_iavf_impl.c.o
[549/2405] Generating rte_common_dpaax.pmd.c with a custom command
[550/2405] Generating rte_common_octeontx_mingw with a custom command
[551/2405] Compiling C object drivers/librte_common_dpaax.so.21.0.p/meson-generated_.._rte_common_dpaax.pmd.c.o
[552/2405] Compiling C object drivers/librte_common_dpaax.a.p/meson-generated_.._rte_common_dpaax.pmd.c.o
[553/2405] Linking static target drivers/librte_common_dpaax.a
[554/2405] Generating bpf.sym_chk with a meson_exe.py custom command
[555/2405] Compiling C object drivers/libtmp_rte_common_iavf.a.p/common_iavf_iavf_common.c.o
[556/2405] Compiling C object drivers/libtmp_rte_common_octeontx.a.p/common_octeontx_octeontx_mbox.c.o
[557/2405] Linking static target drivers/libtmp_rte_common_octeontx.a
[558/2405] Generating symbol file lib/librte_port.so.21.0.p/librte_port.so.21.0.symbols
[559/2405] Generating rte_common_octeontx.pmd.c with a custom command
[560/2405] Linking target lib/librte_bpf.so.21.0
[561/2405] Compiling C object drivers/librte_common_octeontx.a.p/meson-generated_.._rte_common_octeontx.pmd.c.o
[562/2405] Linking static target drivers/librte_common_octeontx.a
[563/2405] Compiling C object drivers/librte_common_octeontx.so.21.0.p/meson-generated_.._rte_common_octeontx.pmd.c.o
[564/2405] Compiling C object drivers/libtmp_rte_common_iavf.a.p/common_iavf_iavf_adminq.c.o
[565/2405] Linking static target drivers/libtmp_rte_common_iavf.a
[566/2405] Linking target lib/librte_table.so.21.0
[567/2405] Compiling C object drivers/libtmp_rte_common_octeontx2.a.p/common_octeontx2_otx2_irq.c.o
[568/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_swx_pipeline.c.o
[569/2405] Generating rte_common_iavf.pmd.c with a custom command
[570/2405] Generating rte_common_octeontx2_def with a custom command
[571/2405] Compiling C object drivers/librte_common_iavf.a.p/meson-generated_.._rte_common_iavf.pmd.c.o
[572/2405] Linking static target drivers/librte_common_iavf.a
[573/2405] Compiling C object drivers/librte_common_iavf.so.21.0.p/meson-generated_.._rte_common_iavf.pmd.c.o
[574/2405] Generating rte_common_octeontx2_mingw with a custom command
[575/2405] Compiling C object drivers/libtmp_rte_common_octeontx2.a.p/common_octeontx2_otx2_mbox.c.o
[576/2405] Compiling C object drivers/libtmp_rte_common_octeontx2.a.p/common_octeontx2_otx2_common.c.o
[577/2405] Compiling C object drivers/libtmp_rte_common_octeontx2.a.p/common_octeontx2_otx2_dev.c.o
[578/2405] Compiling C object drivers/libtmp_rte_common_octeontx2.a.p/common_octeontx2_otx2_sec_idev.c.o
[579/2405] Linking static target drivers/libtmp_rte_common_octeontx2.a
[580/2405] Generating rte_common_octeontx2.pmd.c with a custom command
[581/2405] Compiling C object drivers/librte_common_octeontx2.a.p/meson-generated_.._rte_common_octeontx2.pmd.c.o
[582/2405] Linking static target drivers/librte_common_octeontx2.a
[583/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_bootcfg.c.o
[584/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_crc32.c.o
[585/2405] Generating rte_common_cpt.sym_chk with a meson_exe.py custom command
[586/2405] Compiling C object drivers/librte_common_octeontx2.so.21.0.p/meson-generated_.._rte_common_octeontx2.pmd.c.o
[587/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_evb.c.o
[588/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_ev.c.o
[589/2405] Linking target drivers/librte_common_cpt.so.21.0
[590/2405] Generating node.sym_chk with a meson_exe.py custom command
[591/2405] Generating graph.sym_chk with a meson_exe.py custom command
[592/2405] Generating symbol file lib/librte_table.so.21.0.p/librte_table.so.21.0.symbols
[593/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_hash.c.o
[594/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_filter.c.o
[595/2405] Linking target lib/librte_graph.so.21.0
[596/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_lic.c.o
[597/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_intr.c.o
[598/2405] Linking target lib/librte_flow_classify.so.21.0
[599/2405] Generating rte_common_octeontx.sym_chk with a meson_exe.py custom command
[600/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_mac.c.o
[601/2405] Linking target drivers/librte_common_octeontx.so.21.0
[602/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_mon.c.o
[603/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_nvram.c.o
[604/2405] Generating rte_common_iavf.sym_chk with a meson_exe.py custom command
[605/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_nic.c.o
[606/2405] Generating rte_common_dpaax.sym_chk with a meson_exe.py custom command
[607/2405] Linking target drivers/librte_common_iavf.so.21.0
[608/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_pci.c.o
[609/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_mae.c.o
[610/2405] Linking target drivers/librte_common_dpaax.so.21.0
[611/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_phy.c.o
[612/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_port.c.o
[613/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_proxy.c.o
[614/2405] Generating symbol file drivers/librte_common_cpt.so.21.0.p/librte_common_cpt.so.21.0.symbols
[615/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_mcdi.c.o
[616/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_sram.c.o
[617/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_rx.c.o
[618/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_vpd.c.o
[619/2405] Generating symbol file lib/librte_graph.so.21.0.p/librte_graph.so.21.0.symbols
[620/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/mcdi_mon.c.o
[621/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_tx.c.o
[622/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_mac.c.o
[623/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/efx_tunnel.c.o
[624/2405] Linking target lib/librte_node.so.21.0
[625/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_mcdi.c.o
[626/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_nic.c.o
[627/2405] Generating symbol file drivers/librte_common_octeontx.so.21.0.p/librte_common_octeontx.so.21.0.symbols
[628/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_nvram.c.o
[629/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_phy.c.o
[630/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_sram.c.o
[631/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/siena_vpd.c.o
[632/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_image.c.o
[633/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_ev.c.o
[634/2405] Generating symbol file drivers/librte_common_iavf.so.21.0.p/librte_common_iavf.so.21.0.symbols
[635/2405] Generating symbol file drivers/librte_common_dpaax.so.21.0.p/librte_common_dpaax.so.21.0.symbols
[636/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_evb.c.o
[637/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_intr.c.o
[638/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_nvram.c.o
[639/2405] Generating rte_common_octeontx2.sym_chk with a meson_exe.py custom command
[640/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_mcdi.c.o
[641/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_mac.c.o
[642/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_proxy.c.o
[643/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_vpd.c.o
[644/2405] Linking target drivers/librte_common_octeontx2.so.21.0
[645/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_phy.c.o
[646/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/hunt_nic.c.o
[647/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_rx.c.o
[648/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_tx.c.o
[649/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/medford_nic.c.o
[650/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_nic.c.o
[651/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/medford2_nic.c.o
[652/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/ef10_filter.c.o
[653/2405] Compiling C object drivers/libtmp_rte_common_sfc_efx.a.p/common_sfc_efx_sfc_efx.c.o
[654/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_ev.c.o
[655/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_intr.c.o
[656/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_pci.c.o
[657/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_nic.c.o
[658/2405] Generating rte_common_sfc_efx_mingw with a custom command
[659/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_tx.c.o
[660/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_rx.c.o
[661/2405] Generating rte_common_sfc_efx_def with a custom command
[662/2405] Compiling C object drivers/common/sfc_efx/base/libsfc_base.a.p/rhead_tunnel.c.o
[663/2405] Linking static target drivers/common/sfc_efx/base/libsfc_base.a
[664/2405] Compiling C object drivers/libtmp_rte_common_sfc_efx.a.p/common_sfc_efx_sfc_efx_mcdi.c.o
[665/2405] Linking static target drivers/libtmp_rte_common_sfc_efx.a
[666/2405] Generating rte_common_sfc_efx.pmd.c with a custom command
[667/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_dpaa_sys.c.o
[668/2405] Compiling C object drivers/librte_common_sfc_efx.so.21.0.p/meson-generated_.._rte_common_sfc_efx.pmd.c.o
[669/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_fman_netcfg_layer.c.o
[670/2405] Compiling C object drivers/librte_common_sfc_efx.a.p/meson-generated_.._rte_common_sfc_efx.pmd.c.o
[671/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_bman.c.o
[672/2405] Linking static target drivers/librte_common_sfc_efx.a
[673/2405] Generating rte_bus_dpaa_def with a custom command
[674/2405] Generating rte_bus_dpaa_mingw with a custom command
[675/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_dpaa_alloc.c.o
[676/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_bman_driver.c.o
[677/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_fman_fman_hw.c.o
[678/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpcon.c.o
[679/2405] Generating symbol file drivers/librte_common_octeontx2.so.21.0.p/librte_common_octeontx2.so.21.0.symbols
[680/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_process.c.o
[681/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpbp.c.o
[682/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpci.c.o
[683/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpmng.c.o
[684/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_dpaa_bus.c.o
[685/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_qman_driver.c.o
[686/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpdmai.c.o
[687/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_fman_fman.c.o
[688/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_dpio.c.o
[689/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_mc_mc_sys.c.o
[690/2405] Generating rte_bus_fslmc_mingw with a custom command
[691/2405] Generating rte_bus_fslmc_def with a custom command
[692/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_fslmc_bus.c.o
[693/2405] Generating rte_bus_ifpga_def with a custom command
[694/2405] Generating rte_bus_ifpga_mingw with a custom command
[695/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_qbman_qbman_debug.c.o
[696/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_portal_dpaa2_hw_dpbp.c.o
[697/2405] Compiling C object drivers/libtmp_rte_bus_ifpga.a.p/bus_ifpga_ifpga_common.c.o
[698/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_fslmc_vfio.c.o
[699/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_pci_params.c.o
[700/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_portal_dpaa2_hw_dpci.c.o
[701/2405] Generating rte_bus_pci_def with a custom command
[702/2405] Compiling C object drivers/libtmp_rte_bus_ifpga.a.p/bus_ifpga_ifpga_bus.c.o
[703/2405] Generating rte_bus_pci_mingw with a custom command
[704/2405] Linking static target drivers/libtmp_rte_bus_ifpga.a
[705/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_pci_common_uio.c.o
[706/2405] Generating rte_bus_ifpga.pmd.c with a custom command
[707/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_portal_dpaa2_hw_dpio.c.o
[708/2405] Compiling C object drivers/librte_bus_ifpga.so.21.0.p/meson-generated_.._rte_bus_ifpga.pmd.c.o
[709/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_pci_common.c.o
[710/2405] Generating rte_bus_vdev_def with a custom command
[711/2405] Compiling C object drivers/librte_bus_ifpga.a.p/meson-generated_.._rte_bus_ifpga.pmd.c.o
[712/2405] Compiling C object drivers/libtmp_rte_bus_vdev.a.p/bus_vdev_vdev_params.c.o
[713/2405] Linking static target drivers/librte_bus_ifpga.a
[714/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_linux_pci_uio.c.o
[715/2405] Generating rte_bus_vdev_mingw with a custom command
[716/2405] Compiling C object drivers/libtmp_rte_bus_vdev.a.p/bus_vdev_vdev.c.o
[717/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_linux_pci.c.o
[718/2405] Linking static target drivers/libtmp_rte_bus_vdev.a
[719/2405] Generating rte_bus_vdev.pmd.c with a custom command
[720/2405] Compiling C object drivers/librte_bus_vdev.a.p/meson-generated_.._rte_bus_vdev.pmd.c.o
[721/2405] Compiling C object drivers/libtmp_rte_bus_pci.a.p/bus_pci_linux_pci_vfio.c.o
[722/2405] Linking static target drivers/librte_bus_vdev.a
[723/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_vmbus_common.c.o
[724/2405] Linking static target drivers/libtmp_rte_bus_pci.a
[725/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_vmbus_bufring.c.o
[726/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_vmbus_channel.c.o
[727/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_vmbus_common_uio.c.o
[728/2405] Compiling C object drivers/librte_bus_vdev.so.21.0.p/meson-generated_.._rte_bus_vdev.pmd.c.o
[729/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_linux_vmbus_bus.c.o
[730/2405] Generating rte_bus_vmbus_def with a custom command
[731/2405] Generating rte_bus_vmbus_mingw with a custom command
[732/2405] Generating rte_bus_pci.pmd.c with a custom command
[733/2405] Compiling C object drivers/libtmp_rte_bus_dpaa.a.p/bus_dpaa_base_qbman_qman.c.o
[734/2405] Compiling C object drivers/librte_bus_pci.a.p/meson-generated_.._rte_bus_pci.pmd.c.o
[735/2405] Linking static target drivers/libtmp_rte_bus_dpaa.a
[736/2405] Compiling C object drivers/libtmp_rte_bus_vmbus.a.p/bus_vmbus_linux_vmbus_uio.c.o
[737/2405] Linking static target drivers/librte_bus_pci.a
[738/2405] Compiling C object drivers/libtmp_rte_bus_fslmc.a.p/bus_fslmc_qbman_qbman_portal.c.o
[739/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/common_qat_qat_logs.c.o
[740/2405] Linking static target drivers/libtmp_rte_bus_fslmc.a
[741/2405] Compiling C object drivers/librte_bus_pci.so.21.0.p/meson-generated_.._rte_bus_pci.pmd.c.o
[742/2405] Linking static target drivers/libtmp_rte_bus_vmbus.a
[743/2405] Generating rte_bus_dpaa.pmd.c with a custom command
[744/2405] Generating rte_bus_vmbus.pmd.c with a custom command
[745/2405] Compiling C object drivers/librte_bus_dpaa.a.p/meson-generated_.._rte_bus_dpaa.pmd.c.o
[746/2405] Linking static target drivers/librte_bus_dpaa.a
[747/2405] Generating rte_bus_fslmc.pmd.c with a custom command
[748/2405] Compiling C object drivers/librte_bus_dpaa.so.21.0.p/meson-generated_.._rte_bus_dpaa.pmd.c.o
[749/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/common_qat_qat_common.c.o
[750/2405] Compiling C object drivers/librte_bus_fslmc.so.21.0.p/meson-generated_.._rte_bus_fslmc.pmd.c.o
[751/2405] Compiling C object drivers/librte_bus_fslmc.a.p/meson-generated_.._rte_bus_fslmc.pmd.c.o
[752/2405] Compiling C object drivers/librte_bus_vmbus.so.21.0.p/meson-generated_.._rte_bus_vmbus.pmd.c.o
[753/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/common_qat_qat_device.c.o
[754/2405] Compiling C object drivers/librte_bus_vmbus.a.p/meson-generated_.._rte_bus_vmbus.pmd.c.o
[755/2405] Linking static target drivers/librte_bus_fslmc.a
[756/2405] Linking static target drivers/librte_bus_vmbus.a
[757/2405] Generating rte_common_qat_def with a custom command
[758/2405] Generating rte_common_qat_mingw with a custom command
[759/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/compress_qat_qat_comp_pmd.c.o
[760/2405] Generating rte_mempool_bucket_def with a custom command
[761/2405] Generating rte_crypto_octeontx2_mingw with a custom command
[762/2405] Generating rte_mempool_dpaa_def with a custom command
[763/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/common_qat_qat_qp.c.o
[764/2405] Generating rte_bus_ifpga.sym_chk with a meson_exe.py custom command
[765/2405] Generating rte_mempool_dpaa_mingw with a custom command
[766/2405] Linking target drivers/librte_bus_ifpga.so.21.0
[767/2405] Generating rte_mempool_dpaa2_def with a custom command
[768/2405] Compiling C object lib/librte_vhost.a.p/librte_vhost_vhost_crypto.c.o
[769/2405] Generating rte_mempool_dpaa2_mingw with a custom command
[770/2405] Linking static target lib/librte_vhost.a
[771/2405] Generating rte_bus_vdev.sym_chk with a meson_exe.py custom command
[772/2405] Compiling C object drivers/libtmp_rte_common_qat.a.p/compress_qat_qat_comp.c.o
[773/2405] Compiling C object drivers/net/octeontx/base/libocteontx_base.a.p/octeontx_pkovf.c.o
[774/2405] Linking static target drivers/libtmp_rte_common_qat.a
[775/2405] Compiling C object drivers/libtmp_rte_mempool_dpaa.a.p/mempool_dpaa_dpaa_mempool.c.o
[776/2405] Linking target drivers/librte_bus_vdev.so.21.0
[777/2405] Linking static target drivers/libtmp_rte_mempool_dpaa.a
[778/2405] Generating rte_bus_pci.sym_chk with a meson_exe.py custom command
[779/2405] Generating rte_mempool_dpaa.pmd.c with a custom command
[780/2405] Generating rte_common_qat.pmd.c with a custom command
[781/2405] Compiling C object drivers/librte_mempool_dpaa.a.p/meson-generated_.._rte_mempool_dpaa.pmd.c.o
[782/2405] Compiling C object drivers/libtmp_rte_mempool_dpaa2.a.p/mempool_dpaa2_dpaa2_hw_mempool.c.o
[783/2405] Compiling C object drivers/librte_common_qat.a.p/meson-generated_.._rte_common_qat.pmd.c.o
[784/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx.a.p/mempool_octeontx_rte_mempool_octeontx.c.o
[785/2405] Linking target drivers/librte_bus_pci.so.21.0
[786/2405] Compiling C object drivers/librte_common_qat.so.21.0.p/meson-generated_.._rte_common_qat.pmd.c.o
[787/2405] Linking static target drivers/librte_mempool_dpaa.a
[788/2405] Linking static target drivers/libtmp_rte_mempool_dpaa2.a
[789/2405] Linking static target drivers/librte_common_qat.a
[790/2405] Compiling C object drivers/librte_mempool_dpaa.so.21.0.p/meson-generated_.._rte_mempool_dpaa.pmd.c.o
[791/2405] Generating rte_mempool_dpaa2.pmd.c with a custom command
[792/2405] Generating rte_mempool_octeontx_def with a custom command
[793/2405] Compiling C object drivers/librte_mempool_dpaa2.a.p/meson-generated_.._rte_mempool_dpaa2.pmd.c.o
[794/2405] Linking static target drivers/librte_mempool_dpaa2.a
[795/2405] Compiling C object drivers/librte_mempool_dpaa2.so.21.0.p/meson-generated_.._rte_mempool_dpaa2.pmd.c.o
[796/2405] Generating rte_mempool_octeontx_mingw with a custom command
[797/2405] Generating rte_bus_vmbus.sym_chk with a meson_exe.py custom command
[798/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx.a.p/mempool_octeontx_octeontx_fpavf.c.o
[799/2405] Linking static target drivers/libtmp_rte_mempool_octeontx.a
[800/2405] Linking target drivers/librte_bus_vmbus.so.21.0
[801/2405] Generating rte_mempool_octeontx.pmd.c with a custom command
[802/2405] Compiling C object drivers/librte_mempool_octeontx.a.p/meson-generated_.._rte_mempool_octeontx.pmd.c.o
[803/2405] Linking static target drivers/librte_mempool_octeontx.a
[804/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx2.a.p/mempool_octeontx2_otx2_mempool_debug.c.o
[805/2405] Compiling C object drivers/librte_mempool_octeontx.so.21.0.p/meson-generated_.._rte_mempool_octeontx.pmd.c.o
[806/2405] Generating symbol file drivers/librte_bus_vdev.so.21.0.p/librte_bus_vdev.so.21.0.symbols
[807/2405] Generating symbol file drivers/librte_bus_pci.so.21.0.p/librte_bus_pci.so.21.0.symbols
[808/2405] Generating rte_mempool_dpaa.sym_chk with a meson_exe.py custom command
[809/2405] Generating rte_common_qat.sym_chk with a meson_exe.py custom command
[810/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx2.a.p/mempool_octeontx2_otx2_mempool.c.o
[811/2405] Generating rte_mempool_octeontx2_mingw with a custom command
[812/2405] Generating rte_mempool_octeontx2_def with a custom command
[813/2405] Generating rte_mempool_ring_def with a custom command
[814/2405] Linking target drivers/librte_common_qat.so.21.0
[815/2405] Generating rte_mempool_dpaa2.sym_chk with a meson_exe.py custom command
[816/2405] Generating rte_mempool_ring_mingw with a custom command
[817/2405] Generating rte_mempool_stack_def with a custom command
[818/2405] Generating symbol file drivers/librte_bus_vmbus.so.21.0.p/librte_bus_vmbus.so.21.0.symbols
[819/2405] Generating rte_mempool_stack_mingw with a custom command
[820/2405] Compiling C object drivers/libtmp_rte_mempool_octeontx2.a.p/mempool_octeontx2_otx2_mempool_ops.c.o
[821/2405] Generating rte_net_af_packet_def with a custom command
[822/2405] Compiling C object drivers/libtmp_rte_mempool_bucket.a.p/mempool_bucket_rte_mempool_bucket.c.o
[823/2405] Linking static target drivers/libtmp_rte_mempool_octeontx2.a
[824/2405] Generating rte_net_af_packet_mingw with a custom command
[825/2405] Linking static target drivers/libtmp_rte_mempool_bucket.a
[826/2405] Generating rte_mempool_bucket.pmd.c with a custom command
[827/2405] Generating rte_mempool_octeontx2.pmd.c with a custom command
[828/2405] Compiling C object drivers/librte_mempool_bucket.a.p/meson-generated_.._rte_mempool_bucket.pmd.c.o
[829/2405] Compiling C object drivers/librte_mempool_bucket.so.21.0.p/meson-generated_.._rte_mempool_bucket.pmd.c.o
[830/2405] Linking static target drivers/librte_mempool_bucket.a
[831/2405] Compiling C object drivers/libtmp_rte_regex_octeontx2.a.p/regex_octeontx2_otx2_regexdev_mbox.c.o
[832/2405] Generating rte_mempool_octeontx.sym_chk with a meson_exe.py custom command
[833/2405] Generating vhost.sym_chk with a meson_exe.py custom command
[834/2405] Compiling C object drivers/librte_mempool_octeontx2.a.p/meson-generated_.._rte_mempool_octeontx2.pmd.c.o
[835/2405] Compiling C object drivers/librte_mempool_octeontx2.so.21.0.p/meson-generated_.._rte_mempool_octeontx2.pmd.c.o
[836/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_ddm.c.o
[837/2405] Linking static target drivers/librte_mempool_octeontx2.a
[838/2405] Linking target drivers/librte_mempool_octeontx.so.21.0
[839/2405] Linking target lib/librte_vhost.so.21.0
[840/2405] Compiling C object drivers/libtmp_rte_mempool_stack.a.p/mempool_stack_rte_mempool_stack.c.o
[841/2405] Linking static target drivers/libtmp_rte_mempool_stack.a
[842/2405] Generating rte_mempool_stack.pmd.c with a custom command
[843/2405] Compiling C object drivers/librte_mempool_stack.a.p/meson-generated_.._rte_mempool_stack.pmd.c.o
[844/2405] Linking static target drivers/librte_mempool_stack.a
[845/2405] Compiling C object drivers/libtmp_rte_mempool_ring.a.p/mempool_ring_rte_mempool_ring.c.o
[846/2405] Linking static target drivers/libtmp_rte_mempool_ring.a
[847/2405] Generating rte_mempool_ring.pmd.c with a custom command
[848/2405] Compiling C object drivers/librte_mempool_ring.a.p/meson-generated_.._rte_mempool_ring.pmd.c.o
[849/2405] Linking static target drivers/librte_mempool_ring.a
[850/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_ethdev.c.o
[851/2405] Compiling C object drivers/librte_mempool_ring.so.21.0.p/meson-generated_.._rte_mempool_ring.pmd.c.o
[852/2405] Compiling C object drivers/librte_mempool_stack.so.21.0.p/meson-generated_.._rte_mempool_stack.pmd.c.o
[853/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_ethdev_tx.c.o
[854/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_mpu.c.o
[855/2405] Compiling C object drivers/libtmp_rte_net_af_packet.a.p/net_af_packet_rte_eth_af_packet.c.o
[856/2405] Linking static target drivers/libtmp_rte_net_af_packet.a
[857/2405] Generating rte_net_af_packet.pmd.c with a custom command
[858/2405] Compiling C object drivers/librte_net_af_packet.a.p/meson-generated_.._rte_net_af_packet.pmd.c.o
[859/2405] Linking static target drivers/librte_net_af_packet.a
[860/2405] Generating rte_mempool_bucket.sym_chk with a meson_exe.py custom command
[861/2405] Generating symbol file drivers/librte_mempool_octeontx.so.21.0.p/librte_mempool_octeontx.so.21.0.symbols
[862/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_pktdir.c.o
[863/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_ethdev_rx.c.o
[864/2405] Compiling C object drivers/librte_net_af_packet.so.21.0.p/meson-generated_.._rte_net_af_packet.pmd.c.o
[865/2405] Generating symbol file lib/librte_vhost.so.21.0.p/librte_vhost.so.21.0.symbols
[866/2405] Linking target drivers/librte_mempool_bucket.so.21.0
[867/2405] Generating rte_net_ark_def with a custom command
[868/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_pktchkr.c.o
[869/2405] Generating rte_net_ark_mingw with a custom command
[870/2405] Generating rte_mempool_octeontx2.sym_chk with a meson_exe.py custom command
[871/2405] Generating rte_mempool_stack.sym_chk with a meson_exe.py custom command
[872/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_rqp.c.o
[873/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_udm.c.o
[874/2405] Generating rte_bus_dpaa.sym_chk with a meson_exe.py custom command
[875/2405] Linking target drivers/librte_mempool_stack.so.21.0
[876/2405] Linking target drivers/librte_mempool_octeontx2.so.21.0
[877/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_atl_hw_regs.c.o
[878/2405] Linking target drivers/librte_bus_dpaa.so.21.0
[879/2405] Generating rte_mempool_ring.sym_chk with a meson_exe.py custom command
[880/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_hw_atl_hw_atl_b0.c.o
[881/2405] Linking target drivers/librte_mempool_ring.so.21.0
[882/2405] Compiling C object drivers/libtmp_rte_net_ark.a.p/net_ark_ark_pktgen.c.o
[883/2405] Generating rte_net_atlantic_mingw with a custom command
[884/2405] Generating rte_bus_fslmc.sym_chk with a meson_exe.py custom command
[885/2405] Linking static target drivers/libtmp_rte_net_ark.a
[886/2405] Generating rte_net_atlantic_def with a custom command
[887/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_hw_atl_hw_atl_llh.c.o
[888/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_hw_atl_hw_atl_utils_fw2x.c.o
[889/2405] Generating rte_net_ark.pmd.c with a custom command
[890/2405] Linking target drivers/librte_bus_fslmc.so.21.0
[891/2405] Generating rte_net_avp_def with a custom command
[892/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_rte_pmd_atlantic.c.o
[893/2405] Compiling C object drivers/librte_net_ark.a.p/meson-generated_.._rte_net_ark.pmd.c.o
[894/2405] Generating rte_net_avp_mingw with a custom command
[895/2405] Compiling C object drivers/librte_net_ark.so.21.0.p/meson-generated_.._rte_net_ark.pmd.c.o
[896/2405] Linking static target drivers/librte_net_ark.a
[897/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_hw_atl_hw_atl_utils.c.o
[898/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_atl_ethdev.c.o
[899/2405] Generating rte_net_af_packet.sym_chk with a meson_exe.py custom command
[900/2405] Linking target drivers/librte_net_af_packet.so.21.0
[901/2405] Compiling C object drivers/libtmp_rte_net_atlantic.a.p/net_atlantic_atl_rxtx.c.o
[902/2405] Linking static target drivers/libtmp_rte_net_atlantic.a
[903/2405] Generating symbol file drivers/librte_mempool_octeontx2.so.21.0.p/librte_mempool_octeontx2.so.21.0.symbols
[904/2405] Generating rte_net_axgbe_def with a custom command
[905/2405] Generating rte_net_atlantic.pmd.c with a custom command
[906/2405] Generating symbol file drivers/librte_bus_dpaa.so.21.0.p/librte_bus_dpaa.so.21.0.symbols
[907/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_i2c.c.o
[908/2405] Compiling C object drivers/librte_net_atlantic.a.p/meson-generated_.._rte_net_atlantic.pmd.c.o
[909/2405] Linking static target drivers/librte_net_atlantic.a
[910/2405] Compiling C object drivers/librte_net_atlantic.so.21.0.p/meson-generated_.._rte_net_atlantic.pmd.c.o
[911/2405] Generating rte_net_axgbe_mingw with a custom command
[912/2405] Linking target drivers/librte_mempool_dpaa.so.21.0
[913/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_mdio.c.o
[914/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_dev.c.o
[915/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_phy_impl.c.o
[916/2405] Generating symbol file drivers/librte_bus_fslmc.so.21.0.p/librte_bus_fslmc.so.21.0.symbols
[917/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_rxtx_vec_sse.c.o
[918/2405] Linking target drivers/librte_mempool_dpaa2.so.21.0
[919/2405] Generating rte_net_ark.sym_chk with a meson_exe.py custom command
[920/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_args.c.o
[921/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_ethdev.c.o
[922/2405] Linking target drivers/librte_net_ark.so.21.0
[923/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_flow.c.o
[924/2405] Generating rte_net_bond_def with a custom command
[925/2405] Generating rte_net_bond_mingw with a custom command
[926/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_api.c.o
[927/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_alb.c.o
[928/2405] Generating symbol file drivers/librte_mempool_dpaa.so.21.0.p/librte_mempool_dpaa.so.21.0.symbols
[929/2405] Compiling C object drivers/libtmp_rte_net_axgbe.a.p/net_axgbe_axgbe_rxtx.c.o
[930/2405] Compiling C object drivers/libtmp_rte_net_avp.a.p/net_avp_avp_ethdev.c.o
[931/2405] Linking static target drivers/libtmp_rte_net_avp.a
[932/2405] Linking static target drivers/libtmp_rte_net_axgbe.a
[933/2405] Generating rte_net_avp.pmd.c with a custom command
[934/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_filter.c.o
[935/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_cpr.c.o
[936/2405] Compiling C object drivers/librte_net_avp.so.21.0.p/meson-generated_.._rte_net_avp.pmd.c.o
[937/2405] Compiling C object drivers/librte_net_avp.a.p/meson-generated_.._rte_net_avp.pmd.c.o
[938/2405] Generating rte_net_axgbe.pmd.c with a custom command
[939/2405] Linking static target drivers/librte_net_avp.a
[940/2405] Generating rte_net_atlantic.sym_chk with a meson_exe.py custom command
[941/2405] Compiling C object drivers/librte_net_axgbe.a.p/meson-generated_.._rte_net_axgbe.pmd.c.o
[942/2405] Linking static target drivers/librte_net_axgbe.a
[943/2405] Linking target drivers/librte_net_atlantic.so.21.0
[944/2405] Compiling C object drivers/librte_net_axgbe.so.21.0.p/meson-generated_.._rte_net_axgbe.pmd.c.o
[945/2405] Generating symbol file drivers/librte_mempool_dpaa2.so.21.0.p/librte_mempool_dpaa2.so.21.0.symbols
[946/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_irq.c.o
[947/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_ring.c.o
[948/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_flow.c.o
[949/2405] Generating rte_common_sfc_efx.sym_chk with a meson_exe.py custom command
[950/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_rxq.c.o
[951/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_stats.c.o
[952/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_txq.c.o
[953/2405] Linking target drivers/librte_common_sfc_efx.so.21.0
[954/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_util.c.o
[955/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_rxr.c.o
[956/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_vnic.c.o
[957/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_ethdev.c.o
[958/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_rand.c.o
[959/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_bitalloc.c.o
[960/2405] Generating rte_net_avp.sym_chk with a meson_exe.py custom command
[961/2405] Generating rte_net_axgbe.sym_chk with a meson_exe.py custom command
[962/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_stack.c.o
[963/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_8023ad.c.o
[964/2405] Linking target drivers/librte_net_avp.so.21.0
[965/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_txr.c.o
[966/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_core.c.o
[967/2405] Linking target drivers/librte_net_axgbe.so.21.0
[968/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_reps.c.o
[969/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_msg.c.o
[970/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_rm.c.o
[971/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_device.c.o
[972/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_device_p4.c.o
[973/2405] Compiling C object drivers/libtmp_rte_net_bond.a.p/net_bonding_rte_eth_bond_pmd.c.o
[974/2405] Generating symbol file drivers/librte_common_sfc_efx.so.21.0.p/librte_common_sfc_efx.so.21.0.symbols
[975/2405] Linking static target drivers/libtmp_rte_net_bond.a
[976/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_tbl.c.o
[977/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_em_internal.c.o
[978/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_util.c.o
[979/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_session.c.o
[980/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tfp.c.o
[981/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_tcam.c.o
[982/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_ll.c.o
[983/2405] Generating rte_regex_octeontx2_mingw with a custom command
[984/2405] Generating rte_net_bond.pmd.c with a custom command
[985/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_identifier.c.o
[986/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_em_common.c.o
[987/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_shadow_tbl.c.o
[988/2405] Generating rte_vdpa_ifc_def with a custom command
[989/2405] Compiling C object lib/librte_pipeline.a.p/librte_pipeline_rte_table_action.c.o
[990/2405] Compiling C object drivers/librte_net_bond.a.p/meson-generated_.._rte_net_bond.pmd.c.o
[991/2405] Compiling C object drivers/librte_net_bond.so.21.0.p/meson-generated_.._rte_net_bond.pmd.c.o
[992/2405] Linking static target drivers/librte_net_bond.a
[993/2405] Linking static target lib/librte_pipeline.a
[994/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_if_tbl.c.o
[995/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_shadow_tcam.c.o
[996/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_global_cfg.c.o
[997/2405] Compiling C object drivers/libtmp_rte_vdpa_ifc.a.p/vdpa_ifc_base_ifcvf.c.o
[998/2405] Generating rte_vdpa_ifc_mingw with a custom command
[999/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_tbl.c.o
[1000/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_mark_mgr.c.o
[1001/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_class.c.o
[1002/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_act.c.o
[1003/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_core_tf_em_host.c.o
[1004/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_utils.c.o
[1005/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_pf_dlb_main.c.o
[1006/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_dlb_iface.c.o
[1007/2405] Compiling C object drivers/libtmp_rte_vdpa_ifc.a.p/vdpa_ifc_ifcvf_vdpa.c.o
[1008/2405] Linking static target drivers/libtmp_rte_vdpa_ifc.a
[1009/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_bnxt_ulp_flow.c.o
[1010/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_flow_db.c.o
[1011/2405] Generating rte_vdpa_ifc.pmd.c with a custom command
[1012/2405] Compiling C object drivers/librte_vdpa_ifc.a.p/meson-generated_.._rte_vdpa_ifc.pmd.c.o
[1013/2405] Linking static target drivers/librte_vdpa_ifc.a
[1014/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_fc_mgr.c.o
[1015/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_wh_plus_act.c.o
[1016/2405] Compiling C object drivers/librte_vdpa_ifc.so.21.0.p/meson-generated_.._rte_vdpa_ifc.pmd.c.o
[1017/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_dlb_xstats.c.o
[1018/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_def_rules.c.o
[1019/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_tun.c.o
[1020/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_hwrm.c.o
[1021/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_wh_plus_class.c.o
[1022/2405] Generating rte_net_bond.sym_chk with a meson_exe.py custom command
[1023/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_stingray_act.c.o
[1024/2405] Generating rte_net_bnxt_mingw with a custom command
[1025/2405] Generating rte_net_bnxt_def with a custom command
[1026/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_dlb_selftest.c.o
[1027/2405] Linking target drivers/librte_net_bond.so.21.0
[1028/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_tf_ulp_ulp_template_db_stingray_class.c.o
[1029/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbevf_ethdev.c.o
[1030/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbevf_main.c.o
[1031/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_rte_pmd_bnxt.c.o
[1032/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_clip_tbl.c.o
[1033/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_mps_tcam.c.o
[1034/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbe_flow.c.o
[1035/2405] Generating rte_net_cxgbe_def with a custom command
[1036/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_l2t.c.o
[1037/2405] Compiling C object drivers/libtmp_rte_net_bnxt.a.p/net_bnxt_bnxt_rxtx_vec_sse.c.o
[1038/2405] Generating rte_net_cxgbe_mingw with a custom command
[1039/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbe_ethdev.c.o
[1040/2405] Generating rte_vdpa_ifc.sym_chk with a meson_exe.py custom command
[1041/2405] Linking static target drivers/libtmp_rte_net_bnxt.a
[1042/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbe_filter.c.o
[1043/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_smt.c.o
[1044/2405] Linking target drivers/librte_vdpa_ifc.so.21.0
[1045/2405] Generating rte_net_dpaa_def with a custom command
[1046/2405] Generating rte_net_dpaa_mingw with a custom command
[1047/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_cxgbe_main.c.o
[1048/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_base_t4vf_hw.c.o
[1049/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_fmlib_fm_vsp.c.o
[1050/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_fmlib_fm_lib.c.o
[1051/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_dpaa_fmc.c.o
[1052/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_dpaa_flow.c.o
[1053/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_dlb.c.o
[1054/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_base_dpaa2_hw_dpni.c.o
[1055/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_mux.c.o
[1056/2405] Generating rte_net_bnxt.pmd.c with a custom command
[1057/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_mc_dprtc.c.o
[1058/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_mc_dpkg.c.o
[1059/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_dpaa_ethdev.c.o
[1060/2405] Compiling C object drivers/librte_net_bnxt.so.21.0.p/meson-generated_.._rte_net_bnxt.pmd.c.o
[1061/2405] Compiling C object drivers/librte_net_bnxt.a.p/meson-generated_.._rte_net_bnxt.pmd.c.o
[1062/2405] Generating rte_net_dpaa2_mingw with a custom command
[1063/2405] Generating rte_net_dpaa2_def with a custom command
[1064/2405] Linking static target drivers/librte_net_bnxt.a
[1065/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_sparser.c.o
[1066/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_ptp.c.o
[1067/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_mc_dpdmux.c.o
[1068/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_base_t4_hw.c.o
[1069/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_base.c.o
[1070/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82540.c.o
[1071/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82541.c.o
[1072/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82542.c.o
[1073/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_80003es2lan.c.o
[1074/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_ethdev.c.o
[1075/2405] Compiling C object drivers/libtmp_rte_net_cxgbe.a.p/net_cxgbe_sge.c.o
[1076/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_mc_dpni.c.o
[1077/2405] Linking static target drivers/libtmp_rte_net_cxgbe.a
[1078/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82543.c.o
[1079/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82571.c.o
[1080/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_i210.c.o
[1081/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_api.c.o
[1082/2405] Generating rte_net_cxgbe.pmd.c with a custom command
[1083/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_manage.c.o
[1084/2405] Compiling C object drivers/librte_net_cxgbe.a.p/meson-generated_.._rte_net_cxgbe.pmd.c.o
[1085/2405] Compiling C object drivers/librte_net_cxgbe.so.21.0.p/meson-generated_.._rte_net_cxgbe.pmd.c.o
[1086/2405] Linking static target drivers/librte_net_cxgbe.a
[1087/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_osdep.c.o
[1088/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_mac.c.o
[1089/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_mbx.c.o
[1090/2405] Generating rte_net_bnxt.sym_chk with a meson_exe.py custom command
[1091/2405] Generating pipeline.sym_chk with a meson_exe.py custom command
[1092/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_e1000_logs.c.o
[1093/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_82575.c.o
[1094/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_nvm.c.o
[1095/2405] Linking target drivers/librte_net_bnxt.so.21.0
[1096/2405] Linking target lib/librte_pipeline.so.21.0
[1097/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_vf.c.o
[1098/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_rxtx.c.o
[1099/2405] Generating rte_net_e1000_mingw with a custom command
[1100/2405] Compiling C object drivers/libtmp_rte_net_dpaa2.a.p/net_dpaa2_dpaa2_flow.c.o
[1101/2405] Generating rte_net_e1000_def with a custom command
[1102/2405] Linking static target drivers/libtmp_rte_net_dpaa2.a
[1103/2405] Compiling C object drivers/libtmp_rte_net_vmxnet3.a.p/net_vmxnet3_vmxnet3_rxtx.c.o
[1104/2405] Generating rte_net_dpaa2.pmd.c with a custom command
[1105/2405] Compiling C object drivers/librte_net_dpaa2.a.p/meson-generated_.._rte_net_dpaa2.pmd.c.o
[1106/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_igb_pf.c.o
[1107/2405] Linking static target drivers/librte_net_dpaa2.a
[1108/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_em_ethdev.c.o
[1109/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_ich8lan.c.o
[1110/2405] Compiling C object drivers/librte_net_dpaa2.so.21.0.p/meson-generated_.._rte_net_dpaa2.pmd.c.o
[1111/2405] Compiling C object drivers/libtmp_rte_net_ena.a.p/net_ena_base_ena_eth_com.c.o
[1112/2405] Compiling C object drivers/net/e1000/base/libe1000_base.a.p/e1000_phy.c.o
[1113/2405] Generating rte_net_ena_def with a custom command
[1114/2405] Generating rte_net_ena_mingw with a custom command
[1115/2405] Linking static target drivers/net/e1000/base/libe1000_base.a
[1116/2405] Generating rte_net_enetc_def with a custom command
[1117/2405] Generating rte_net_enetc_mingw with a custom command
[1118/2405] Generating rte_net_cxgbe.sym_chk with a meson_exe.py custom command
[1119/2405] Compiling C object drivers/libtmp_rte_net_dpaa.a.p/net_dpaa_dpaa_rxtx.c.o
[1120/2405] Linking static target drivers/libtmp_rte_net_dpaa.a
[1121/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_igb_flow.c.o
[1122/2405] Linking target drivers/librte_net_cxgbe.so.21.0
[1123/2405] Generating rte_net_dpaa.pmd.c with a custom command
[1124/2405] Generating symbol file lib/librte_pipeline.so.21.0.p/librte_pipeline.so.21.0.symbols
[1125/2405] Compiling C object drivers/librte_net_dpaa.a.p/meson-generated_.._rte_net_dpaa.pmd.c.o
[1126/2405] Compiling C object drivers/librte_net_dpaa.so.21.0.p/meson-generated_.._rte_net_dpaa.pmd.c.o
[1127/2405] Linking static target drivers/librte_net_dpaa.a
[1128/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_base_vnic_cq.c.o
[1129/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_em_rxtx.c.o
[1130/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_base_vnic_intr.c.o
[1131/2405] Compiling C object drivers/libtmp_rte_net_enetc.a.p/net_enetc_enetc_rxtx.c.o
[1132/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_base_vnic_rq.c.o
[1133/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_base_vnic_wq.c.o
[1134/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_igb_rxtx.c.o
[1135/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_base_vnic_dev.c.o
[1136/2405] Compiling C object drivers/libtmp_rte_net_ena.a.p/net_ena_base_ena_com.c.o
[1137/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_clsf.c.o
[1138/2405] Generating rte_net_enic_mingw with a custom command
[1139/2405] Generating rte_net_enic_def with a custom command
[1140/2405] Compiling C object drivers/libtmp_rte_net_enetc.a.p/net_enetc_enetc_ethdev.c.o
[1141/2405] Linking static target drivers/libtmp_rte_net_enetc.a
[1142/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_res.c.o
[1143/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_flow.c.o
[1144/2405] Generating rte_net_enetc.pmd.c with a custom command
[1145/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_ethdev.c.o
[1146/2405] Compiling C object drivers/libtmp_rte_net_ena.a.p/net_ena_ena_ethdev.c.o
[1147/2405] Compiling C object drivers/librte_net_enetc.a.p/meson-generated_.._rte_net_enetc.pmd.c.o
[1148/2405] Linking static target drivers/libtmp_rte_net_ena.a
[1149/2405] Compiling C object drivers/librte_net_enetc.so.21.0.p/meson-generated_.._rte_net_enetc.pmd.c.o
[1150/2405] Linking static target drivers/librte_net_enetc.a
[1151/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_vf_representor.c.o
[1152/2405] Generating rte_net_ena.pmd.c with a custom command
[1153/2405] Generating rte_net_dpaa2.sym_chk with a meson_exe.py custom command
[1154/2405] Compiling C object drivers/librte_net_ena.a.p/meson-generated_.._rte_net_ena.pmd.c.o
[1155/2405] Linking static target drivers/librte_net_ena.a
[1156/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_rxtx_vec_avx2.c.o
[1157/2405] Compiling C object drivers/libtmp_rte_net_e1000.a.p/net_e1000_igb_ethdev.c.o
[1158/2405] Linking target drivers/librte_net_dpaa2.so.21.0
[1159/2405] Linking static target drivers/libtmp_rte_net_e1000.a
[1160/2405] Compiling C object drivers/librte_net_ena.so.21.0.p/meson-generated_.._rte_net_ena.pmd.c.o
[1161/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe.c.o
[1162/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_eal.c.o
[1163/2405] Generating rte_net_dpaa.sym_chk with a meson_exe.py custom command
[1164/2405] Generating rte_net_e1000.pmd.c with a custom command
[1165/2405] Compiling C object drivers/librte_net_e1000.a.p/meson-generated_.._rte_net_e1000.pmd.c.o
[1166/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_args.c.o
[1167/2405] Linking static target drivers/librte_net_e1000.a
[1168/2405] Linking target drivers/librte_net_dpaa.so.21.0
[1169/2405] Compiling C object drivers/librte_net_e1000.so.21.0.p/meson-generated_.._rte_net_e1000.pmd.c.o
[1170/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_flow.c.o
[1171/2405] Generating rte_net_failsafe_def with a custom command
[1172/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_fm_flow.c.o
[1173/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_main.c.o
[1174/2405] Generating rte_net_failsafe_mingw with a custom command
[1175/2405] Compiling C object drivers/libtmp_rte_net_enic.a.p/net_enic_enic_rxtx.c.o
[1176/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_ether.c.o
[1177/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_intr.c.o
[1178/2405] Linking static target drivers/libtmp_rte_net_enic.a
[1179/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_api.c.o
[1180/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_rxtx.c.o
[1181/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_common.c.o
[1182/2405] Generating rte_net_enic.pmd.c with a custom command
[1183/2405] Generating rte_net_enetc.sym_chk with a meson_exe.py custom command
[1184/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_tlv.c.o
[1185/2405] Compiling C object drivers/librte_net_enic.a.p/meson-generated_.._rte_net_enic.pmd.c.o
[1186/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_vf.c.o
[1187/2405] Compiling C object drivers/librte_net_enic.so.21.0.p/meson-generated_.._rte_net_enic.pmd.c.o
[1188/2405] Linking target drivers/librte_net_enetc.so.21.0
[1189/2405] Linking static target drivers/librte_net_enic.a
[1190/2405] Generating rte_net_ena.sym_chk with a meson_exe.py custom command
[1191/2405] Generating rte_net_fm10k_mingw with a custom command
[1192/2405] Generating rte_net_fm10k_def with a custom command
[1193/2405] Generating symbol file drivers/librte_net_dpaa2.so.21.0.p/librte_net_dpaa2.so.21.0.symbols
[1194/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_mbx.c.o
[1195/2405] Linking target drivers/librte_net_ena.so.21.0
[1196/2405] Generating symbol file drivers/librte_net_dpaa.so.21.0.p/librte_net_dpaa.so.21.0.symbols
[1197/2405] Compiling C object drivers/net/fm10k/base/libfm10k_base.a.p/fm10k_pf.c.o
[1198/2405] Linking static target drivers/net/fm10k/base/libfm10k_base.a
[1199/2405] Generating rte_net_e1000.sym_chk with a meson_exe.py custom command
[1200/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_diag.c.o
[1201/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_dcb.c.o
[1202/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_hmc.c.o
[1203/2405] Linking target drivers/librte_net_e1000.so.21.0
[1204/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_adminq.c.o
[1205/2405] Compiling C object drivers/libtmp_rte_net_failsafe.a.p/net_failsafe_failsafe_ops.c.o
[1206/2405] Compiling C object drivers/libtmp_rte_net_fm10k.a.p/net_fm10k_fm10k_rxtx.c.o
[1207/2405] Linking static target drivers/libtmp_rte_net_failsafe.a
[1208/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_lan_hmc.c.o
[1209/2405] Generating rte_net_failsafe.pmd.c with a custom command
[1210/2405] Compiling C object drivers/librte_net_failsafe.a.p/meson-generated_.._rte_net_failsafe.pmd.c.o
[1211/2405] Linking static target drivers/librte_net_failsafe.a
[1212/2405] Compiling C object drivers/libtmp_rte_net_fm10k.a.p/net_fm10k_fm10k_rxtx_vec.c.o
[1213/2405] Compiling C object drivers/librte_net_failsafe.so.21.0.p/meson-generated_.._rte_net_failsafe.pmd.c.o
[1214/2405] Generating rte_net_enic.sym_chk with a meson_exe.py custom command
[1215/2405] Linking target drivers/librte_net_enic.so.21.0
[1216/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_tm.c.o
[1217/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_nvm.c.o
[1218/2405] Compiling C object drivers/libtmp_rte_net_fm10k.a.p/net_fm10k_fm10k_ethdev.c.o
[1219/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_pf.c.o
[1220/2405] Linking static target drivers/libtmp_rte_net_fm10k.a
[1221/2405] Compiling C object drivers/net/i40e/base/libi40e_base.a.p/i40e_common.c.o
[1222/2405] Generating rte_net_i40e_mingw with a custom command
[1223/2405] Linking static target drivers/net/i40e/base/libi40e_base.a
[1224/2405] Generating rte_net_fm10k.pmd.c with a custom command
[1225/2405] Generating rte_net_i40e_def with a custom command
[1226/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_ethdev_vf.c.o
[1227/2405] Compiling C object drivers/librte_net_fm10k.a.p/meson-generated_.._rte_net_fm10k.pmd.c.o
[1228/2405] Compiling C object drivers/librte_net_fm10k.so.21.0.p/meson-generated_.._rte_net_fm10k.pmd.c.o
[1229/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_vf_representor.c.o
[1230/2405] Linking static target drivers/librte_net_fm10k.a
[1231/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_fdir.c.o
[1232/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_flow.c.o
[1233/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_cfg.c.o
[1234/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_eqs.c.o
[1235/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_api_cmd.c.o
[1236/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_cmdq.c.o
[1237/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_hwif.c.o
[1238/2405] Generating rte_net_failsafe.sym_chk with a meson_exe.py custom command
[1239/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_mgmt.c.o
[1240/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_rxtx_vec_sse.c.o
[1241/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_rte_pmd_i40e.c.o
[1242/2405] Linking target drivers/librte_net_failsafe.so.21.0
[1243/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_wq.c.o
[1244/2405] Generating rte_net_hinic_def with a custom command
[1245/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_hwdev.c.o
[1246/2405] Generating rte_net_hinic_mingw with a custom command
[1247/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_nicio.c.o
[1248/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_rxtx_vec_avx2.c.o
[1249/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_rxtx.c.o
[1250/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_mbox.c.o
[1251/2405] Generating rte_net_fm10k.sym_chk with a meson_exe.py custom command
[1252/2405] Compiling C object drivers/net/hinic/base/libhinic_base.a.p/hinic_pmd_niccfg.c.o
[1253/2405] Linking static target drivers/net/hinic/base/libhinic_base.a
[1254/2405] Linking target drivers/librte_net_fm10k.so.21.0
[1255/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_cmd.c.o
[1256/2405] Compiling C object drivers/libtmp_rte_net_hinic.a.p/net_hinic_hinic_pmd_rx.c.o
[1257/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_intr.c.o
[1258/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_mbx.c.o
[1259/2405] Compiling C object drivers/libtmp_rte_net_hinic.a.p/net_hinic_hinic_pmd_ethdev.c.o
[1260/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_dcb.c.o
[1261/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_fdir.c.o
[1262/2405] Generating rte_net_hns3_mingw with a custom command
[1263/2405] Generating rte_net_hns3_def with a custom command
[1264/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_regs.c.o
[1265/2405] Compiling C object drivers/libtmp_rte_net_hinic.a.p/net_hinic_hinic_pmd_flow.c.o
[1266/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_ethdev_vf.c.o
[1267/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_mp.c.o
[1268/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_flow.c.o
[1269/2405] Compiling C object drivers/libtmp_rte_net_hinic.a.p/net_hinic_hinic_pmd_tx.c.o
[1270/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_rss.c.o
[1271/2405] Linking static target drivers/libtmp_rte_net_hinic.a
[1272/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_stats.c.o
[1273/2405] Generating rte_net_hinic.pmd.c with a custom command
[1274/2405] Generating rte_net_iavf_def with a custom command
[1275/2405] Compiling C object drivers/librte_net_hinic.a.p/meson-generated_.._rte_net_hinic.pmd.c.o
[1276/2405] Compiling C object drivers/librte_net_hinic.so.21.0.p/meson-generated_.._rte_net_hinic.pmd.c.o
[1277/2405] Linking static target drivers/librte_net_hinic.a
[1278/2405] Generating rte_net_iavf_mingw with a custom command
[1279/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_generic_flow.c.o
[1280/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_hash.c.o
[1281/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_fdir.c.o
[1282/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_vchnl.c.o
[1283/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_ethdev.c.o
[1284/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_ethdev.c.o
[1285/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_controlq.c.o
[1286/2405] Compiling C object drivers/libtmp_rte_net_i40e.a.p/net_i40e_i40e_ethdev.c.o
[1287/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_nvm.c.o
[1288/2405] Linking static target drivers/libtmp_rte_net_i40e.a
[1289/2405] Generating rte_net_hinic.sym_chk with a meson_exe.py custom command
[1290/2405] Linking target drivers/librte_net_hinic.so.21.0
[1291/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_rxtx.c.o
[1292/2405] Generating rte_net_i40e.pmd.c with a custom command
[1293/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_rxtx_vec_avx2.c.o
[1294/2405] Compiling C object drivers/librte_net_i40e.a.p/meson-generated_.._rte_net_i40e.pmd.c.o
[1295/2405] Compiling C object drivers/librte_net_i40e.so.21.0.p/meson-generated_.._rte_net_i40e.pmd.c.o
[1296/2405] Compiling C object drivers/libtmp_rte_net_hns3.a.p/net_hns3_hns3_rxtx.c.o
[1297/2405] Linking static target drivers/librte_net_i40e.a
[1298/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_fdir.c.o
[1299/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_dcb.c.o
[1300/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_common.c.o
[1301/2405] Linking static target drivers/libtmp_rte_net_hns3.a
[1302/2405] Compiling C object drivers/libtmp_rte_net_iavf.a.p/net_iavf_iavf_rxtx_vec_sse.c.o
[1303/2405] Linking static target drivers/libtmp_rte_net_iavf.a
[1304/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_acl.c.o
[1305/2405] Generating rte_net_hns3.pmd.c with a custom command
[1306/2405] Generating rte_net_iavf.pmd.c with a custom command
[1307/2405] Compiling C object drivers/librte_net_hns3.a.p/meson-generated_.._rte_net_hns3.pmd.c.o
[1308/2405] Compiling C object drivers/librte_net_hns3.so.21.0.p/meson-generated_.._rte_net_hns3.pmd.c.o
[1309/2405] Compiling C object drivers/librte_net_iavf.a.p/meson-generated_.._rte_net_iavf.pmd.c.o
[1310/2405] Linking static target drivers/librte_net_hns3.a
[1311/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_acl_ctrl.c.o
[1312/2405] Linking static target drivers/librte_net_iavf.a
[1313/2405] Compiling C object drivers/librte_net_iavf.so.21.0.p/meson-generated_.._rte_net_iavf.pmd.c.o
[1314/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_generic_flow.c.o
[1315/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_sched.c.o
[1316/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_flow.c.o
[1317/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_switch_filter.c.o
[1318/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_fdir_filter.c.o
[1319/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_hash.c.o
[1320/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_flex_pipe.c.o
[1321/2405] Generating rte_net_ice_mingw with a custom command
[1322/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_acl_filter.c.o
[1323/2405] Generating rte_net_ice_def with a custom command
[1324/2405] Generating rte_net_i40e.sym_chk with a meson_exe.py custom command
[1325/2405] Compiling C object drivers/net/ice/base/libice_base.a.p/ice_switch.c.o
[1326/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_dcf_parent.c.o
[1327/2405] Linking static target drivers/net/ice/base/libice_base.a
[1328/2405] Generating rte_net_hns3.sym_chk with a meson_exe.py custom command
[1329/2405] Linking target drivers/librte_net_i40e.so.21.0
[1330/2405] Generating rte_net_iavf.sym_chk with a meson_exe.py custom command
[1331/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_base.c.o
[1332/2405] Linking target drivers/librte_net_hns3.so.21.0
[1333/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_dcf_ethdev.c.o
[1334/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_api.c.o
[1335/2405] Linking target drivers/librte_net_iavf.so.21.0
[1336/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_i225.c.o
[1337/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_dcf.c.o
[1338/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_rxtx_vec_sse.c.o
[1339/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_manage.c.o
[1340/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_osdep.c.o
[1341/2405] Compiling C object drivers/libtmp_rte_net_igc.a.p/net_igc_igc_logs.c.o
[1342/2405] Generating rte_net_igc_mingw with a custom command
[1343/2405] Generating rte_net_igc_def with a custom command
[1344/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_ethdev.c.o
[1345/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_rxtx_vec_avx2.c.o
[1346/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_mac.c.o
[1347/2405] Compiling C object drivers/libtmp_rte_net_ice.a.p/net_ice_ice_rxtx.c.o
[1348/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_nvm.c.o
[1349/2405] Linking static target drivers/libtmp_rte_net_ice.a
[1350/2405] Compiling C object drivers/libtmp_rte_net_igc.a.p/net_igc_igc_filter.c.o
[1351/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_dcb_82598.c.o
[1352/2405] Compiling C object drivers/libtmp_rte_net_igc.a.p/net_igc_igc_flow.c.o
[1353/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_dcb_82599.c.o
[1354/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_api.c.o
[1355/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_82598.c.o
[1356/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_hv_vf.c.o
[1357/2405] Generating rte_net_ice.pmd.c with a custom command
[1358/2405] Compiling C object drivers/librte_net_ice.a.p/meson-generated_.._rte_net_ice.pmd.c.o
[1359/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_mbx.c.o
[1360/2405] Linking static target drivers/librte_net_ice.a
[1361/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_82599.c.o
[1362/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_dcb.c.o
[1363/2405] Compiling C object drivers/librte_net_ice.so.21.0.p/meson-generated_.._rte_net_ice.pmd.c.o
[1364/2405] Compiling C object drivers/net/igc/base/libigc_base.a.p/igc_phy.c.o
[1365/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_vf.c.o
[1366/2405] Linking static target drivers/net/igc/base/libigc_base.a
[1367/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_x540.c.o
[1368/2405] Compiling C object drivers/libtmp_rte_net_igc.a.p/net_igc_igc_ethdev.c.o
[1369/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_82599_bypass.c.o
[1370/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_bypass.c.o
[1371/2405] Compiling C object drivers/libtmp_rte_net_igc.a.p/net_igc_igc_txrx.c.o
[1372/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_phy.c.o
[1373/2405] Linking static target drivers/libtmp_rte_net_igc.a
[1374/2405] Generating rte_net_igc.pmd.c with a custom command
[1375/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_fdir.c.o
[1376/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_common.c.o
[1377/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_ipsec.c.o
[1378/2405] Compiling C object drivers/librte_net_igc.a.p/meson-generated_.._rte_net_igc.pmd.c.o
[1379/2405] Compiling C object drivers/librte_net_igc.so.21.0.p/meson-generated_.._rte_net_igc.pmd.c.o
[1380/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_tm.c.o
[1381/2405] Generating rte_net_ixgbe_mingw with a custom command
[1382/2405] Linking static target drivers/librte_net_igc.a
[1383/2405] Generating rte_net_ixgbe_def with a custom command
[1384/2405] Compiling C object drivers/net/ixgbe/base/libixgbe_base.a.p/ixgbe_x550.c.o
[1385/2405] Generating rte_net_kni_def with a custom command
[1386/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_pf.c.o
[1387/2405] Generating rte_net_kni_mingw with a custom command
[1388/2405] Linking static target drivers/net/ixgbe/base/libixgbe_base.a
[1389/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_vf_representor.c.o
[1390/2405] Generating rte_net_liquidio_def with a custom command
[1391/2405] Generating rte_net_liquidio_mingw with a custom command
[1392/2405] Generating rte_net_ice.sym_chk with a meson_exe.py custom command
[1393/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_rte_pmd_ixgbe.c.o
[1394/2405] Compiling C object drivers/libtmp_rte_net_kni.a.p/net_kni_rte_eth_kni.c.o
[1395/2405] Linking target drivers/librte_net_ice.so.21.0
[1396/2405] Linking static target drivers/libtmp_rte_net_kni.a
[1397/2405] Compiling C object drivers/libtmp_rte_net_liquidio.a.p/net_liquidio_base_lio_mbox.c.o
[1398/2405] Generating rte_net_memif_def with a custom command
[1399/2405] Generating rte_net_kni.pmd.c with a custom command
[1400/2405] Compiling C object drivers/libtmp_rte_net_liquidio.a.p/net_liquidio_base_lio_23xx_vf.c.o
[1401/2405] Generating rte_net_memif_mingw with a custom command
[1402/2405] Compiling C object drivers/librte_net_kni.a.p/meson-generated_.._rte_net_kni.pmd.c.o
[1403/2405] Compiling C object drivers/librte_net_kni.so.21.0.p/meson-generated_.._rte_net_kni.pmd.c.o
[1404/2405] Linking static target drivers/librte_net_kni.a
[1405/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_flow.c.o
[1406/2405] Compiling C object drivers/libtmp_rte_net_liquidio.a.p/net_liquidio_lio_ethdev.c.o
[1407/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_rxtx_vec_sse.c.o
[1408/2405] Compiling C object drivers/libtmp_rte_net_memif.a.p/net_memif_memif_socket.c.o
[1409/2405] Generating rte_net_netvsc_def with a custom command
[1410/2405] Generating rte_net_netvsc_mingw with a custom command
[1411/2405] Generating rte_net_igc.sym_chk with a meson_exe.py custom command
[1412/2405] Linking target drivers/librte_net_igc.so.21.0
[1413/2405] Compiling C object drivers/libtmp_rte_net_netvsc.a.p/net_netvsc_hn_ethdev.c.o
[1414/2405] Compiling C object drivers/libtmp_rte_net_netvsc.a.p/net_netvsc_hn_rndis.c.o
[1415/2405] Compiling C object drivers/libtmp_rte_net_netvsc.a.p/net_netvsc_hn_nvs.c.o
[1416/2405] Compiling C object drivers/libtmp_rte_net_netvsc.a.p/net_netvsc_hn_vf.c.o
[1417/2405] Compiling C object drivers/libtmp_rte_net_liquidio.a.p/net_liquidio_lio_rxtx.c.o
[1418/2405] Linking static target drivers/libtmp_rte_net_liquidio.a
[1419/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_resource.c.o
[1420/2405] Compiling C object drivers/libtmp_rte_net_memif.a.p/net_memif_rte_eth_memif.c.o
[1421/2405] Generating rte_net_liquidio.pmd.c with a custom command
[1422/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_nsp.c.o
[1423/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_mip.c.o
[1424/2405] Linking static target drivers/libtmp_rte_net_memif.a
[1425/2405] Compiling C object drivers/librte_net_liquidio.a.p/meson-generated_.._rte_net_liquidio.pmd.c.o
[1426/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_nffw.c.o
[1427/2405] Compiling C object drivers/librte_net_liquidio.so.21.0.p/meson-generated_.._rte_net_liquidio.pmd.c.o
[1428/2405] Linking static target drivers/librte_net_liquidio.a
[1429/2405] Generating rte_net_memif.pmd.c with a custom command
[1430/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_crc.c.o
[1431/2405] Compiling C object drivers/librte_net_memif.a.p/meson-generated_.._rte_net_memif.pmd.c.o
[1432/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_cppcore.c.o
[1433/2405] Linking static target drivers/librte_net_memif.a
[1434/2405] Compiling C object drivers/librte_net_memif.so.21.0.p/meson-generated_.._rte_net_memif.pmd.c.o
[1435/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_cpp_pcie_ops.c.o
[1436/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_rtsym.c.o
[1437/2405] Generating rte_net_nfp_def with a custom command
[1438/2405] Generating rte_net_kni.sym_chk with a meson_exe.py custom command
[1439/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_nsp_cmds.c.o
[1440/2405] Generating rte_net_nfp_mingw with a custom command
[1441/2405] Generating rte_net_null_def with a custom command
[1442/2405] Generating rte_net_null_mingw with a custom command
[1443/2405] Linking target drivers/librte_net_kni.so.21.0
[1444/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_ethdev.c.o
[1445/2405] Compiling C object drivers/libtmp_rte_net_netvsc.a.p/net_netvsc_hn_rxtx.c.o
[1446/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_mutex.c.o
[1447/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_hwinfo.c.o
[1448/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfpcore_nfp_nsp_eth.c.o
[1449/2405] Linking static target drivers/libtmp_rte_net_netvsc.a
[1450/2405] Generating rte_net_octeontx_def with a custom command
[1451/2405] Generating rte_net_octeontx_mingw with a custom command
[1452/2405] Compiling C object drivers/net/octeontx/base/libocteontx_base.a.p/octeontx_pkivf.c.o
[1453/2405] Compiling C object drivers/net/octeontx/base/libocteontx_base.a.p/octeontx_bgx.c.o
[1454/2405] Generating rte_net_netvsc.pmd.c with a custom command
[1455/2405] Linking static target drivers/net/octeontx/base/libocteontx_base.a
[1456/2405] Compiling C object drivers/libtmp_rte_net_ixgbe.a.p/net_ixgbe_ixgbe_rxtx.c.o
[1457/2405] Compiling C object drivers/librte_net_netvsc.a.p/meson-generated_.._rte_net_netvsc.pmd.c.o
[1458/2405] Compiling C object drivers/librte_net_netvsc.so.21.0.p/meson-generated_.._rte_net_netvsc.pmd.c.o
[1459/2405] Linking static target drivers/libtmp_rte_net_ixgbe.a
[1460/2405] Linking static target drivers/librte_net_netvsc.a
[1461/2405] Generating rte_net_ixgbe.pmd.c with a custom command
[1462/2405] Compiling C object drivers/libtmp_rte_net_octeontx.a.p/net_octeontx_octeontx_ethdev_ops.c.o
[1463/2405] Compiling C object drivers/librte_net_ixgbe.a.p/meson-generated_.._rte_net_ixgbe.pmd.c.o
[1464/2405] Linking static target drivers/librte_net_ixgbe.a
[1465/2405] Compiling C object drivers/librte_net_ixgbe.so.21.0.p/meson-generated_.._rte_net_ixgbe.pmd.c.o
[1466/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_rss.c.o
[1467/2405] Generating rte_net_liquidio.sym_chk with a meson_exe.py custom command
[1468/2405] Compiling C object drivers/libtmp_rte_net_null.a.p/net_null_rte_eth_null.c.o
[1469/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_mac.c.o
[1470/2405] Linking static target drivers/libtmp_rte_net_null.a
[1471/2405] Compiling C object drivers/libtmp_rte_net_octeontx.a.p/net_octeontx_octeontx_ethdev.c.o
[1472/2405] Generating rte_net_null.pmd.c with a custom command
[1473/2405] Linking target drivers/librte_net_liquidio.so.21.0
[1474/2405] Generating rte_net_memif.sym_chk with a meson_exe.py custom command
[1475/2405] Compiling C object drivers/librte_net_null.a.p/meson-generated_.._rte_net_null.pmd.c.o
[1476/2405] Compiling C object drivers/librte_net_null.so.21.0.p/meson-generated_.._rte_net_null.pmd.c.o
[1477/2405] Linking target drivers/librte_net_memif.so.21.0
[1478/2405] Linking static target drivers/librte_net_null.a
[1479/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_tx.c.o
[1480/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ptp.c.o
[1481/2405] Compiling C object drivers/libtmp_rte_net_nfp.a.p/net_nfp_nfp_net.c.o
[1482/2405] Linking static target drivers/libtmp_rte_net_nfp.a
[1483/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_link.c.o
[1484/2405] Generating rte_net_netvsc.sym_chk with a meson_exe.py custom command
[1485/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_mcast.c.o
[1486/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_stats.c.o
[1487/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_lookup.c.o
[1488/2405] Linking target drivers/librte_net_netvsc.so.21.0
[1489/2405] Generating rte_net_nfp.pmd.c with a custom command
[1490/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_vlan.c.o
[1491/2405] Compiling C object drivers/librte_net_nfp.a.p/meson-generated_.._rte_net_nfp.pmd.c.o
[1492/2405] Compiling C object drivers/librte_net_nfp.so.21.0.p/meson-generated_.._rte_net_nfp.pmd.c.o
[1493/2405] Linking static target drivers/librte_net_nfp.a
[1494/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_flow.c.o
[1495/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_tm.c.o
[1496/2405] Compiling C object drivers/libtmp_rte_net_octeontx.a.p/net_octeontx_octeontx_rxtx.c.o
[1497/2405] Linking static target drivers/libtmp_rte_net_octeontx.a
[1498/2405] Generating rte_net_octeontx.pmd.c with a custom command
[1499/2405] Compiling C object drivers/librte_net_octeontx.a.p/meson-generated_.._rte_net_octeontx.pmd.c.o
[1500/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_flow_ctrl.c.o
[1501/2405] Generating rte_net_ixgbe.sym_chk with a meson_exe.py custom command
[1502/2405] Linking static target drivers/librte_net_octeontx.a
[1503/2405] Generating rte_net_null.sym_chk with a meson_exe.py custom command
[1504/2405] Compiling C object drivers/librte_net_octeontx.so.21.0.p/meson-generated_.._rte_net_octeontx.pmd.c.o
[1505/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev_irq.c.o
[1506/2405] Generating rte_net_octeontx2_mingw with a custom command
[1507/2405] Generating rte_net_octeontx2_def with a custom command
[1508/2405] Linking target drivers/librte_net_ixgbe.so.21.0
[1509/2405] Linking target drivers/librte_net_null.so.21.0
[1510/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev_ops.c.o
[1511/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_flow_parse.c.o
[1512/2405] Generating rte_net_pfe_def with a custom command
[1513/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev_devargs.c.o
[1514/2405] Generating rte_net_pfe_mingw with a custom command
[1515/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev_sec.c.o
[1516/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev_debug.c.o
[1517/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_flow_utils.c.o
[1518/2405] Compiling C object drivers/libtmp_rte_net_pfe.a.p/net_pfe_pfe_hal.c.o
[1519/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_ethdev.c.o
[1520/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/bcm_osal.c.o
[1521/2405] Generating rte_net_nfp.sym_chk with a meson_exe.py custom command
[1522/2405] Compiling C object drivers/libtmp_rte_net_pfe.a.p/net_pfe_pfe_hif.c.o
[1523/2405] Linking target drivers/librte_net_nfp.so.21.0
[1524/2405] Compiling C object drivers/libtmp_rte_net_pfe.a.p/net_pfe_pfe_hif_lib.c.o
[1525/2405] Compiling C object drivers/libtmp_rte_net_pfe.a.p/net_pfe_pfe_ethdev.c.o
[1526/2405] Linking static target drivers/libtmp_rte_net_pfe.a
[1527/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_init_ops.c.o
[1528/2405] Generating rte_net_pfe.pmd.c with a custom command
[1529/2405] Generating rte_net_octeontx.sym_chk with a meson_exe.py custom command
[1530/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_dcbx.c.o
[1531/2405] Compiling C object drivers/librte_net_pfe.a.p/meson-generated_.._rte_net_pfe.pmd.c.o
[1532/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_hw.c.o
[1533/2405] Compiling C object drivers/librte_net_pfe.so.21.0.p/meson-generated_.._rte_net_pfe.pmd.c.o
[1534/2405] Linking target drivers/librte_net_octeontx.so.21.0
[1535/2405] Linking static target drivers/librte_net_pfe.a
[1536/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_cxt.c.o
[1537/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_init_fw_funcs.c.o
[1538/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_sp_commands.c.o
[1539/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_l2.c.o
[1540/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_int.c.o
[1541/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_spq.c.o
[1542/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_main.c.o
[1543/2405] Generating rte_net_qede_mingw with a custom command
[1544/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_sriov.c.o
[1545/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_filter.c.o
[1546/2405] Generating rte_net_qede_def with a custom command
[1547/2405] Generating rte_net_ring_def with a custom command
[1548/2405] Generating rte_net_ring_mingw with a custom command
[1549/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_regs.c.o
[1550/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_vf.c.o
[1551/2405] Generating symbol file drivers/librte_net_octeontx.so.21.0.p/librte_net_octeontx.so.21.0.symbols
[1552/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_mcp.c.o
[1553/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_ethdev.c.o
[1554/2405] Generating rte_net_pfe.sym_chk with a meson_exe.py custom command
[1555/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_sriov.c.o
[1556/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_kvargs.c.o
[1557/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_mcdi.c.o
[1558/2405] Linking target drivers/librte_net_pfe.so.21.0
[1559/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_intr.c.o
[1560/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_dev.c.o
[1561/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc.c.o
[1562/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ethdev.c.o
[1563/2405] Compiling C object drivers/libtmp_rte_net_ring.a.p/net_ring_rte_eth_ring.c.o
[1564/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_tso.c.o
[1565/2405] Compiling C object drivers/net/qede/base/libqede_base.a.p/ecore_sriov.c.o
[1566/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_port.c.o
[1567/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ev.c.o
[1568/2405] Linking static target drivers/libtmp_rte_net_ring.a
[1569/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_filter.c.o
[1570/2405] Linking static target drivers/net/qede/base/libqede_base.a
[1571/2405] Generating rte_net_ring.pmd.c with a custom command
[1572/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_switch.c.o
[1573/2405] Compiling C object drivers/librte_net_ring.a.p/meson-generated_.._rte_net_ring.pmd.c.o
[1574/2405] Linking static target drivers/librte_net_ring.a
[1575/2405] Compiling C object drivers/librte_net_ring.so.21.0.p/meson-generated_.._rte_net_ring.pmd.c.o
[1576/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_dp.c.o
[1577/2405] Generating rte_net_sfc_def with a custom command
[1578/2405] Generating rte_net_sfc_mingw with a custom command
[1579/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_rx.c.o
[1580/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_mae.c.o
[1581/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_tx.c.o
[1582/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ef100_rx.c.o
[1583/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ef10_essb_rx.c.o
[1584/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_mempool.c.o
[1585/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_rxtx.c.o
[1586/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ef10_rx.c.o
[1587/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_parser.c.o
[1588/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_flow.c.o
[1589/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_link.c.o
[1590/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_tap.c.o
[1591/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ef100_tx.c.o
[1592/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_swq.c.o
[1593/2405] Generating rte_net_ring.sym_chk with a meson_exe.py custom command
[1594/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic.c.o
[1595/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_action.c.o
[1596/2405] Compiling C object drivers/libtmp_rte_net_sfc.a.p/net_sfc_sfc_ef10_tx.c.o
[1597/2405] Generating rte_net_softnic_def with a custom command
[1598/2405] Generating rte_net_softnic_mingw with a custom command
[1599/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_conn.c.o
[1600/2405] Linking target drivers/librte_net_ring.so.21.0
[1601/2405] Linking static target drivers/libtmp_rte_net_sfc.a
[1602/2405] Compiling C object drivers/libtmp_rte_net_qede.a.p/net_qede_qede_debug.c.o
[1603/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_cryptodev.c.o
[1604/2405] Linking static target drivers/libtmp_rte_net_qede.a
[1605/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_pipeline.c.o
[1606/2405] Generating rte_net_qede.pmd.c with a custom command
[1607/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_meter.c.o
[1608/2405] Compiling C object drivers/librte_net_qede.a.p/meson-generated_.._rte_net_qede.pmd.c.o
[1609/2405] Compiling C object drivers/librte_net_qede.so.21.0.p/meson-generated_.._rte_net_qede.pmd.c.o
[1610/2405] Linking static target drivers/librte_net_qede.a
[1611/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_tap_bpf_api.c.o
[1612/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_tap_intr.c.o
[1613/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_tap_netlink.c.o
[1614/2405] Generating rte_net_sfc.pmd.c with a custom command
[1615/2405] Generating rte_net_tap_mingw with a custom command
[1616/2405] Generating rte_net_tap_def with a custom command
[1617/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_flow.c.o
[1618/2405] Compiling C object drivers/librte_net_sfc.so.21.0.p/meson-generated_.._rte_net_sfc.pmd.c.o
[1619/2405] Compiling C object drivers/librte_net_sfc.a.p/meson-generated_.._rte_net_sfc.pmd.c.o
[1620/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_tap_tcmsgs.c.o
[1621/2405] Linking static target drivers/librte_net_sfc.a
[1622/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_tm.c.o
[1623/2405] Generating rte_net_thunderx_def with a custom command
[1624/2405] Compiling C object drivers/libtmp_rte_net_thunderx.a.p/net_thunderx_nicvf_svf.c.o
[1625/2405] Generating rte_net_thunderx_mingw with a custom command
[1626/2405] Compiling C object drivers/net/thunderx/base/libnicvf_base.a.p/nicvf_bsvf.c.o
[1627/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_tap_flow.c.o
[1628/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_thread.c.o
[1629/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_dcb_hw.c.o
[1630/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_dcb.c.o
[1631/2405] Compiling C object drivers/net/thunderx/base/libnicvf_base.a.p/nicvf_hw.c.o
[1632/2405] Compiling C object drivers/net/thunderx/base/libnicvf_base.a.p/nicvf_mbox.c.o
[1633/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_mbx.c.o
[1634/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_eeprom.c.o
[1635/2405] Linking static target drivers/net/thunderx/base/libnicvf_base.a
[1636/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_mng.c.o
[1637/2405] Generating rte_net_txgbe_def with a custom command
[1638/2405] Compiling C object drivers/libtmp_rte_net_thunderx.a.p/net_thunderx_nicvf_rxtx.c.o
[1639/2405] Compiling C object drivers/libtmp_rte_net_txgbe.a.p/net_txgbe_txgbe_ptypes.c.o
[1640/2405] Generating rte_net_qede.sym_chk with a meson_exe.py custom command
[1641/2405] Generating rte_net_txgbe_mingw with a custom command
[1642/2405] Generating rte_net_vdev_netvsc_def with a custom command
[1643/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_phy.c.o
[1644/2405] Generating rte_net_vdev_netvsc_mingw with a custom command
[1645/2405] Generating rte_net_vhost_def with a custom command
[1646/2405] Generating rte_net_sfc.sym_chk with a meson_exe.py custom command
[1647/2405] Generating rte_net_vhost_mingw with a custom command
[1648/2405] Linking target drivers/librte_net_qede.so.21.0
[1649/2405] Compiling C object drivers/libtmp_rte_net_txgbe.a.p/net_txgbe_txgbe_pf.c.o
[1650/2405] Linking target drivers/librte_net_sfc.so.21.0
[1651/2405] Compiling C object drivers/net/txgbe/base/libtxgbe_base.a.p/txgbe_hw.c.o
[1652/2405] Linking static target drivers/net/txgbe/base/libtxgbe_base.a
[1653/2405] Compiling C object drivers/libtmp_rte_net_vdev_netvsc.a.p/net_vdev_netvsc_vdev_netvsc.c.o
[1654/2405] Linking static target drivers/libtmp_rte_net_vdev_netvsc.a
[1655/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_rxtx_simple.c.o
[1656/2405] Compiling C object drivers/libtmp_rte_net_softnic.a.p/net_softnic_rte_eth_softnic_cli.c.o
[1657/2405] Generating rte_net_vdev_netvsc.pmd.c with a custom command
[1658/2405] Linking static target drivers/libtmp_rte_net_softnic.a
[1659/2405] Compiling C object drivers/librte_net_vdev_netvsc.a.p/meson-generated_.._rte_net_vdev_netvsc.pmd.c.o
[1660/2405] Compiling C object drivers/libtmp_rte_net_tap.a.p/net_tap_rte_eth_tap.c.o
[1661/2405] Linking static target drivers/librte_net_vdev_netvsc.a
[1662/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_rxtx_simple_sse.c.o
[1663/2405] Compiling C object drivers/librte_net_vdev_netvsc.so.21.0.p/meson-generated_.._rte_net_vdev_netvsc.pmd.c.o
[1664/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_pci.c.o
[1665/2405] Linking static target drivers/libtmp_rte_net_tap.a
[1666/2405] Compiling C object drivers/libtmp_rte_net_thunderx.a.p/net_thunderx_nicvf_ethdev.c.o
[1667/2405] Linking static target drivers/libtmp_rte_net_thunderx.a
[1668/2405] Generating rte_net_tap.pmd.c with a custom command
[1669/2405] Compiling C object drivers/libtmp_rte_net_txgbe.a.p/net_txgbe_txgbe_ethdev.c.o
[1670/2405] Generating rte_net_thunderx.pmd.c with a custom command
[1671/2405] Compiling C object drivers/librte_net_tap.a.p/meson-generated_.._rte_net_tap.pmd.c.o
[1672/2405] Generating rte_net_softnic.pmd.c with a custom command
[1673/2405] Compiling C object drivers/librte_net_tap.so.21.0.p/meson-generated_.._rte_net_tap.pmd.c.o
[1674/2405] Compiling C object drivers/librte_net_softnic.so.21.0.p/meson-generated_.._rte_net_softnic.pmd.c.o
[1675/2405] Linking static target drivers/librte_net_tap.a
[1676/2405] Compiling C object drivers/librte_net_thunderx.a.p/meson-generated_.._rte_net_thunderx.pmd.c.o
[1677/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_ethdev.c.o
[1678/2405] Compiling C object drivers/librte_net_thunderx.so.21.0.p/meson-generated_.._rte_net_thunderx.pmd.c.o
[1679/2405] Compiling C object drivers/librte_net_softnic.a.p/meson-generated_.._rte_net_softnic.pmd.c.o
[1680/2405] Linking static target drivers/librte_net_thunderx.a
[1681/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_vhost_kernel_tap.c.o
[1682/2405] Compiling C object drivers/libtmp_rte_net_vhost.a.p/net_vhost_rte_eth_vhost.c.o
[1683/2405] Linking static target drivers/librte_net_softnic.a
[1684/2405] Linking static target drivers/libtmp_rte_net_vhost.a
[1685/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtqueue.c.o
[1686/2405] Generating rte_net_vhost.pmd.c with a custom command
[1687/2405] Generating rte_net_virtio_mingw with a custom command
[1688/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_vhost_kernel.c.o
[1689/2405] Compiling C object drivers/librte_net_vhost.so.21.0.p/meson-generated_.._rte_net_vhost.pmd.c.o
[1690/2405] Compiling C object drivers/librte_net_vhost.a.p/meson-generated_.._rte_net_vhost.pmd.c.o
[1691/2405] Linking static target drivers/librte_net_vhost.a
[1692/2405] Generating rte_net_virtio_def with a custom command
[1693/2405] Generating rte_net_vmxnet3_def with a custom command
[1694/2405] Generating rte_net_vmxnet3_mingw with a custom command
[1695/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_vhost_vdpa.c.o
[1696/2405] Generating rte_raw_dpaa2_cmdif_def with a custom command
[1697/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_vhost_user.c.o
[1698/2405] Generating rte_raw_dpaa2_cmdif_mingw with a custom command
[1699/2405] Generating rte_raw_dpaa2_qdma_def with a custom command
[1700/2405] Generating rte_raw_dpaa2_qdma_mingw with a custom command
[1701/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_ethdev.c.o
[1702/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_user_virtio_user_dev.c.o
[1703/2405] Compiling C object drivers/libtmp_rte_raw_dpaa2_cmdif.a.p/raw_dpaa2_cmdif_dpaa2_cmdif.c.o
[1704/2405] Generating rte_net_vdev_netvsc.sym_chk with a meson_exe.py custom command
[1705/2405] Linking static target drivers/libtmp_rte_raw_dpaa2_cmdif.a
[1706/2405] Generating rte_raw_dpaa2_cmdif.pmd.c with a custom command
[1707/2405] Compiling C object drivers/librte_raw_dpaa2_cmdif.a.p/meson-generated_.._rte_raw_dpaa2_cmdif.pmd.c.o
[1708/2405] Linking target drivers/librte_net_vdev_netvsc.so.21.0
[1709/2405] Linking static target drivers/librte_raw_dpaa2_cmdif.a
[1710/2405] Compiling C object drivers/librte_raw_dpaa2_cmdif.so.21.0.p/meson-generated_.._rte_raw_dpaa2_cmdif.pmd.c.o
[1711/2405] Generating rte_net_tap.sym_chk with a meson_exe.py custom command
[1712/2405] Compiling C object drivers/libtmp_rte_raw_ioat.a.p/raw_ioat_idxd_vdev.c.o
[1713/2405] Compiling C object drivers/libtmp_rte_raw_ioat.a.p/raw_ioat_ioat_common.c.o
[1714/2405] Compiling C object drivers/libtmp_rte_raw_ioat.a.p/raw_ioat_idxd_pci.c.o
[1715/2405] Generating rte_raw_ioat_def with a custom command
[1716/2405] Compiling C object drivers/libtmp_rte_net_vmxnet3.a.p/net_vmxnet3_vmxnet3_ethdev.c.o
[1717/2405] Generating rte_net_softnic.sym_chk with a meson_exe.py custom command
[1718/2405] Linking static target drivers/libtmp_rte_net_vmxnet3.a
[1719/2405] Generating rte_net_thunderx.sym_chk with a meson_exe.py custom command
[1720/2405] Compiling C object drivers/libtmp_rte_net_txgbe.a.p/net_txgbe_txgbe_rxtx.c.o
[1721/2405] Generating rte_raw_ioat_mingw with a custom command
[1722/2405] Linking target drivers/librte_net_tap.so.21.0
[1723/2405] Linking static target drivers/libtmp_rte_net_txgbe.a
[1724/2405] Generating rte_net_vmxnet3.pmd.c with a custom command
[1725/2405] Compiling C object drivers/librte_net_vmxnet3.a.p/meson-generated_.._rte_net_vmxnet3.pmd.c.o
[1726/2405] Compiling C object drivers/libtmp_rte_raw_ioat.a.p/raw_ioat_ioat_rawdev.c.o
[1727/2405] Generating rte_raw_ntb_def with a custom command
[1728/2405] Linking target drivers/librte_net_thunderx.so.21.0
[1729/2405] Linking static target drivers/librte_net_vmxnet3.a
[1730/2405] Generating rte_net_txgbe.pmd.c with a custom command
[1731/2405] Generating rte_net_vhost.sym_chk with a meson_exe.py custom command
[1732/2405] Compiling C object drivers/librte_net_vmxnet3.so.21.0.p/meson-generated_.._rte_net_vmxnet3.pmd.c.o
[1733/2405] Linking target drivers/librte_net_softnic.so.21.0
[1734/2405] Compiling C object drivers/librte_net_txgbe.so.21.0.p/meson-generated_.._rte_net_txgbe.pmd.c.o
[1735/2405] Generating rte_raw_ntb_mingw with a custom command
[1736/2405] Compiling C object drivers/librte_net_txgbe.a.p/meson-generated_.._rte_net_txgbe.pmd.c.o
[1737/2405] Linking static target drivers/librte_net_txgbe.a
[1738/2405] Generating rte_raw_octeontx2_dma_def with a custom command
[1739/2405] Linking target drivers/librte_net_vhost.so.21.0
[1740/2405] Generating rte_raw_octeontx2_dma_mingw with a custom command
[1741/2405] Compiling C object drivers/libtmp_rte_raw_ntb.a.p/raw_ntb_ntb_hw_intel.c.o
[1742/2405] Compiling C object drivers/libtmp_rte_net_octeontx2.a.p/net_octeontx2_otx2_rx.c.o
[1743/2405] Linking static target drivers/libtmp_rte_net_octeontx2.a
[1744/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_dma.a.p/raw_octeontx2_dma_otx2_dpi_msg.c.o
[1745/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_dma.a.p/raw_octeontx2_dma_otx2_dpi_test.c.o
[1746/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_ep.a.p/raw_octeontx2_ep_otx2_ep_rawdev.c.o
[1747/2405] Generating rte_raw_octeontx2_ep_def with a custom command
[1748/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_dma.a.p/raw_octeontx2_dma_otx2_dpi_rawdev.c.o
[1749/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_ep.a.p/raw_octeontx2_ep_otx2_ep_test.c.o
[1750/2405] Generating rte_raw_octeontx2_ep_mingw with a custom command
[1751/2405] Linking static target drivers/libtmp_rte_raw_octeontx2_dma.a
[1752/2405] Generating rte_raw_skeleton_mingw with a custom command
[1753/2405] Generating rte_raw_octeontx2_dma.pmd.c with a custom command
[1754/2405] Generating rte_raw_skeleton_def with a custom command
[1755/2405] Generating rte_net_octeontx2.pmd.c with a custom command
[1756/2405] Compiling C object drivers/librte_raw_octeontx2_dma.a.p/meson-generated_.._rte_raw_octeontx2_dma.pmd.c.o
[1757/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_ep.a.p/raw_octeontx2_ep_otx2_ep_enqdeq.c.o
[1758/2405] Compiling C object drivers/libtmp_rte_raw_octeontx2_ep.a.p/raw_octeontx2_ep_otx2_ep_vf.c.o
[1759/2405] Compiling C object drivers/librte_raw_octeontx2_dma.so.21.0.p/meson-generated_.._rte_raw_octeontx2_dma.pmd.c.o
[1760/2405] Generating rte_raw_dpaa2_cmdif.sym_chk with a meson_exe.py custom command
[1761/2405] Linking static target drivers/libtmp_rte_raw_octeontx2_ep.a
[1762/2405] Compiling C object drivers/librte_net_octeontx2.a.p/meson-generated_.._rte_net_octeontx2.pmd.c.o
[1763/2405] Compiling C object drivers/librte_net_octeontx2.so.21.0.p/meson-generated_.._rte_net_octeontx2.pmd.c.o
[1764/2405] Linking static target drivers/librte_raw_octeontx2_dma.a
[1765/2405] Compiling C object drivers/libtmp_rte_raw_dpaa2_qdma.a.p/raw_dpaa2_qdma_dpaa2_qdma.c.o
[1766/2405] Linking static target drivers/librte_net_octeontx2.a
[1767/2405] Generating rte_raw_octeontx2_ep.pmd.c with a custom command
[1768/2405] Linking static target drivers/libtmp_rte_raw_dpaa2_qdma.a
[1769/2405] Linking target drivers/librte_raw_dpaa2_cmdif.so.21.0
[1770/2405] Generating rte_raw_dpaa2_qdma.pmd.c with a custom command
[1771/2405] Compiling C object drivers/librte_raw_octeontx2_ep.a.p/meson-generated_.._rte_raw_octeontx2_ep.pmd.c.o
[1772/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_logs.c.o
[1773/2405] Compiling C object drivers/librte_raw_octeontx2_ep.so.21.0.p/meson-generated_.._rte_raw_octeontx2_ep.pmd.c.o
[1774/2405] Compiling C object drivers/librte_raw_dpaa2_qdma.a.p/meson-generated_.._rte_raw_dpaa2_qdma.pmd.c.o
[1775/2405] Compiling C object drivers/librte_raw_dpaa2_qdma.so.21.0.p/meson-generated_.._rte_raw_dpaa2_qdma.pmd.c.o
[1776/2405] Linking static target drivers/librte_raw_octeontx2_ep.a
[1777/2405] Generating rte_net_vmxnet3.sym_chk with a meson_exe.py custom command
[1778/2405] Linking static target drivers/librte_raw_dpaa2_qdma.a
[1779/2405] Compiling C object drivers/libtmp_rte_raw_ioat.a.p/raw_ioat_ioat_rawdev_test.c.o
[1780/2405] Linking static target drivers/libtmp_rte_raw_ioat.a
[1781/2405] Compiling C object drivers/libtmp_rte_raw_skeleton.a.p/raw_skeleton_skeleton_rawdev_test.c.o
[1782/2405] Compiling C object drivers/libtmp_rte_raw_skeleton.a.p/raw_skeleton_skeleton_rawdev.c.o
[1783/2405] Linking target drivers/librte_net_vmxnet3.so.21.0
[1784/2405] Generating rte_raw_ioat.pmd.c with a custom command
[1785/2405] Linking static target drivers/libtmp_rte_raw_skeleton.a
[1786/2405] Generating rte_net_txgbe.sym_chk with a meson_exe.py custom command
[1787/2405] Compiling C object drivers/librte_raw_ioat.a.p/meson-generated_.._rte_raw_ioat.pmd.c.o
[1788/2405] Compiling C object drivers/librte_raw_ioat.so.21.0.p/meson-generated_.._rte_raw_ioat.pmd.c.o
[1789/2405] Compiling C object drivers/libtmp_rte_raw_ntb.a.p/raw_ntb_ntb.c.o
[1790/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_device.c.o
[1791/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_vfio.c.o
[1792/2405] Linking static target drivers/librte_raw_ioat.a
[1793/2405] Linking static target drivers/libtmp_rte_raw_ntb.a
[1794/2405] Generating rte_raw_skeleton.pmd.c with a custom command
[1795/2405] Linking target drivers/librte_net_txgbe.so.21.0
[1796/2405] Generating rte_raw_ntb.pmd.c with a custom command
[1797/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_qp.c.o
[1798/2405] Compiling C object drivers/librte_raw_skeleton.a.p/meson-generated_.._rte_raw_skeleton.pmd.c.o
[1799/2405] Compiling C object drivers/librte_raw_skeleton.so.21.0.p/meson-generated_.._rte_raw_skeleton.pmd.c.o
[1800/2405] Compiling C object drivers/librte_raw_ntb.a.p/meson-generated_.._rte_raw_ntb.pmd.c.o
[1801/2405] Compiling C object drivers/librte_raw_ntb.so.21.0.p/meson-generated_.._rte_raw_ntb.pmd.c.o
[1802/2405] Linking static target drivers/librte_raw_skeleton.a
[1803/2405] Linking static target drivers/librte_raw_ntb.a
[1804/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_hw_bcmfs_rm_common.c.o
[1805/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_sym.c.o
[1806/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_hw_bcmfs4_rm.c.o
[1807/2405] Generating rte_crypto_bcmfs_mingw with a custom command
[1808/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_hw_bcmfs5_rm.c.o
[1809/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_sym_capabilities.c.o
[1810/2405] Generating rte_crypto_bcmfs_def with a custom command
[1811/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_sym_pmd.c.o
[1812/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_sym_session.c.o
[1813/2405] Generating rte_crypto_caam_jr_def with a custom command
[1814/2405] Compiling C object drivers/libtmp_rte_crypto_bcmfs.a.p/crypto_bcmfs_bcmfs_sym_engine.c.o
[1815/2405] Linking static target drivers/libtmp_rte_crypto_bcmfs.a
[1816/2405] Generating rte_net_octeontx2.sym_chk with a meson_exe.py custom command
[1817/2405] Generating rte_crypto_caam_jr_mingw with a custom command
[1818/2405] Generating rte_raw_octeontx2_dma.sym_chk with a meson_exe.py custom command
[1819/2405] Compiling C object drivers/libtmp_rte_crypto_caam_jr.a.p/crypto_caam_jr_caam_jr_capabilities.c.o
[1820/2405] Generating rte_crypto_dpaa_sec_def with a custom command
[1821/2405] Generating rte_crypto_dpaa_sec_mingw with a custom command
[1822/2405] Generating rte_raw_octeontx2_ep.sym_chk with a meson_exe.py custom command
[1823/2405] Linking target drivers/librte_raw_octeontx2_dma.so.21.0
[1824/2405] Generating rte_crypto_bcmfs.pmd.c with a custom command
[1825/2405] Generating rte_raw_dpaa2_qdma.sym_chk with a meson_exe.py custom command
[1826/2405] Compiling C object drivers/libtmp_rte_crypto_caam_jr.a.p/crypto_caam_jr_caam_jr_hw.c.o
[1827/2405] Compiling C object drivers/librte_crypto_bcmfs.so.21.0.p/meson-generated_.._rte_crypto_bcmfs.pmd.c.o
[1828/2405] Linking target drivers/librte_net_octeontx2.so.21.0
[1829/2405] Compiling C object drivers/librte_crypto_bcmfs.a.p/meson-generated_.._rte_crypto_bcmfs.pmd.c.o
[1830/2405] Linking target drivers/librte_raw_octeontx2_ep.so.21.0
[1831/2405] Generating rte_crypto_dpaa2_sec_def with a custom command
[1832/2405] Linking static target drivers/librte_crypto_bcmfs.a
[1833/2405] Linking target drivers/librte_raw_dpaa2_qdma.so.21.0
[1834/2405] Generating rte_crypto_dpaa2_sec_mingw with a custom command
[1835/2405] Generating rte_raw_ioat.sym_chk with a meson_exe.py custom command
[1836/2405] Compiling C object drivers/libtmp_rte_crypto_caam_jr.a.p/crypto_caam_jr_caam_jr_uio.c.o
[1837/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_logs.c.o
[1838/2405] Generating rte_raw_skeleton.sym_chk with a meson_exe.py custom command
[1839/2405] Compiling C object drivers/libtmp_rte_crypto_dpaa2_sec.a.p/crypto_dpaa2_sec_mc_dpseci.c.o
[1840/2405] Linking target drivers/librte_raw_ioat.so.21.0
[1841/2405] Generating rte_raw_ntb.sym_chk with a meson_exe.py custom command
[1842/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_hal.c.o
[1843/2405] Linking target drivers/librte_raw_skeleton.so.21.0
[1844/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_device.c.o
[1845/2405] Generating rte_crypto_nitrox_mingw with a custom command
[1846/2405] Linking target drivers/librte_raw_ntb.so.21.0
[1847/2405] Generating rte_crypto_nitrox_def with a custom command
[1848/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_sym_capabilities.c.o
[1849/2405] Generating rte_crypto_null_mingw with a custom command
[1850/2405] Generating rte_crypto_null_def with a custom command
[1851/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_qp.c.o
[1852/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_sym_reqmgr.c.o
[1853/2405] Compiling C object drivers/libtmp_rte_crypto_nitrox.a.p/crypto_nitrox_nitrox_sym.c.o
[1854/2405] Compiling C object drivers/libtmp_rte_crypto_null.a.p/crypto_null_null_crypto_pmd_ops.c.o
[1855/2405] Linking static target drivers/libtmp_rte_crypto_nitrox.a
[1856/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx.a.p/crypto_octeontx_otx_cryptodev.c.o
[1857/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx.a.p/crypto_octeontx_otx_cryptodev_capabilities.c.o
[1858/2405] Compiling C object drivers/libtmp_rte_net_virtio.a.p/net_virtio_virtio_rxtx.c.o
[1859/2405] Generating rte_crypto_octeontx_def with a custom command
[1860/2405] Generating rte_crypto_octeontx_mingw with a custom command
[1861/2405] Linking static target drivers/libtmp_rte_net_virtio.a
[1862/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx.a.p/crypto_octeontx_otx_cryptodev_hw_access.c.o
[1863/2405] Generating rte_crypto_nitrox.pmd.c with a custom command
[1864/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx.a.p/crypto_octeontx_otx_cryptodev_mbox.c.o
[1865/2405] Compiling C object drivers/librte_crypto_nitrox.a.p/meson-generated_.._rte_crypto_nitrox.pmd.c.o
[1866/2405] Generating symbol file drivers/librte_net_octeontx2.so.21.0.p/librte_net_octeontx2.so.21.0.symbols
[1867/2405] Compiling C object drivers/librte_crypto_nitrox.so.21.0.p/meson-generated_.._rte_crypto_nitrox.pmd.c.o
[1868/2405] Linking static target drivers/librte_crypto_nitrox.a
[1869/2405] Generating rte_crypto_bcmfs.sym_chk with a meson_exe.py custom command
[1870/2405] Generating rte_net_virtio.pmd.c with a custom command
[1871/2405] Compiling C object drivers/libtmp_rte_crypto_null.a.p/crypto_null_null_crypto_pmd.c.o
[1872/2405] Compiling C object drivers/librte_net_virtio.a.p/meson-generated_.._rte_net_virtio.pmd.c.o
[1873/2405] Linking static target drivers/librte_net_virtio.a
[1874/2405] Compiling C object drivers/librte_net_virtio.so.21.0.p/meson-generated_.._rte_net_virtio.pmd.c.o
[1875/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev.c.o
[1876/2405] Linking target drivers/librte_crypto_bcmfs.so.21.0
[1877/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev_hw_access.c.o
[1878/2405] Linking static target drivers/libtmp_rte_crypto_null.a
[1879/2405] Generating rte_crypto_octeontx2_def with a custom command
[1880/2405] Generating rte_crypto_null.pmd.c with a custom command
[1881/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev_capabilities.c.o
[1882/2405] Compiling C object drivers/librte_crypto_null.a.p/meson-generated_.._rte_crypto_null.pmd.c.o
[1883/2405] Compiling C object drivers/librte_crypto_null.so.21.0.p/meson-generated_.._rte_crypto_null.pmd.c.o
[1884/2405] Linking static target drivers/librte_crypto_null.a
[1885/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev_mbox.c.o
[1886/2405] Compiling C object drivers/libtmp_rte_crypto_caam_jr.a.p/crypto_caam_jr_caam_jr.c.o
[1887/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev_sec.c.o
[1888/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_rte_cryptodev_scheduler.c.o
[1889/2405] Linking static target drivers/libtmp_rte_crypto_caam_jr.a
[1890/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_pmd_ops.c.o
[1891/2405] Generating rte_crypto_scheduler_mingw with a custom command
[1892/2405] Generating rte_crypto_caam_jr.pmd.c with a custom command
[1893/2405] Generating rte_crypto_scheduler_def with a custom command
[1894/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_pkt_size_distr.c.o
[1895/2405] Compiling C object drivers/librte_crypto_caam_jr.a.p/meson-generated_.._rte_crypto_caam_jr.pmd.c.o
[1896/2405] Compiling C object drivers/librte_crypto_caam_jr.so.21.0.p/meson-generated_.._rte_crypto_caam_jr.pmd.c.o
[1897/2405] Linking static target drivers/librte_crypto_caam_jr.a
[1898/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_failover.c.o
[1899/2405] Generating rte_crypto_virtio_mingw with a custom command
[1900/2405] Generating rte_crypto_virtio_def with a custom command
[1901/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_roundrobin.c.o
[1902/2405] Generating rte_crypto_nitrox.sym_chk with a meson_exe.py custom command
[1903/2405] Linking target drivers/librte_crypto_nitrox.so.21.0
[1904/2405] Compiling C object drivers/libtmp_rte_crypto_virtio.a.p/crypto_virtio_virtio_rxtx.c.o
[1905/2405] Compiling C object drivers/libtmp_rte_crypto_virtio.a.p/crypto_virtio_virtqueue.c.o
[1906/2405] Generating rte_compress_octeontx_mingw with a custom command
[1907/2405] Generating rte_compress_octeontx_def with a custom command
[1908/2405] Generating rte_net_virtio.sym_chk with a meson_exe.py custom command
[1909/2405] Compiling C object drivers/libtmp_rte_compress_octeontx.a.p/compress_octeontx_otx_zip.c.o
[1910/2405] Compiling C object drivers/libtmp_rte_crypto_virtio.a.p/crypto_virtio_virtio_cryptodev.c.o
[1911/2405] Generating rte_crypto_null.sym_chk with a meson_exe.py custom command
[1912/2405] Linking static target drivers/libtmp_rte_crypto_virtio.a
[1913/2405] Generating rte_regex_octeontx2_def with a custom command
[1914/2405] Linking target drivers/librte_net_virtio.so.21.0
[1915/2405] Generating rte_crypto_virtio.pmd.c with a custom command
[1916/2405] Linking target drivers/librte_crypto_null.so.21.0
[1917/2405] Compiling C object drivers/libtmp_rte_regex_octeontx2.a.p/regex_octeontx2_otx2_regexdev_compiler.c.o
[1918/2405] Compiling C object drivers/librte_crypto_virtio.a.p/meson-generated_.._rte_crypto_virtio.pmd.c.o
[1919/2405] Compiling C object drivers/librte_crypto_virtio.so.21.0.p/meson-generated_.._rte_crypto_virtio.pmd.c.o
[1920/2405] Compiling C object drivers/libtmp_rte_regex_octeontx2.a.p/regex_octeontx2_otx2_regexdev_hw_access.c.o
[1921/2405] Compiling C object drivers/libtmp_rte_crypto_scheduler.a.p/crypto_scheduler_scheduler_multicore.c.o
[1922/2405] Linking static target drivers/librte_crypto_virtio.a
[1923/2405] Generating rte_event_dlb_def with a custom command
[1924/2405] Linking static target drivers/libtmp_rte_crypto_scheduler.a
[1925/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_rte_pmd_dlb.c.o
[1926/2405] Generating rte_event_dlb_mingw with a custom command
[1927/2405] Compiling C object drivers/libtmp_rte_regex_octeontx2.a.p/regex_octeontx2_otx2_regexdev.c.o
[1928/2405] Compiling C object drivers/libtmp_rte_compress_octeontx.a.p/compress_octeontx_otx_zip_pmd.c.o
[1929/2405] Linking static target drivers/libtmp_rte_regex_octeontx2.a
[1930/2405] Generating rte_crypto_scheduler.pmd.c with a custom command
[1931/2405] Linking static target drivers/libtmp_rte_compress_octeontx.a
[1932/2405] Compiling C object drivers/librte_crypto_scheduler.a.p/meson-generated_.._rte_crypto_scheduler.pmd.c.o
[1933/2405] Generating rte_regex_octeontx2.pmd.c with a custom command
[1934/2405] Compiling C object drivers/librte_crypto_scheduler.so.21.0.p/meson-generated_.._rte_crypto_scheduler.pmd.c.o
[1935/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_dlb2_iface.c.o
[1936/2405] Linking static target drivers/librte_crypto_scheduler.a
[1937/2405] Compiling C object drivers/librte_regex_octeontx2.so.21.0.p/meson-generated_.._rte_regex_octeontx2.pmd.c.o
[1938/2405] Generating rte_crypto_caam_jr.sym_chk with a meson_exe.py custom command
[1939/2405] Compiling C object drivers/librte_regex_octeontx2.a.p/meson-generated_.._rte_regex_octeontx2.pmd.c.o
[1940/2405] Generating rte_compress_octeontx.pmd.c with a custom command
[1941/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_pf_dlb_pf.c.o
[1942/2405] Linking static target drivers/librte_regex_octeontx2.a
[1943/2405] Compiling C object drivers/librte_compress_octeontx.so.21.0.p/meson-generated_.._rte_compress_octeontx.pmd.c.o
[1944/2405] Compiling C object drivers/librte_compress_octeontx.a.p/meson-generated_.._rte_compress_octeontx.pmd.c.o
[1945/2405] Linking target drivers/librte_crypto_caam_jr.so.21.0
[1946/2405] Linking static target drivers/librte_compress_octeontx.a
[1947/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_dlb2_xstats.c.o
[1948/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_pf_dlb2_main.c.o
[1949/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_rte_pmd_dlb2.c.o
[1950/2405] Generating rte_event_dlb2_def with a custom command
[1951/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_pf_dlb2_pf.c.o
[1952/2405] Generating rte_event_dlb2_mingw with a custom command
[1953/2405] Generating rte_event_dpaa_def with a custom command
[1954/2405] Generating rte_event_dpaa_mingw with a custom command
[1955/2405] Generating rte_crypto_virtio.sym_chk with a meson_exe.py custom command
[1956/2405] Linking target drivers/librte_crypto_virtio.so.21.0
[1957/2405] Generating rte_crypto_scheduler.sym_chk with a meson_exe.py custom command
[1958/2405] Compiling C object drivers/libtmp_rte_event_dpaa2.a.p/event_dpaa2_dpaa2_hw_dpcon.c.o
[1959/2405] Generating rte_event_dpaa2_def with a custom command
[1960/2405] Linking target drivers/librte_crypto_scheduler.so.21.0
[1961/2405] Compiling C object drivers/libtmp_rte_event_dpaa.a.p/event_dpaa_dpaa_eventdev.c.o
[1962/2405] Generating rte_regex_octeontx2.sym_chk with a meson_exe.py custom command
[1963/2405] Generating rte_compress_octeontx.sym_chk with a meson_exe.py custom command
[1964/2405] Generating rte_event_dpaa2_mingw with a custom command
[1965/2405] Linking static target drivers/libtmp_rte_event_dpaa.a
[1966/2405] Generating rte_event_dpaa.pmd.c with a custom command
[1967/2405] Linking target drivers/librte_regex_octeontx2.so.21.0
[1968/2405] Compiling C object drivers/libtmp_rte_crypto_dpaa_sec.a.p/crypto_dpaa_sec_dpaa_sec.c.o
[1969/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_dlb2_selftest.c.o
[1970/2405] Compiling C object drivers/librte_event_dpaa.so.21.0.p/meson-generated_.._rte_event_dpaa.pmd.c.o
[1971/2405] Linking target drivers/librte_compress_octeontx.so.21.0
[1972/2405] Compiling C object drivers/librte_event_dpaa.a.p/meson-generated_.._rte_event_dpaa.pmd.c.o
[1973/2405] Linking static target drivers/libtmp_rte_crypto_dpaa_sec.a
[1974/2405] Linking static target drivers/librte_event_dpaa.a
[1975/2405] Generating rte_crypto_dpaa_sec.pmd.c with a custom command
[1976/2405] Compiling C object drivers/librte_crypto_dpaa_sec.a.p/meson-generated_.._rte_crypto_dpaa_sec.pmd.c.o
[1977/2405] Linking static target drivers/librte_crypto_dpaa_sec.a
[1978/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_dlb2.c.o
[1979/2405] Compiling C object drivers/libtmp_rte_crypto_dpaa2_sec.a.p/crypto_dpaa2_sec_dpaa2_sec_dpseci.c.o
[1980/2405] Compiling C object drivers/librte_crypto_dpaa_sec.so.21.0.p/meson-generated_.._rte_crypto_dpaa_sec.pmd.c.o
[1981/2405] Linking static target drivers/libtmp_rte_crypto_dpaa2_sec.a
[1982/2405] Generating rte_crypto_dpaa2_sec.pmd.c with a custom command
[1983/2405] Compiling C object drivers/libtmp_rte_event_dpaa2.a.p/event_dpaa2_dpaa2_eventdev.c.o
[1984/2405] Compiling C object drivers/librte_crypto_dpaa2_sec.so.21.0.p/meson-generated_.._rte_crypto_dpaa2_sec.pmd.c.o
[1985/2405] Compiling C object drivers/libtmp_rte_event_dpaa2.a.p/event_dpaa2_dpaa2_eventdev_selftest.c.o
[1986/2405] Compiling C object drivers/librte_crypto_dpaa2_sec.a.p/meson-generated_.._rte_crypto_dpaa2_sec.pmd.c.o
[1987/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_evdev_adptr.c.o
[1988/2405] Linking static target drivers/libtmp_rte_event_dpaa2.a
[1989/2405] Linking static target drivers/librte_crypto_dpaa2_sec.a
[1990/2405] Generating rte_event_dpaa2.pmd.c with a custom command
[1991/2405] Compiling C object drivers/librte_event_dpaa2.a.p/meson-generated_.._rte_event_dpaa2.pmd.c.o
[1992/2405] Linking static target drivers/librte_event_dpaa2.a
[1993/2405] Compiling C object drivers/libtmp_rte_event_dlb.a.p/event_dlb_pf_base_dlb_resource.c.o
[1994/2405] Linking static target drivers/libtmp_rte_event_dlb.a
[1995/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_evdev_crypto_adptr.c.o
[1996/2405] Compiling C object drivers/libtmp_rte_event_dlb2.a.p/event_dlb2_pf_base_dlb2_resource.c.o
[1997/2405] Compiling C object drivers/librte_event_dpaa2.so.21.0.p/meson-generated_.._rte_event_dpaa2.pmd.c.o
[1998/2405] Linking static target drivers/libtmp_rte_event_dlb2.a
[1999/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_evdev_irq.c.o
[2000/2405] Generating rte_event_dlb.pmd.c with a custom command
[2001/2405] Generating rte_event_dpaa.sym_chk with a meson_exe.py custom command
[2002/2405] Compiling C object drivers/librte_event_dlb.a.p/meson-generated_.._rte_event_dlb.pmd.c.o
[2003/2405] Generating rte_event_dlb2.pmd.c with a custom command
[2004/2405] Linking static target drivers/librte_event_dlb.a
[2005/2405] Generating rte_crypto_dpaa_sec.sym_chk with a meson_exe.py custom command
[2006/2405] Compiling C object drivers/librte_event_dlb2.a.p/meson-generated_.._rte_event_dlb2.pmd.c.o
[2007/2405] Compiling C object drivers/librte_event_dlb.so.21.0.p/meson-generated_.._rte_event_dlb.pmd.c.o
[2008/2405] Linking static target drivers/librte_event_dlb2.a
[2009/2405] Compiling C object drivers/librte_event_dlb2.so.21.0.p/meson-generated_.._rte_event_dlb2.pmd.c.o
[2010/2405] Linking target drivers/librte_crypto_dpaa_sec.so.21.0
[2011/2405] Generating rte_event_octeontx2_mingw with a custom command
[2012/2405] Generating rte_event_octeontx2_def with a custom command
[2013/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_tim_evdev.c.o
[2014/2405] Generating rte_event_dpaa2.sym_chk with a meson_exe.py custom command
[2015/2405] Compiling C object drivers/libtmp_rte_event_opdl.a.p/event_opdl_opdl_evdev.c.o
[2016/2405] Generating rte_crypto_dpaa2_sec.sym_chk with a meson_exe.py custom command
[2017/2405] Compiling C object drivers/libtmp_rte_event_opdl.a.p/event_opdl_opdl_evdev_xstats.c.o
[2018/2405] Linking target drivers/librte_crypto_dpaa2_sec.so.21.0
[2019/2405] Generating rte_event_dlb.sym_chk with a meson_exe.py custom command
[2020/2405] Linking target drivers/librte_event_dlb.so.21.0
[2021/2405] Generating rte_event_opdl_mingw with a custom command
[2022/2405] Generating rte_event_opdl_def with a custom command
[2023/2405] Generating symbol file drivers/librte_crypto_dpaa_sec.so.21.0.p/librte_crypto_dpaa_sec.so.21.0.symbols
[2024/2405] Compiling C object drivers/libtmp_rte_event_opdl.a.p/event_opdl_opdl_evdev_init.c.o
[2025/2405] Generating rte_event_skeleton_def with a custom command
[2026/2405] Linking target drivers/librte_event_dpaa.so.21.0
[2027/2405] Generating rte_event_skeleton_mingw with a custom command
[2028/2405] Generating rte_event_dlb2.sym_chk with a meson_exe.py custom command
[2029/2405] Linking target drivers/librte_event_dlb2.so.21.0
[2030/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_tim_worker.c.o
[2031/2405] Compiling C object drivers/libtmp_rte_event_opdl.a.p/event_opdl_opdl_test.c.o
[2032/2405] Compiling C object drivers/libtmp_rte_event_skeleton.a.p/event_skeleton_skeleton_eventdev.c.o
[2033/2405] Linking static target drivers/libtmp_rte_event_skeleton.a
[2034/2405] Generating rte_event_skeleton.pmd.c with a custom command
[2035/2405] Compiling C object drivers/librte_event_skeleton.a.p/meson-generated_.._rte_event_skeleton.pmd.c.o
[2036/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx.a.p/crypto_octeontx_otx_cryptodev_ops.c.o
[2037/2405] Linking static target drivers/libtmp_rte_crypto_octeontx.a
[2038/2405] Linking static target drivers/librte_event_skeleton.a
[2039/2405] Generating symbol file drivers/librte_crypto_dpaa2_sec.so.21.0.p/librte_crypto_dpaa2_sec.so.21.0.symbols
[2040/2405] Compiling C object drivers/libtmp_rte_crypto_octeontx2.a.p/crypto_octeontx2_otx2_cryptodev_ops.c.o
[2041/2405] Generating rte_crypto_octeontx.pmd.c with a custom command
[2042/2405] Compiling C object drivers/libtmp_rte_event_sw.a.p/event_sw_sw_evdev_xstats.c.o
[2043/2405] Compiling C object drivers/librte_crypto_octeontx.a.p/meson-generated_.._rte_crypto_octeontx.pmd.c.o
[2044/2405] Linking static target drivers/libtmp_rte_crypto_octeontx2.a
[2045/2405] Compiling C object drivers/librte_crypto_octeontx.so.21.0.p/meson-generated_.._rte_crypto_octeontx.pmd.c.o
[2046/2405] Linking static target drivers/librte_crypto_octeontx.a
[2047/2405] Linking target drivers/librte_event_dpaa2.so.21.0
[2048/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_evdev_selftest.c.o
[2049/2405] Generating rte_crypto_octeontx2.pmd.c with a custom command
[2050/2405] Compiling C object drivers/librte_event_skeleton.so.21.0.p/meson-generated_.._rte_event_skeleton.pmd.c.o
[2051/2405] Compiling C object drivers/libtmp_rte_event_sw.a.p/event_sw_sw_evdev_worker.c.o
[2052/2405] Compiling C object drivers/librte_crypto_octeontx2.so.21.0.p/meson-generated_.._rte_crypto_octeontx2.pmd.c.o
[2053/2405] Generating rte_event_sw_def with a custom command
[2054/2405] Generating rte_event_sw_mingw with a custom command
[2055/2405] Compiling C object drivers/librte_crypto_octeontx2.a.p/meson-generated_.._rte_crypto_octeontx2.pmd.c.o
[2056/2405] Generating rte_event_dsw_def with a custom command
[2057/2405] Linking static target drivers/librte_crypto_octeontx2.a
[2058/2405] Compiling C object drivers/libtmp_rte_event_sw.a.p/event_sw_sw_evdev.c.o
[2059/2405] Generating rte_event_dsw_mingw with a custom command
[2060/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_evdev.c.o
[2061/2405] Compiling C object drivers/libtmp_rte_event_dsw.a.p/event_dsw_dsw_xstats.c.o
[2062/2405] Compiling C object drivers/libtmp_rte_event_opdl.a.p/event_opdl_opdl_ring.c.o
[2063/2405] Compiling C object drivers/libtmp_rte_event_dsw.a.p/event_dsw_dsw_evdev.c.o
[2064/2405] Linking static target drivers/libtmp_rte_event_opdl.a
[2065/2405] Generating rte_event_opdl.pmd.c with a custom command
[2066/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_ssovf_probe.c.o
[2067/2405] Compiling C object drivers/librte_event_opdl.a.p/meson-generated_.._rte_event_opdl.pmd.c.o
[2068/2405] Compiling C object drivers/librte_event_opdl.so.21.0.p/meson-generated_.._rte_event_opdl.pmd.c.o
[2069/2405] Generating rte_event_skeleton.sym_chk with a meson_exe.py custom command
[2070/2405] Linking static target drivers/librte_event_opdl.a
[2071/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_ssovf_evdev.c.o
[2072/2405] Linking target drivers/librte_event_skeleton.so.21.0
[2073/2405] Generating rte_event_octeontx_mingw with a custom command
[2074/2405] Generating rte_event_octeontx_def with a custom command
[2075/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_timvf_worker.c.o
[2076/2405] Generating rte_baseband_null_mingw with a custom command
[2077/2405] Generating rte_crypto_octeontx.sym_chk with a meson_exe.py custom command
[2078/2405] Generating rte_baseband_null_def with a custom command
[2079/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_timvf_probe.c.o
[2080/2405] Generating rte_baseband_turbo_sw_def with a custom command
[2081/2405] Linking target drivers/librte_crypto_octeontx.so.21.0
[2082/2405] Compiling C object drivers/libtmp_rte_event_sw.a.p/event_sw_sw_evdev_scheduler.c.o
[2083/2405] Generating rte_baseband_turbo_sw_mingw with a custom command
[2084/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_timvf_evdev.c.o
[2085/2405] Generating rte_baseband_fpga_lte_fec_def with a custom command
[2086/2405] Generating rte_crypto_octeontx2.sym_chk with a meson_exe.py custom command
[2087/2405] Generating rte_baseband_fpga_lte_fec_mingw with a custom command
[2088/2405] Generating rte_baseband_fpga_5gnr_fec_def with a custom command
[2089/2405] Generating rte_baseband_fpga_5gnr_fec_mingw with a custom command
[2090/2405] Linking target drivers/librte_crypto_octeontx2.so.21.0
[2091/2405] Generating rte_baseband_acc100_def with a custom command
[2092/2405] Generating rte_baseband_acc100_mingw with a custom command
[2093/2405] Compiling C object drivers/libtmp_rte_baseband_null.a.p/baseband_null_bbdev_null.c.o
[2094/2405] Compiling C object drivers/libtmp_rte_event_dsw.a.p/event_dsw_dsw_event.c.o
[2095/2405] Linking static target drivers/libtmp_rte_baseband_null.a
[2096/2405] Generating rte_baseband_null.pmd.c with a custom command
[2097/2405] Linking static target drivers/libtmp_rte_event_dsw.a
[2098/2405] Compiling C object drivers/librte_baseband_null.a.p/meson-generated_.._rte_baseband_null.pmd.c.o
[2099/2405] Linking static target drivers/librte_baseband_null.a
[2100/2405] Generating rte_event_dsw.pmd.c with a custom command
[2101/2405] Compiling C object drivers/libtmp_rte_baseband_fpga_lte_fec.a.p/baseband_fpga_lte_fec_fpga_lte_fec.c.o
[2102/2405] Compiling C object drivers/libtmp_rte_event_sw.a.p/event_sw_sw_evdev_selftest.c.o
[2103/2405] Generating rte_event_opdl.sym_chk with a meson_exe.py custom command
[2104/2405] Compiling C object drivers/librte_event_dsw.a.p/meson-generated_.._rte_event_dsw.pmd.c.o
[2105/2405] Compiling C object drivers/librte_event_dsw.so.21.0.p/meson-generated_.._rte_event_dsw.pmd.c.o
[2106/2405] Linking static target drivers/libtmp_rte_event_sw.a
[2107/2405] Compiling C object drivers/libtmp_rte_baseband_fpga_5gnr_fec.a.p/baseband_fpga_5gnr_fec_rte_fpga_5gnr_fec.c.o
[2108/2405] Linking static target drivers/librte_event_dsw.a
[2109/2405] Compiling C object drivers/librte_baseband_null.so.21.0.p/meson-generated_.._rte_baseband_null.pmd.c.o
[2110/2405] Linking static target drivers/libtmp_rte_baseband_fpga_lte_fec.a
[2111/2405] Linking target drivers/librte_event_opdl.so.21.0
[2112/2405] Linking static target drivers/libtmp_rte_baseband_fpga_5gnr_fec.a
[2113/2405] Generating rte_event_sw.pmd.c with a custom command
[2114/2405] Generating rte_baseband_fpga_lte_fec.pmd.c with a custom command
[2115/2405] Generating rte_baseband_fpga_5gnr_fec.pmd.c with a custom command
[2116/2405] Compiling C object drivers/librte_event_sw.a.p/meson-generated_.._rte_event_sw.pmd.c.o
[2117/2405] Compiling C object drivers/librte_event_sw.so.21.0.p/meson-generated_.._rte_event_sw.pmd.c.o
[2118/2405] Compiling C object drivers/librte_baseband_fpga_lte_fec.so.21.0.p/meson-generated_.._rte_baseband_fpga_lte_fec.pmd.c.o
[2119/2405] Compiling C object drivers/librte_baseband_fpga_lte_fec.a.p/meson-generated_.._rte_baseband_fpga_lte_fec.pmd.c.o
[2120/2405] Linking static target drivers/librte_event_sw.a
[2121/2405] Linking static target drivers/librte_baseband_fpga_lte_fec.a
[2122/2405] Compiling C object drivers/librte_baseband_fpga_5gnr_fec.a.p/meson-generated_.._rte_baseband_fpga_5gnr_fec.pmd.c.o
[2123/2405] Linking static target drivers/librte_baseband_fpga_5gnr_fec.a
[2124/2405] Compiling C object app/dpdk-pdump.p/pdump_main.c.o
[2125/2405] Compiling C object drivers/libtmp_rte_baseband_turbo_sw.a.p/baseband_turbo_sw_bbdev_turbo_software.c.o
[2126/2405] Linking static target drivers/libtmp_rte_baseband_turbo_sw.a
[2127/2405] Generating rte_baseband_turbo_sw.pmd.c with a custom command
[2128/2405] Compiling C object drivers/librte_baseband_fpga_5gnr_fec.so.21.0.p/meson-generated_.._rte_baseband_fpga_5gnr_fec.pmd.c.o
[2129/2405] Compiling C object drivers/librte_baseband_turbo_sw.a.p/meson-generated_.._rte_baseband_turbo_sw.pmd.c.o
[2130/2405] Generating symbol file drivers/librte_crypto_octeontx2.so.21.0.p/librte_crypto_octeontx2.so.21.0.symbols
[2131/2405] Compiling C object drivers/librte_baseband_turbo_sw.so.21.0.p/meson-generated_.._rte_baseband_turbo_sw.pmd.c.o
[2132/2405] Linking static target drivers/librte_baseband_turbo_sw.a
[2133/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_ssovf_evdev_selftest.c.o
[2134/2405] Compiling C object app/dpdk-proc-info.p/proc-info_main.c.o
[2135/2405] Compiling C object app/dpdk-test-cmdline.p/test-cmdline_cmdline_test.c.o
[2136/2405] Generating rte_baseband_null.sym_chk with a meson_exe.py custom command
[2137/2405] Compiling C object drivers/libtmp_rte_event_octeontx.a.p/event_octeontx_ssovf_worker.c.o
[2138/2405] Linking target drivers/librte_baseband_null.so.21.0
[2139/2405] Linking static target drivers/libtmp_rte_event_octeontx.a
[2140/2405] Compiling C object app/dpdk-test-acl.p/test-acl_main.c.o
[2141/2405] Generating rte_event_dsw.sym_chk with a meson_exe.py custom command
[2142/2405] Generating rte_event_octeontx.pmd.c with a custom command
[2143/2405] Compiling C object drivers/librte_event_octeontx.a.p/meson-generated_.._rte_event_octeontx.pmd.c.o
[2144/2405] Generating rte_event_sw.sym_chk with a meson_exe.py custom command
[2145/2405] Compiling C object drivers/librte_event_octeontx.so.21.0.p/meson-generated_.._rte_event_octeontx.pmd.c.o
[2146/2405] Generating rte_baseband_fpga_5gnr_fec.sym_chk with a meson_exe.py custom command
[2147/2405] Linking static target drivers/librte_event_octeontx.a
[2148/2405] Linking target drivers/librte_event_sw.so.21.0
[2149/2405] Generating rte_baseband_fpga_lte_fec.sym_chk with a meson_exe.py custom command
[2150/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_common.c.o
[2151/2405] Linking target drivers/librte_event_dsw.so.21.0
[2152/2405] Linking target drivers/librte_baseband_fpga_5gnr_fec.so.21.0
[2153/2405] Compiling C object app/dpdk-test-bbdev.p/test-bbdev_test_bbdev.c.o
[2154/2405] Linking target drivers/librte_baseband_fpga_lte_fec.so.21.0
[2155/2405] Generating rte_baseband_turbo_sw.sym_chk with a meson_exe.py custom command
[2156/2405] Compiling C object app/dpdk-test-bbdev.p/test-bbdev_test_bbdev_vector.c.o
[2157/2405] Compiling C object app/dpdk-test-cmdline.p/test-cmdline_commands.c.o
[2158/2405] Compiling C object drivers/libtmp_rte_baseband_acc100.a.p/baseband_acc100_rte_acc100_pmd.c.o
[2159/2405] Linking static target drivers/libtmp_rte_baseband_acc100.a
[2160/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_latency.c.o
[2161/2405] Linking target drivers/librte_baseband_turbo_sw.so.21.0
[2162/2405] Generating rte_baseband_acc100.pmd.c with a custom command
[2163/2405] Compiling C object drivers/librte_baseband_acc100.a.p/meson-generated_.._rte_baseband_acc100.pmd.c.o
[2164/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_config.c.o
[2165/2405] Linking static target drivers/librte_baseband_acc100.a
[2166/2405] Compiling C object drivers/librte_baseband_acc100.so.21.0.p/meson-generated_.._rte_baseband_acc100.pmd.c.o
[2167/2405] Compiling C object app/dpdk-test-bbdev.p/test-bbdev_main.c.o
[2168/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_pmd_cyclecount.c.o
[2169/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_options_parsing.c.o
[2170/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_comp_perf_test_throughput.c.o
[2171/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_ops.c.o
[2172/2405] Compiling C object app/dpdk-test-flow-perf.p/test-flow-perf_main.c.o
[2173/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_main.c.o
[2174/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_main.c.o
[2175/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_pipeline_acl.c.o
[2176/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_comp_perf_options_parse.c.o
[2177/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_main.c.o
[2178/2405] Generating rte_event_octeontx.sym_chk with a meson_exe.py custom command
[2179/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_init.c.o
[2180/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_comp_perf_test_cyclecount.c.o
[2181/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_pipeline_lpm.c.o
[2182/2405] Linking target drivers/librte_event_octeontx.so.21.0
[2183/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_comp_perf_test_verify.c.o
[2184/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_evt_test.c.o
[2185/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_vectors.c.o
[2186/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_throughput.c.o
[2187/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_parser.c.o
[2188/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_vector_parsing.c.o
[2189/2405] Compiling C object app/dpdk-test-crypto-perf.p/test-crypto-perf_cperf_test_verify.c.o
[2190/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_evt_main.c.o
[2191/2405] Generating rte_baseband_acc100.sym_chk with a meson_exe.py custom command
[2192/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_evt_options.c.o
[2193/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_order_common.c.o
[2194/2405] Linking target drivers/librte_baseband_acc100.so.21.0
[2195/2405] Compiling C object app/dpdk-test-compress-perf.p/test-compress-perf_comp_perf_test_common.c.o
[2196/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_order_atq.c.o
[2197/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_order_queue.c.o
[2198/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_pipeline_common.c.o
[2199/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_pipeline_atq.c.o
[2200/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_perf_atq.c.o
[2201/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_perf_queue.c.o
[2202/2405] Compiling C object app/dpdk-test-flow-perf.p/test-flow-perf_items_gen.c.o
[2203/2405] Compiling C object app/dpdk-test-flow-perf.p/test-flow-perf_actions_gen.c.o
[2204/2405] Compiling C object app/dpdk-test-flow-perf.p/test-flow-perf_flow_gen.c.o
[2205/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_pipeline_queue.c.o
[2206/2405] Compiling C object app/dpdk-test-eventdev.p/test-eventdev_test_perf_common.c.o
[2207/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_pipeline_lpm_ipv6.c.o
[2208/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_pipeline_stub.c.o
[2209/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_pipeline_hash.c.o
[2210/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_cmdline_mtr.c.o
[2211/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_5tswap.c.o
[2212/2405] Compiling C object app/dpdk-test-fib.p/test-fib_main.c.o
[2213/2405] Compiling C object app/dpdk-test-pipeline.p/test-pipeline_runtime.c.o
[2214/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_cmdline_tm.c.o
[2215/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_flowgen.c.o
[2216/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_macfwd.c.o
[2217/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_iofwd.c.o
[2218/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_ieee1588fwd.c.o
[2219/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_macswap.c.o
[2220/2405] Compiling C object app/dpdk-test-bbdev.p/test-bbdev_test_bbdev_perf.c.o
[2221/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_icmpecho.c.o
[2222/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_cmdline_flow.c.o
[2223/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_rxonly.c.o
[2224/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_bpf_cmd.c.o
[2225/2405] Compiling C object app/test/dpdk-test.p/test_alarm.c.o
[2226/2405] Compiling C object app/dpdk-test-sad.p/test-sad_main.c.o
[2227/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_util.c.o
[2228/2405] Compiling C object app/test/dpdk-test.p/test.c.o
[2229/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_parameters.c.o
[2230/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_txonly.c.o
[2231/2405] Compiling C object app/test/dpdk-test.p/test_byteorder.c.o
[2232/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_csumonly.c.o
[2233/2405] Compiling C object app/test/dpdk-test.p/commands.c.o
[2234/2405] Compiling C object app/test/dpdk-test.p/test_cmdline.c.o
[2235/2405] Compiling C object app/dpdk-test-regex.p/test-regex_main.c.o
[2236/2405] Compiling C object app/test/dpdk-test.p/test_atomic.c.o
[2237/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_noisy_vnf.c.o
[2238/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_config.c.o
[2239/2405] Compiling C object app/test/dpdk-test.p/test_bpf.c.o
[2240/2405] Compiling C object app/test/dpdk-test.p/test_barrier.c.o
[2241/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_lib.c.o
[2242/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_portlist.c.o
[2243/2405] Compiling C object app/test/dpdk-test.p/test_bitops.c.o
[2244/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_num.c.o
[2245/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_ipaddr.c.o
[2246/2405] Compiling C object app/test/dpdk-test.p/packet_burst_generator.c.o
[2247/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_cirbuf.c.o
[2248/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_etheraddr.c.o
[2249/2405] Compiling C object app/test/dpdk-test.p/test_cmdline_string.c.o
[2250/2405] Compiling C object app/test/dpdk-test.p/test_cpuflags.c.o
[2251/2405] Compiling C object app/test/dpdk-test.p/test_cycles.c.o
[2252/2405] Compiling C object app/test/dpdk-test.p/test_common.c.o
[2253/2405] Compiling C object app/test/dpdk-test.p/test_crc.c.o
[2254/2405] Compiling C object app/test/dpdk-test.p/test_debug.c.o
[2255/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_cmdline.c.o
[2256/2405] Compiling C object app/test/dpdk-test.p/test_acl.c.o
[2257/2405] Compiling C object app/test/dpdk-test.p/test_eal_fs.c.o
[2258/2405] Compiling C object app/test/dpdk-test.p/test_errno.c.o
[2259/2405] Compiling C object app/test/dpdk-test.p/test_distributor_perf.c.o
[2260/2405] Compiling C object app/dpdk-testpmd.p/test-pmd_testpmd.c.o
[2261/2405] Compiling C object app/test/dpdk-test.p/test_efd_perf.c.o
[2262/2405] Compiling C object app/test/dpdk-test.p/test_efd.c.o
[2263/2405] Compiling C object app/test/dpdk-test.p/test_cryptodev_security_pdcp.c.o
[2264/2405] Compiling C object app/test/dpdk-test.p/test_ethdev_link.c.o
[2265/2405] Compiling C object app/test/dpdk-test.p/test_cryptodev_asym.c.o
[2266/2405] Compiling C object app/test/dpdk-test.p/test_distributor.c.o
[2267/2405] Compiling C object app/test/dpdk-test.p/test_event_eth_rx_adapter.c.o
[2268/2405] Compiling C object app/test/dpdk-test.p/test_external_mem.c.o
[2269/2405] Compiling C object app/test/dpdk-test.p/test_fbarray.c.o
[2270/2405] Compiling C object app/test/dpdk-test.p/test_event_crypto_adapter.c.o
[2271/2405] Compiling C object app/test/dpdk-test.p/test_eventdev.c.o
[2272/2405] Compiling C object app/test/dpdk-test.p/test_fib.c.o
[2273/2405] Compiling C object app/test/dpdk-test.p/test_cryptodev_blockcipher.c.o
[2274/2405] Compiling C object app/test/dpdk-test.p/test_fib_perf.c.o
[2275/2405] Compiling C object app/test/dpdk-test.p/test_fib6.c.o
[2276/2405] Compiling C object app/test/dpdk-test.p/test_fib6_perf.c.o
[2277/2405] Compiling C object app/test/dpdk-test.p/test_func_reentrancy.c.o
[2278/2405] Compiling C object app/test/dpdk-test.p/test_flow_classify.c.o
[2279/2405] Compiling C object app/test/dpdk-test.p/test_event_ring.c.o
[2280/2405] Compiling C object app/test/dpdk-test.p/test_hash_functions.c.o
[2281/2405] Compiling C object app/test/dpdk-test.p/test_hash_multiwriter.c.o
[2282/2405] Compiling C object app/test/dpdk-test.p/test_graph.c.o
[2283/2405] Compiling C object app/test/dpdk-test.p/test_interrupts.c.o
[2284/2405] Compiling C object app/test/dpdk-test.p/test_hash_readwrite.c.o
[2285/2405] Compiling C object app/test/dpdk-test.p/test_eal_flags.c.o
[2286/2405] Compiling C object app/test/dpdk-test.p/test_graph_perf.c.o
[2287/2405] Compiling C object app/test/dpdk-test.p/test_kvargs.c.o
[2288/2405] Compiling C object app/test/dpdk-test.p/test_ipfrag.c.o
[2289/2405] Compiling C object app/test/dpdk-test.p/test_hash_perf.c.o
[2290/2405] Compiling C object app/test/dpdk-test.p/test_ipsec_sad.c.o
[2291/2405] Compiling C object app/test/dpdk-test.p/test_lcores.c.o
[2292/2405] Compiling C object app/test/dpdk-test.p/test_hash_readwrite_lf_perf.c.o
[2293/2405] Compiling C object app/test/dpdk-test.p/test_hash.c.o
[2294/2405] Compiling C object app/test/dpdk-test.p/test_logs.c.o
[2295/2405] Compiling C object app/test/dpdk-test.p/test_lpm6_perf.c.o
[2296/2405] Compiling C object app/test/dpdk-test.p/test_event_timer_adapter.c.o
[2297/2405] Compiling C object app/test/dpdk-test.p/test_ipsec_perf.c.o
[2298/2405] Compiling C object app/test/dpdk-test.p/test_kni.c.o
[2299/2405] Compiling C object app/test/dpdk-test.p/test_malloc.c.o
[2300/2405] Compiling C object app/test/dpdk-test.p/test_memory.c.o
[2301/2405] Compiling C object app/test/dpdk-test.p/test_memcpy.c.o
[2302/2405] Compiling C object app/test/dpdk-test.p/test_lpm_perf.c.o
[2303/2405] Compiling C object app/test/dpdk-test.p/test_lpm6.c.o
[2304/2405] Compiling C object app/test/dpdk-test.p/test_member.c.o
[2305/2405] Compiling C object app/test/dpdk-test.p/test_lpm.c.o
[2306/2405] Compiling C object app/test/dpdk-test.p/test_member_perf.c.o
[2307/2405] Compiling C object app/test/dpdk-test.p/test_metrics.c.o
[2308/2405] Compiling C object app/test/dpdk-test.p/test_memzone.c.o
[2309/2405] Compiling C object app/test/dpdk-test.p/test_per_lcore.c.o
[2310/2405] Compiling C object app/test/dpdk-test.p/test_mempool.c.o
[2311/2405] Compiling C object app/test/dpdk-test.p/test_mempool_perf.c.o
[2312/2405] Compiling C object app/test/dpdk-test.p/test_mcslock.c.o
[2313/2405] Compiling C object app/test/dpdk-test.p/test_power.c.o
[2314/2405] Compiling C object app/test/dpdk-test.p/test_rand_perf.c.o
[2315/2405] Compiling C object app/test/dpdk-test.p/test_prefetch.c.o
[2316/2405] Compiling C object app/test/dpdk-test.p/test_ipsec.c.o
[2317/2405] Compiling C object app/test/dpdk-test.p/test_mp_secondary.c.o
[2318/2405] Compiling C object app/test/dpdk-test.p/test_power_cpufreq.c.o
[2319/2405] Compiling C object app/test/dpdk-test.p/test_power_kvm_vm.c.o
[2320/2405] Compiling C object app/test/dpdk-test.p/test_meter.c.o
[2321/2405] Compiling C object app/test/dpdk-test.p/test_reciprocal_division.c.o
[2322/2405] Compiling C object app/test/dpdk-test.p/test_rawdev.c.o
[2323/2405] Compiling C object app/test/dpdk-test.p/test_reciprocal_division_perf.c.o
[2324/2405] Compiling C object app/test/dpdk-test.p/test_rib6.c.o
[2325/2405] Compiling C object app/test/dpdk-test.p/test_rcu_qsbr_perf.c.o
[2326/2405] Compiling C object app/test/dpdk-test.p/test_rib.c.o
[2327/2405] Compiling C object app/test/dpdk-test.p/test_pmd_perf.c.o
[2328/2405] Compiling C object app/test/dpdk-test.p/test_red.c.o
[2329/2405] Compiling C object app/test/dpdk-test.p/test_ring_mpmc_stress.c.o
[2330/2405] Compiling C object app/test/dpdk-test.p/test_reorder.c.o
[2331/2405] Compiling C object app/test/dpdk-test.p/test_ring_hts_stress.c.o
[2332/2405] Compiling C object app/test/dpdk-test.p/test_ring_mt_peek_stress.c.o
[2333/2405] Compiling C object app/test/dpdk-test.p/test_ring_mt_peek_stress_zc.c.o
[2334/2405] Compiling C object app/test/dpdk-test.p/test_rcu_qsbr.c.o
[2335/2405] Compiling C object app/test/dpdk-test.p/test_ring_rts_stress.c.o
[2336/2405] Compiling C object app/test/dpdk-test.p/test_ring_stress.c.o
[2337/2405] Compiling C object app/test/dpdk-test.p/test_ring_st_peek_stress_zc.c.o
[2338/2405] Compiling C object app/test/dpdk-test.p/test_sched.c.o
[2339/2405] Compiling C object app/test/dpdk-test.p/test_ring_st_peek_stress.c.o
[2340/2405] Compiling C object app/test/dpdk-test.p/test_rwlock.c.o
[2341/2405] Compiling C object app/test/dpdk-test.p/test_string_fns.c.o
[2342/2405] Compiling C object app/test/dpdk-test.p/test_spinlock.c.o
[2343/2405] Compiling C object app/test/dpdk-test.p/test_service_cores.c.o
[2344/2405] Compiling C object app/test/dpdk-test.p/test_mbuf.c.o
[2345/2405] Compiling C object app/test/dpdk-test.p/test_stack.c.o
[2346/2405] Compiling C object app/test/dpdk-test.p/test_table.c.o
[2347/2405] Compiling C object app/test/dpdk-test.p/test_stack_perf.c.o
[2348/2405] Compiling C object app/test/dpdk-test.p/test_tailq.c.o
[2349/2405] Compiling C object app/test/dpdk-test.p/test_security.c.o
[2350/2405] Compiling C object app/test/dpdk-test.p/test_thash.c.o
[2351/2405] Compiling C object app/test/dpdk-test.p/test_timer_racecond.c.o
[2352/2405] Compiling C object app/test/dpdk-test.p/test_timer_perf.c.o
[2353/2405] Compiling C object app/test/dpdk-test.p/test_table_acl.c.o
[2354/2405] Compiling C object app/test/dpdk-test.p/test_timer.c.o
[2355/2405] Compiling C object app/test/dpdk-test.p/test_table_pipeline.c.o
[2356/2405] Compiling C object app/test/dpdk-test.p/test_trace_register.c.o
[2357/2405] Compiling C object app/test/dpdk-test.p/test_ticketlock.c.o
[2358/2405] Compiling C object app/test/dpdk-test.p/test_cryptodev.c.o
[2359/2405] Compiling C object app/test/dpdk-test.p/test_table_ports.c.o
[2360/2405] Compiling C object app/test/dpdk-test.p/test_trace.c.o
[2361/2405] Compiling C object app/test/dpdk-test.p/test_timer_secondary.c.o
[2362/2405] Compiling C object app/test/dpdk-test.p/test_version.c.o
[2363/2405] Compiling C object app/test/dpdk-test.p/test_telemetry_json.c.o
[2364/2405] Compiling C object app/test/dpdk-test.p/test_table_tables.c.o
[2365/2405] Compiling C object app/test/dpdk-test.p/test_telemetry_data.c.o
[2366/2405] Compiling C object app/test/dpdk-test.p/test_pmd_ring.c.o
[2367/2405] Compiling C object app/test/dpdk-test.p/test_link_bonding_rssconf.c.o
[2368/2405] Compiling C object app/test/dpdk-test.p/test_event_eth_tx_adapter.c.o
[2369/2405] Compiling C object app/test/dpdk-test.p/test_bitratestats.c.o
[2370/2405] Compiling C object app/test/dpdk-test.p/test_latencystats.c.o
[2371/2405] Compiling C object app/test/dpdk-test.p/test_pmd_ring_perf.c.o
[2372/2405] Compiling C object app/test/dpdk-test.p/sample_packet_forward.c.o
[2373/2405] Compiling C object app/test/dpdk-test.p/test_pdump.c.o
[2374/2405] Compiling C object app/test/dpdk-test.p/virtual_pmd.c.o
[2375/2405] Compiling C object app/test/dpdk-test.p/test_memcpy_perf.c.o
[2376/2405] Compiling C object app/test/dpdk-test.p/test_table_combined.c.o
[2377/2405] Compiling C object app/test/dpdk-test.p/test_link_bonding.c.o
[2378/2405] Compiling C object app/test/dpdk-test.p/test_link_bonding_mode4.c.o
[2379/2405] Compiling C object app/test/dpdk-test.p/test_trace_perf.c.o
[2380/2405] Compiling C object app/test/dpdk-test.p/test_ring.c.o
[2381/2405] Compiling C object app/test/dpdk-test.p/test_ring_perf.c.o
[2382/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_worker.c.o
[2383/2405] Compiling C object drivers/libtmp_rte_event_octeontx2.a.p/event_octeontx2_otx2_worker_dual.c.o
[2384/2405] Linking static target drivers/libtmp_rte_event_octeontx2.a
[2385/2405] Generating rte_event_octeontx2.pmd.c with a custom command
[2386/2405] Compiling C object drivers/librte_event_octeontx2.a.p/meson-generated_.._rte_event_octeontx2.pmd.c.o
[2387/2405] Compiling C object drivers/librte_event_octeontx2.so.21.0.p/meson-generated_.._rte_event_octeontx2.pmd.c.o
[2388/2405] Linking static target drivers/librte_event_octeontx2.a
[2389/2405] Generating rte_event_octeontx2.sym_chk with a meson_exe.py custom command
[2390/2405] Linking target drivers/librte_event_octeontx2.so.21.0
[2391/2405] Linking target app/dpdk-proc-info
[2392/2405] Linking target app/dpdk-test-bbdev
[2393/2405] Linking target app/dpdk-test-fib
[2394/2405] Linking target app/dpdk-test-eventdev
[2395/2405] Linking target app/dpdk-test-flow-perf
[2396/2405] Linking target app/dpdk-pdump
[2397/2405] Linking target app/dpdk-test-regex
[2398/2405] Linking target app/dpdk-test-acl
[2399/2405] Linking target app/dpdk-test-compress-perf
[2400/2405] Linking target app/dpdk-test-crypto-perf
[2401/2405] Linking target app/dpdk-test-pipeline
[2402/2405] Linking target app/dpdk-testpmd
[2403/2405] Linking target app/dpdk-test-cmdline
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
Determining fastest mirrors
 * base: ftp.csuc.cat
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
Resolving Dependencies
--> Running transaction check
---> Package numactl-devel.x86_64 0:2.0.12-5.el7 will be installed
--> Processing Dependency: numactl-libs = 2.0.12-5.el7 for package: numactl-devel-2.0.12-5.el7.x86_64
--> Processing Dependency: libnuma.so.1()(64bit) for package: numactl-devel-2.0.12-5.el7.x86_64
---> Package python3.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: python3-libs(x86-64) = 3.6.8-18.el7 for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-setuptools for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-pip for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: libpython3.6m.so.1.0()(64bit) for package: python3-3.6.8-18.el7.x86_64
--> Running transaction check
---> Package numactl-libs.x86_64 0:2.0.12-5.el7 will be installed
---> Package python3-libs.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: libtirpc.so.1()(64bit) for package: python3-libs-3.6.8-18.el7.x86_64
---> Package python3-pip.noarch 0:9.0.3-8.el7 will be installed
---> Package python3-setuptools.noarch 0:39.2.0-10.el7 will be installed
--> Running transaction check
---> Package libtirpc.x86_64 0:0.2.4-0.16.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Installing:
 numactl-devel            x86_64       2.0.12-5.el7         base           24 k
 python3                  x86_64       3.6.8-18.el7         updates        70 k
Installing for dependencies:
 libtirpc                 x86_64       0.2.4-0.16.el7       base           89 k
 numactl-libs             x86_64       2.0.12-5.el7         base           30 k
 python3-libs             x86_64       3.6.8-18.el7         updates       6.9 M
 python3-pip              noarch       9.0.3-8.el7          base          1.6 M
 python3-setuptools       noarch       39.2.0-10.el7        base          629 k

Transaction Summary
================================================================================
Install  2 Packages (+5 Dependent packages)

Total download size: 9.4 M
Installed size: 48 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/numactl-libs-2.0.12-5.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for numactl-libs-2.0.12-5.el7.x86_64.rpm is not installed
Public key for python3-3.6.8-18.el7.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               23 MB/s | 9.4 MB  00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : numactl-libs-2.0.12-5.el7.x86_64                             1/7 
  Installing : libtirpc-0.2.4-0.16.el7.x86_64                               2/7 
  Installing : python3-setuptools-39.2.0-10.el7.noarch                      3/7 
  Installing : python3-pip-9.0.3-8.el7.noarch                               4/7 
  Installing : python3-3.6.8-18.el7.x86_64                                  5/7 
  Installing : python3-libs-3.6.8-18.el7.x86_64                             6/7 
  Installing : numactl-devel-2.0.12-5.el7.x86_64                            7/7 
  Verifying  : libtirpc-0.2.4-0.16.el7.x86_64                               1/7 
  Verifying  : python3-3.6.8-18.el7.x86_64                                  2/7 
  Verifying  : python3-libs-3.6.8-18.el7.x86_64                             3/7 
  Verifying  : numactl-libs-2.0.12-5.el7.x86_64                             4/7 
  Verifying  : python3-setuptools-39.2.0-10.el7.noarch                      5/7 
  Verifying  : python3-pip-9.0.3-8.el7.noarch                               6/7 
  Verifying  : numactl-devel-2.0.12-5.el7.x86_64                            7/7 

Installed:
  numactl-devel.x86_64 0:2.0.12-5.el7       python3.x86_64 0:3.6.8-18.el7      

Dependency Installed:
  libtirpc.x86_64 0:0.2.4-0.16.el7           numactl-libs.x86_64 0:2.0.12-5.el7 
  python3-libs.x86_64 0:3.6.8-18.el7         python3-pip.noarch 0:9.0.3-8.el7   
  python3-setuptools.noarch 0:39.2.0-10.el7 

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
