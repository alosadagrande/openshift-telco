 # Goal
 
 This folder stores all the information and scripts required to prototype a factory pre-staging solution where all the generic installation artifacts are persistent on a disk, and the cluster deployment would retrieve everything from that local partition instead of using any external network.
 
 # Structure
 
* **01-create-vm.sh**. This helper scripts creates a virtual machine ready to be provisioned via ZTP with all the required precached artifacts and partition configured.
* **02-create-ai-cluster.sh**. This helper scripts runs a provisioning workflow interacting with the Assisted Installer APIs
* **container-images/** . This folder contains all the precached artifacts required to provision OCP with Assisted Installer.
  * curl-all.sh. This script is used by the 01-create-vm.sh script to download all the artifacts and scripts into the partition.
  * **ai-images/**. This folder contains all the artifacts needed during the initial phase of the provisioning where the AI agent is registered against the Assisted Service.
    * extract-ai.sh. This script is in charge of extracting the artifacts into the container storage folder of the OS. It uses the list of container images listed below. This script is executed by a systemd service once the minimal ISO is booted on memory.
    * initial-images-4.10.3.txt. This file contains a list of all the container images with its full container name needed for the Assisted Installer registration process where the minimal ISO is running.
    * pull-ai.sh. This script uses the above list to pull all the container images from their official location to a local gzipped tarball.
  * **ocp-images/**. This folder contains all the artifacts and scripts required to be placed in the container storage during the OpenShift installation phase.  
    * extract-ocp.sh. This script is in charge of extracting the artifacts into the container storage folder of the running OS. It uses the list of container images listed below. This script is executed once the RHCOS image is persisted into disk.
    * ocp_images.txt.4.10.3. This file contains a list of all the container images with its full container name needed for the OCP installation process. 
    * pull-ocp.sh. This script uses the above list to pull all the container images from the official location to a local compressed tarball. In this case it only downloads container images listed in the OCP release info (oc adm release info).
  * **pre-cache/**. This folder contains all the tools to create the list of OCP images required to be precached. It is based on the [Cluster Group Upgrade precache feature](https://github.com/openshift-kni/cluster-group-upgrades-operator/tree/main/pre-cache).
    * release. This is the principal script that creates a list of all the OCP container images that needs to be pulled. That list is saved in a file called images.txt.$ocp_version. The same list will be used by pull-ocp.sh to download them in a tar.gz format.
  * **create-gpt-partition.sh**. This script is called by the 01-create-vm.sh in order to create a GPT partition at the end of the disk.
  * **ignition-files/**. This folder contains all the specific configurations applied to Assisted Service to override the default set up for the discovery and pointer ignition.
    * discovery.ign. These are the ignition systemd units that need to be included into the discovery ignition that is part of the minimal ISO.
    * discovery.patch. This is the patch applied to the Assisted Service API to override the discovery ignition. Its content is created from the previous discovery.ign
    * pointer.ign. These are the ignition systemd units that need to be added when the coreos-installer utility is written RHCOS to disk.
    * pointer.patch. This is the patch applied to the Assisted Service API to override the pointer ignition. Its content is created from the previous pointer.ign.
  * **profile-sno-rhcos.yaml**. This is a template used by the 01-create-vm.sh, well, actually it is used by [kcli](https://github.com/karmab/kcli) to create the KVM virtual machine. It includes memory, cpu, storage, network, etc... basically all the required configuration for creating a VM and furthermore a the extract-ocp and extract-initial scripts to be placed in the partition folder.

# Workflow

## Pull the container images

First pull the container images required for registering the new cluster into Assisted Service. In this case it just pull the images listed in the OCP_RELEASE_LIST variable which by default points at initial-images-4.10.3.txt which is based on 4.10.3 release.

> ❗The images will be stored in the FOLDER variable location in  a tar.gz format.

```
# export FOLDER=/root/container-images/images-4.10.3/
# ./pull-ai.sh 
~/container-images/images-4.10.3 ~/openshift-telco/prestaging-telco-prototype-ztp/container-images/images-4.10.3
Pulling quay.io/alosadag/troubleshoot:latest [1/20]
troubleshoot_latest/
troubleshoot_latest/version
troubleshoot_latest/fdc12ef68aeeb51669f794676814577b3b2e9df667d27d033cee5ad802afd1f0
troubleshoot_latest/998ceb85f37596025e32fab7d9cd59620b87ba0e45ab5c18c59060f59840daaf
troubleshoot_latest/45081c646f637d7ba601d6f9dc8a026b2be1cf96c969311ae0c7be6e08f20bb1
troubleshoot_latest/b0eb4fd5a26a59a6bb57d88dd506bb37d8ab5295585f09ec9940fb69d4b6f26a
troubleshoot_latest/8e1776db48149421bc08cfdd1bc34972ef8541ff4923cf435dce7c93d1556637
troubleshoot_latest/48d75fc02b4089790127d910bdc3ea6f2973f9a75c99b90c9d5dd7db54f2bd76
troubleshoot_latest/09c770d1f86a341387b27b25fb83633d708c06c85a835eafc68306b739e5718e
troubleshoot_latest/f446b25e21b6fd4f08d2c08962f593f611ddf3c04b19fdb9b28a9fd8969c5e75
troubleshoot_latest/manifest.json
Pulling quay.io/edge-infrastructure/assisted-installer-agent:latest [2/20]
....
Pulling quay.io/edge-infrastructure/assisted-installer:latest [20/20]
assisted-installer_latest/
assisted-installer_latest/version
assisted-installer_latest/89b4a75bc2d8500f15463747507c9623df43886c134463e7f0527e70900e7a7b
assisted-installer_latest/a70843738bb77e1ab9c1f85969ebdfa55f178e746be081d1cb4f94011f69eb7c
assisted-installer_latest/c32ab78b488d0c72f64eded765c0cf6b5bf2c75dab66cb62a9d367fa6ec42513
assisted-installer_latest/599d07cb321ff0a3c82224e1138fc685793fa69b93ed5780415751a5f7e4b8c2
assisted-installer_latest/18e134661c2f79cde945bfaaeb77a527750ecd024fa63aa1f65ae577c5fb88da
assisted-installer_latest/93816e42ddd0a62c3bf8c3b86466c1a9682786072c1282dda7723634d03f3bb1
assisted-installer_latest/manifest.json
~/openshift-telco/prestaging-telco-prototype-ztp/container-images/ai-images
```

Next, pull the container images required for install OpenShift.

> ⚠️ Those images will depend on the OCP release you are trying to install.

```
# export export pull_secret_path=/home/kni/ipi-install-cnf20/pull-secret.json
# ./release 4.10.4
upgrades.pre-cache 2022-06-14T14:02:28+00:00 DEBUG Release index image processing done
89009c527d1a6a249524856bbefeb0aedf26ae412943b1d5702b8a4b4c0878b8
# ./release 4.10.3
# ls -l
total 64
-rwxr-xr-x. 1 root root  1231 Jun 14 14:15 common
-rw-r--r--. 1 root root 19278 Jun 14 14:17 ocp_images.txt.4.10.3
-rw-r--r--. 1 root root 19397 Jun 14 14:17 ocp_images.txt.4.10.4
-rwxr-xr-x. 1 root root  2739 Jun  8 09:30 olm
-rw-r--r--. 1 root root  3848 Jun  8 09:30 parse_index.py
-rwxr-xr-x. 1 root root  3216 Jun  8 09:30 pull
-rw-r--r--. 1 root root   631 Jun  8 09:30 README.md
-rwxr-xr-x. 1 root root  1182 Jun 14 14:01 release
```
Now, pull all the OCP container images for the specific release:

```
# cp ocp_images.txt.4.10.3 ../ocp-images-4.10.3/.
# cd ../ocp-images
# export FOLDER=/root/container-images/ocp-images-4.10.3/
[root@eko4 ocp-images]# ./pull-ocp.sh 
~/container-images/ocp-images-4.10.3 ~/openshift-telco/prestaging-telco-prototype-ztp/container-images/ocp-images
Pulling quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39 [1/162]
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/version
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/eac1b95df832dc9f172fd1f07e7cb50c1929b118a4249ddd02c6318a677b506a
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/47aa3ed2034c4f27622b989b26c06087de17067268a19a1b3642a7e2686cd1a3
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/01318f016ef2c64d07aebccbb8b60eabb3b68b5905b093f5ac6fce0747d94415
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/ed7bb2714da62ad5492dbd944cef2a3f92df8120ef2c877c03f1975ba01b2382
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/e267a71e8d3b93df38d65d2622685d283ecab97d8d8acef46379d2026200207c
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/9d5d4f564033a2bac3af7611734c3f9323225421eb0345455d1c11375a680326
ocp-v4.0-art-dev@sha256_70baef8e0f932a66ca16738e0ddba5148645bbd9947b40ec4cec63630dd33c39/manifest.json
Pulling quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:fcc68fcb4d57bbb544f18996bb9a12859db31d2dfe02573c3b11c028dbee2a92 [2/162]
...
Pulling quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4 [162/162]
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/version
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/eac1b95df832dc9f172fd1f07e7cb50c1929b118a4249ddd02c6318a677b506a
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/47aa3ed2034c4f27622b989b26c06087de17067268a19a1b3642a7e2686cd1a3
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/01318f016ef2c64d07aebccbb8b60eabb3b68b5905b093f5ac6fce0747d94415
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/ed7bb2714da62ad5492dbd944cef2a3f92df8120ef2c877c03f1975ba01b2382
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/be3ee8645076d69a5fab4e1bdc98a01fd630229262c085e113d257a65b6e0865
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/fc847acc7a60005faee5e176df432cbc890268ad2c00ffad4663e4f454607371
ocp-v4.0-art-dev@sha256_d846a05f9ced30f3534e1152802c51c0ccdf80da1d323f9b9759c2e06b3e03b4/manifest.json
```

## Create the pre-staged virtual machine 

Next step is to create the pre-staged virtual machine where SNO is going to be installed.

```
$ ./01-create-vm.sh 
Creating a VM running RHCOS 4.10...
Setting 10.19.140.20 ipv4...
UEFI enabled...
Adding scripts to populate the partition with artifacts...
Deploying Vms...
snonode.virt01.eko4.cloud.lab.eng.bos.redhat.com deployed on eko4

creating the GPT partition at the end of device vdb, format vdb1 as XFS and mount on /var/mnt

+ sgdisk -n 1:120000000 /dev/vdb -g
Creating new GPT entries.
Information: Moved requested sector from 120000000 to 119998464 in
order to align on 2048-sector boundaries.
The operation has completed successfully.
+ sgdisk -c:1:data /dev/vdb
Setting name!
partNum is 0
The operation has completed successfully.
+ mkfs.xfs /dev/vdb1
meta-data=/dev/vdb1              isize=512    agcount=4, agsize=4114367 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=16457467, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8035, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
+ mount /dev/vdb1 /var/mnt/
Downloading the boostrap container images...
+ HTTP_IP=10.19.138.94
+ FOLDER=/var/mnt
+ OCP_RELEASE=4.10.3
+ mkdir -p /var/mnt/ai-images
+ mkdir -p /var/mnt/ocp-images
+ curl_artifacts 10.19.138.94 /var/mnt
+ HTTPD=10.19.138.94
+ LOCATION=/var/mnt
+ mkdir -p /var/mnt
++ curl -s http://10.19.138.94
++ grep href
++ sed 's/.*href="//'
++ sed 's/".*//'
++ grep '^[0-9a-zA-Z].*'
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/images-4.10.3/ -o /var/mnt/images-4.10.3/
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3/ -o /var/mnt/ocp-images-4.10.3/
+ curl_artifacts 10.19.138.94/images-4.10.3/ /var/mnt/ai-images
+ HTTPD=10.19.138.94/images-4.10.3/
+ LOCATION=/var/mnt/ai-images
+ mkdir -p /var/mnt/ai-images
++ curl -s http://10.19.138.94/images-4.10.3/
++ grep href
++ sed 's/.*href="//'
++ sed 's/".*//'
++ grep '^[0-9a-zA-Z].*'
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/images-4.10.3//assisted-installer-agent-rhel8_v1.0.0-89.tgz -o /var/mnt/ai-images/assisted-installer-agent-rhel8_v1.0.0-89.tgz
...
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/images-4.10.3//ocp-v4.0-art-dev@sha256_fe8d01e2de1a04428b2dfd71711a6893ea84ad22890ea29ca92185705fc11f48.tgz -o /var/mnt/ai-images/ocp-v4.0-art-dev@sha256_fe8d01e2de1a04428b2dfd71711a6893ea84ad22890ea29ca92185705fc11f48.tgz
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/images-4.10.3//troubleshoot_latest.tgz -o /var/mnt/ai-images/troubleshoot_latest.tgz
+ curl_artifacts 10.19.138.94/ocp-images-4.10.3/ /var/mnt/ocp-images
+ HTTPD=10.19.138.94/ocp-images-4.10.3/
+ LOCATION=/var/mnt/ocp-images
+ mkdir -p /var/mnt/ocp-images
++ grep href
++ curl -s http://10.19.138.94/ocp-images-4.10.3/
++ sed 's/.*href="//'
++ sed 's/".*//'
++ grep '^[0-9a-zA-Z].*'
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//extract-ocp.sh -o /var/mnt/ocp-images/extract-ocp.sh
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//ocp-images-4.10.3.txt -o /var/mnt/ocp-images/ocp-images-4.10.3.txt
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//ocp-v4.0-art-dev@sha256_f835160f1dc29995853eb1c13aa9e2badbb45c8656947b6eb6faefc876aab3ee.tgz -o /var/mnt/ocp-images/ocp-v4.0-art-dev@sha256_f835160f1dc29995853eb1c13aa9e2badbb45c8656947b6eb6faefc876aab3ee.tgz
...
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//ocp-v4.0-art-dev@sha256_fcc68fcb4d57bbb544f18996bb9a12859db31d2dfe02573c3b11c028dbee2a92.tgz -o /var/mnt/ocp-images/ocp-v4.0-art-dev@sha256_fcc68fcb4d57bbb544f18996bb9a12859db31d2dfe02573c3b11c028dbee2a92.tgz
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//ocp-v4.0-art-dev@sha256_fe8d01e2de1a04428b2dfd71711a6893ea84ad22890ea29ca92185705fc11f48.tgz -o /var/mnt/ocp-images/ocp-v4.0-art-dev@sha256_fe8d01e2de1a04428b2dfd71711a6893ea84ad22890ea29ca92185705fc11f48.tgz
+ for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*')
+ curl -s http://10.19.138.94/ocp-images-4.10.3//ocp_images.txt.4.10.3 -o /var/mnt/ocp-images/ocp_images.txt.4.10.3
unmount partition and shutting down...
Connection to 10.19.140.20 closed by remote host.
Pre staged server ready to be delivered...
...
```

At this point we need to remove the first device of the virtual machine. Note that the partition and artifacts are stored in the second device, that nos is becoming the first and only one :). For instance, you can use virt-manager and just remove the first device.

## Create the ignition overrides


## Create the Assisted Service cluster install


