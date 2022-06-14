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

```
$ cd ignition-files
$ echo "{\"ignition_config_override\":$(jq -c . discovery.ign | jq -R)}" 
{"ignition_config_override":"{\"ignition\":{\"version\":\"3.1.0\"},\"systemd\":{\"units\":[{\"name\":\"var-mnt.mount\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Mount precached container images\\nBefore=precache-images.service\\nStopWhenUnneeded=true\\n\\n[Mount]\\nWhat=/dev/disk/by-partlabel/data\\nWhere=/var/mnt\\nType=xfs\\nTimeoutSec=30\\n\\n[Install]\\nWantedBy=multi-user.target\"},{\"name\":\"precache-images.service\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Extracts the precached images into containers storage\\nRequires=var-mnt.mount\\nAfter=var-mnt.mount\\nBefore=agent.service\\n\\n[Service]\\nType=oneshot\\nUser=root\\nWorkingDirectory=/var/mnt/ai-images\\nExecStart=bash /var/mnt/ai-images/extract-ai.sh\\nExecStartPost=systemctl disable var-mnt.mount\\nExecStop=systemctl stop var-mnt.mount\\nTimeoutStopSec=45\\n\\n[Install]\\nWantedBy=multi-user.target default.target\\nWantedBy=agent.service\"}]}}"}

$ echo "{\"ignition_config_override\":$(jq -c . discovery.ign | jq -R)}"  > discovery.patch
```

```
$ cd ignition-files
$ echo "{\"config\":$(jq -c . pointer.ign | jq -R)}" 
{"config":"{\"ignition\":{\"version\":\"3.1.0\"},\"passwd\":{\"users\":[{\"groups\":[\"sudo\"],\"name\":\"core\",\"passwordHash\":\"!\",\"sshAuthorizedKeys\":[\"ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZnG8AIzlDAhpyENpK2qKiTT8EbRWOrz7NXjRzopbPu215mocaJgjjwJjh1cYhgPhpAp6M/ttTk7I4OI7g4588Apx4bwJep6oWTU35LkY8ZxkGVPAJL8kVlTdKQviDv3XX12l4QfnDom4tm4gVbRH0gNT1wzhnLP+LKYm2Ohr9D7p9NBnAdro6k++XWgkDeijLRUTwdEyWunIdW1f8G0Mg8Y1Xzr13BUo3+8aey7HLKJMDtobkz/C8ESYA/f7HJc5FxF0XbapWWovSSDJrr9OmlL9f4TfE+cQk3s+eoKiz2bgNPRgEEwihVbGsCN4grA+RzLCAOpec+2dTJrQvFqsD alosadag@sonnelicht.local\"]}]},\"systemd\":{\"units\":[{\"name\":\"var-mnt.mount\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Mount precached container images\\nBefore=precache-images.service\\nStopWhenUnneeded=true\\n\\n[Mount]\\nWhat=/dev/disk/by-partlabel/data\\nWhere=/var/mnt\\nType=xfs\\nTimeoutSec=30\\n\\n[Install]\\nWantedBy=multi-user.target\"},{\"name\":\"precache-ocp-images.service\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Extracts the precached OCP images into containers storage\\nRequires=var-mnt.mount\\nAfter=var-mnt.mount\\nBefore=machine-config-daemon-pull.service\\n\\n[Service]\\nType=oneshot\\nUser=root\\nWorkingDirectory=/var/mnt/ocp-images\\nExecStart=bash /var/mnt/ocp-images/extract-ocp.sh\\nExecStartPost=systemctl disable var-mnt.mount\\nExecStop=systemctl stop var-mnt.mount\\nTimeoutStopSec=45\\n\\n[Install]\\nWantedBy=machine-config-daemon-pull.service\"}]}}"}

$ echo "{\"config\":$(jq -c . pointer.ign | jq -R)}" > pointer.patch
```


## Create the Assisted Service cluster install

```sh
$ ./02-create-ai-cluster.sh 

Creating cluster virt01
Nothing updated in cluster virt01
This is the 96c1f373-dc20-4301-8e37-6edc19a5d6cd....
{"cluster_id":"22dee1dc-e3ee-4af1-8029-a2a14b5d54f5","cpu_architecture":"x86_64","created_at":"2022-06-14T21:02:59.99569Z","download_url":"http://10.1.178.20:6016/images/96c1f373-dc20-4301-8e37-6edc19a5d6cd?arch=x86_64&type=minimal-iso&version=4.10","email_domain":"Unknown","expires_at":"0001-01-01T00:00:00.000Z","href":"/api/assisted-install/v2/infra-envs/96c1f373-dc20-4301-8e37-6edc19a5d6cd","id":"96c1f373-dc20-4301-8e37-6edc19a5d6cd","ignition_config_override":"{\"ignition\":{\"version\":\"3.1.0\"},\"systemd\":{\"units\":[{\"name\":\"var-mnt.mount\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Mount precached container images\\nBefore=precache-images.service\\nStopWhenUnneeded=true\\n\\n[Mount]\\nWhat=/dev/disk/by-partlabel/data\\nWhere=/var/mnt\\nType=xfs\\nTimeoutSec=30\\n\\n[Install]\\nWantedBy=multi-user.target\"},{\"name\":\"precache-images.service\",\"enabled\":true,\"contents\":\"[Unit]\\nDescription=Extracts the precached images into containers storage\\nRequires=var-mnt.mount\\nAfter=var-mnt.mount\\nBefore=agent.service\\n\\n[Service]\\nType=oneshot\\nUser=root\\nWorkingDirectory=/var/mnt/ai-images\\nExecStart=bash /var/mnt/ai-images/extract-ai.sh\\nExecStartPost=systemctl disable var-mnt.mount\\nExecStop=systemctl stop var-mnt.mount\\nTimeoutStopSec=45\\n\\n[Install]\\nWantedBy=multi-user.target default.target\\nWantedBy=agent.service\"}]}}","kind":"InfraEnv","name":"virt01_infra-env","openshift_version":"4.10","proxy":{},"pull_secret_set":true,"ssh_authorized_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZnG8AIzlDAhpyENpK2qKiTT8EbRWOrz7NXjRzopbPu215mocaJgjjwJjh1cYhgPhpAp6M/ttTk7I4OI7g4588Apx4bwJep6oWTU35LkY8ZxkGVPAJL8kVlTdKQviDv3XX12l4QfnDom4tm4gVbRH0gNT1wzhnLP+LKYm2Ohr9D7p9NBnAdro6k++XWgkDeijLRUTwdEyWunIdW1f8G0Mg8Y1Xzr13BUo3+8aey7HLKJMDtobkz/C8ESYA/f7HJc5FxF0XbapWWovSSDJrr9OmlL9f4TfE+cQk3s+eoKiz2bgNPRgEEwihVbGsCN4grA+RzLCAOpec+2dTJrQvFqsD alosadag@sonnelicht.local","type":"minimal-iso","updated_at":"2022-06-14T21:03:03.223399Z","user_name":"admin"}
[OK] ISO is available to download. Run aicli download iso <cluster> or wget
Validating discovery ignition...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9059  100  9059    0     0  25580      0 --:--:-- --:--:-- --:--:-- 25662
{
  "ignition": {
    "config": {
      "replace": {
        "verification": {}
      }
    },
    "proxy": {},
    "security": {
      "tls": {}
    },
    "timeouts": {},
    "version": "3.1.0"
  },
  "passwd": {
    "users": [
      {
        "groups": [
          "sudo"
        ],
        "name": "core",
        "passwordHash": "!",
        "sshAuthorizedKeys": [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZnG8AIzlDAhpyENpK2qKiTT8EbRWOrz7NXjRzopbPu215mocaJgjjwJjh1cYhgPhpAp6M/ttTk7I4OI7g4588Apx4bwJep6oWTU35LkY8ZxkGVPAJL8kVlTdKQviDv3XX12l4QfnDom4tm4gVbRH0gNT1wzhnLP+LKYm2Ohr9D7p9NBnAdro6k++XWgkDeijLRUTwdEyWunIdW1f8G0Mg8Y1Xzr13BUo3+8aey7HLKJMDtobkz/C8ESYA/f7HJc5FxF0XbapWWovSSDJrr9OmlL9f4TfE+cQk3s+eoKiz2bgNPRgEEwihVbGsCN4grA+RzLCAOpec+2dTJrQvFqsD alosadag@sonnelicht.local"
        ]
      }
    ]
  },
  "storage": {
    "files": [
      {
        "group": {},
        "overwrite": true,
        "path": "/usr/local/bin/agent-fix-bz1964591",
        "user": {
          "name": "root"
        },
        "contents": {
          "source": "data:,%23%21%2Fusr%2Fbin%2Fsh%0A%0A%23%20This%20script%20is%20a%20workaround%20for%20bugzilla%201964591%20where%20symlinks%20inside%20%2Fvar%2Flib%2Fcontainers%2F%20get%0A%23%20corrupted%20under%20some%20circumstances.%0A%23%0A%23%20In%20order%20to%20let%20agent.service%20start%20correctly%20we%20are%20checking%20here%20whether%20the%20requested%0A%23%20container%20image%20exists%20and%20in%20case%20%22podman%20images%22%20returns%20an%20error%20we%20try%20removing%20the%20faulty%0A%23%20image.%0A%23%0A%23%20In%20such%20a%20scenario%20agent.service%20will%20detect%20the%20image%20is%20not%20present%20and%20pull%20it%20again.%20In%20case%0A%23%20the%20image%20is%20present%20and%20can%20be%20detected%20correctly%2C%20no%20any%20action%20is%20required.%0A%0AIMAGE=$%28echo%20$1%20%7C%20sed%20%27s%2F:.%2A%2F%2F%27%29%0Apodman%20images%20%7C%20grep%20$IMAGE%20%7C%7C%20podman%20rmi%20--force%20$1%20%7C%7C%20true%0A",
          "verification": {}
        },
        "mode": 755
      },
      {
        "group": {},
        "overwrite": true,
        "path": "/etc/motd",
        "user": {
          "name": "root"
        },
        "contents": {
          "source": "data:,%0A%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%0AThis%20is%20a%20host%20being%20installed%20by%20the%20OpenShift%20Assisted%20Installer.%0AIt%20will%20be%20installed%20from%20scratch%20during%20the%20installation.%0A%0AThe%20primary%20service%20is%20agent.service.%20To%20watch%20its%20status%2C%20run:%0Asudo%20journalctl%20-u%20agent.service%0A%0ATo%20view%20the%20agent%20log%2C%20run:%0Asudo%20journalctl%20TAG=agent%0A%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%20%20%2A%2A%0A",
          "verification": {}
        },
        "mode": 420
      },
      {
        "group": {},
        "overwrite": true,
        "path": "/etc/NetworkManager/conf.d/01-ipv6.conf",
        "user": {
          "name": "root"
        },
        "contents": {
          "source": "data:,%0A%5Bconnection%5D%0Aipv6.dhcp-iaid=mac%0Aipv6.dhcp-duid=ll%0A",
          "verification": {}
        },
        "mode": 420
      },
      {
        "group": {},
        "overwrite": true,
        "path": "/root/.docker/config.json",
        "user": {
          "name": "root"
        },
        "contents": {
          "source": "data:,%7B%22auths%22:%7B%22cloud.openshift.com%22:%7B%22auth%22:%22b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2Fsb3NhZGFncmVkaGF0Y29tMXNiejh5MTJkb2JpamczZW9veWx6cG9jcWRmOjEyOTYzQ0hFS0NDVlNSTjRLTDdRRThaODhWR1E1UUwwUUJCV0NBMk9LTlZUN0pZMVI3M0RKQkRNUjZVTjVRRTY=%22%2C%22email%22:%22alosadag@redhat.com%22%7D%2C%22quay.io%22:%7B%22auth%22:%22b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2Fsb3NhZGFncmVkaGF0Y29tMXNiejh5MTJkb2JpamczZW9veWx6cG9jcWRmOjEyOTYzQ0hFS0NDVlNSTjRLTDdRRThaODhWR1E1UUwwUUJCV0NBMk9LTlZUN0pZMVI3M0RKQkRNUjZVTjVRRTY=%22%2C%22email%22:%22alosadag@redhat.com%22%7D%2C%22registry.connect.redhat.com%22:%7B%22auth%22:%22NTExNDk5MzF8dWhjLTFTYlo4eTEyRE9CSWpnM2Vvb1lMWnBPY3FkRjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmhZelJtWWpjek0yWm1ZbVEwTVdZd09HTmtZVFkxWmpsall6VmxOemN4TVNKOS5DRWl5TS1iNEg3dXFRQlJNVTJteEJnR2lTNHZqUlViRTl4R3VfOFBEQ2VCR1o3c2tralpxSVo4UWJab1pzSHZ6dXloV010VnBSdEE2VXJqckdlazc5dnk3SDRKOXF6aThuTl94YnFYYTJLUUI5dURjYWQzUHgxeU1BX1ZxcUhHQXNxMHAzQ0FKN0ktQnIxZ1VGc1FQSExaMkF0NDNzYlhVeGlweTBHanhZS1N6MEFRR0RDcU5hakJVZTRhRGNRNFJ3cHNFX1J6bFEyenpkNVQwT0UzVXpFdTBPMUp2MmozS2Z1UlkwOFY5aXF2NlliRURyU3JTeEVXNnZlNnE1MHdJc3h0T2FPc1ZFT1hIVFlrNDJ3Y2h6M19RWGdvbF9hS0tIOV9SN0liU0ViQmlMSjJJRGZUUEpJcTdSQUU5dEZKVGF1MXZYa2VDdjdLdHdiTXBVVFMyb3AwOTJEZnFwR0ZGQzFweGxMeE9HMkZsb28xZjNQQnB2cEpCc0UwcF9US3hMcDNucE43RndoY3NaX2tMRmJ5YmUtMTlxNnFBU0NOSmlRN0YxeEtMaHFPYmM5cFl2WXQwd3ZWUVhyRHhwYjVMME5oQ0RGUkRzenpVcERvQ3dyUWxzMEtnYWw3Y1c0UlprWVdWYUQ3SHhTZ2EwMjVVaVVmVVE5VVpvUTRIM3k1cmJ0anlOMmFKOGQtLVE0NUdlTXp0VlFzeE5XNHJQSWJVX2Y4S0ZIT1U3RFV5WVJoVGVubndSeDQyT1B6bkFSbUFPLTh3WWhSalVXVjRxX1hFRXcyWWR1TDNtRVRXTHBJOTNqOUcxZmZsM2s3XzBXWmRiZWl2UE9EWFYxRmNqYzRnOXNJQkgtaHNPVWprcVNiWVd6QkxkU19HeXRqTENnZVZOdFlvVDNnVlhObw==%22%2C%22email%22:%22alosadag@redhat.com%22%7D%2C%22registry.redhat.io%22:%7B%22auth%22:%22NTExNDk5MzF8dWhjLTFTYlo4eTEyRE9CSWpnM2Vvb1lMWnBPY3FkRjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmhZelJtWWpjek0yWm1ZbVEwTVdZd09HTmtZVFkxWmpsall6VmxOemN4TVNKOS5DRWl5TS1iNEg3dXFRQlJNVTJteEJnR2lTNHZqUlViRTl4R3VfOFBEQ2VCR1o3c2tralpxSVo4UWJab1pzSHZ6dXloV010VnBSdEE2VXJqckdlazc5dnk3SDRKOXF6aThuTl94YnFYYTJLUUI5dURjYWQzUHgxeU1BX1ZxcUhHQXNxMHAzQ0FKN0ktQnIxZ1VGc1FQSExaMkF0NDNzYlhVeGlweTBHanhZS1N6MEFRR0RDcU5hakJVZTRhRGNRNFJ3cHNFX1J6bFEyenpkNVQwT0UzVXpFdTBPMUp2MmozS2Z1UlkwOFY5aXF2NlliRURyU3JTeEVXNnZlNnE1MHdJc3h0T2FPc1ZFT1hIVFlrNDJ3Y2h6M19RWGdvbF9hS0tIOV9SN0liU0ViQmlMSjJJRGZUUEpJcTdSQUU5dEZKVGF1MXZYa2VDdjdLdHdiTXBVVFMyb3AwOTJEZnFwR0ZGQzFweGxMeE9HMkZsb28xZjNQQnB2cEpCc0UwcF9US3hMcDNucE43RndoY3NaX2tMRmJ5YmUtMTlxNnFBU0NOSmlRN0YxeEtMaHFPYmM5cFl2WXQwd3ZWUVhyRHhwYjVMME5oQ0RGUkRzenpVcERvQ3dyUWxzMEtnYWw3Y1c0UlprWVdWYUQ3SHhTZ2EwMjVVaVVmVVE5VVpvUTRIM3k1cmJ0anlOMmFKOGQtLVE0NUdlTXp0VlFzeE5XNHJQSWJVX2Y4S0ZIT1U3RFV5WVJoVGVubndSeDQyT1B6bkFSbUFPLTh3WWhSalVXVjRxX1hFRXcyWWR1TDNtRVRXTHBJOTNqOUcxZmZsM2s3XzBXWmRiZWl2UE9EWFYxRmNqYzRnOXNJQkgtaHNPVWprcVNiWVd6QkxkU19HeXRqTENnZVZOdFlvVDNnVlhObw==%22%2C%22email%22:%22alosadag@redhat.com%22%7D%2C%22quay.io:443%22:%7B%22auth%22:%22YWxvc2FkYWc6UDBaalRYTHdHcVBxbW0vYXRBL2JlKzFDTEN4amVKTXRueFJNUUVGRDZFTzlkU3VWdG04Rk1TSnZJM3BPVWlnQw==%22%2C%22email%22:%22%22%7D%2C%22registry.ci.openshift.org%22:%7B%22auth%22:%22YWxvc2FkYWc6c2hhMjU2fjdPeEx0anJfcjYzc1hORTFIeGxpT2FKZDNFYWtsVnBqaFdNdFNTOFU1aW8=%22%7D%7D%7D",
          "verification": {}
        },
        "mode": 420
      },
      {
        "group": {},
        "overwrite": true,
        "path": "/root/assisted.te",
        "user": {
          "name": "root"
        },
        "contents": {
          "source": "data:text/plain;base64,Cm1vZHVsZSBhc3Npc3RlZCAxLjA7CnJlcXVpcmUgewogICAgICAgIHR5cGUgY2hyb255ZF90OwogICAgICAgIHR5cGUgY29udGFpbmVyX2ZpbGVfdDsKICAgICAgICB0eXBlIHNwY190OwogICAgICAgIGNsYXNzIHVuaXhfZGdyYW1fc29ja2V0IHNlbmR0bzsKICAgICAgICBjbGFzcyBkaXIgc2VhcmNoOwogICAgICAgIGNsYXNzIHNvY2tfZmlsZSB3cml0ZTsKfQojPT09PT09PT09PT09PSBjaHJvbnlkX3QgPT09PT09PT09PT09PT0KYWxsb3cgY2hyb255ZF90IGNvbnRhaW5lcl9maWxlX3Q6ZGlyIHNlYXJjaDsKYWxsb3cgY2hyb255ZF90IGNvbnRhaW5lcl9maWxlX3Q6c29ja19maWxlIHdyaXRlOwphbGxvdyBjaHJvbnlkX3Qgc3BjX3Q6dW5peF9kZ3JhbV9zb2NrZXQgc2VuZHRvOwo=",
          "verification": {}
        },
        "mode": 420
      }
    ]
  },
  "systemd": {
    "units": [
      {
        "contents": "[Service]\nType=simple\nRestart=always\nRestartSec=3\nStartLimitInterval=0\nEnvironment=HTTP_PROXY=\nEnvironment=http_proxy=\nEnvironment=HTTPS_PROXY=\nEnvironment=https_proxy=\nEnvironment=NO_PROXY=\nEnvironment=no_proxy=\nTimeoutStartSec=600\nExecStartPre=/usr/local/bin/agent-fix-bz1964591 quay.io/edge-infrastructure/assisted-installer-agent:latest\nExecStartPre=podman run --privileged --rm -v /usr/local/bin:/hostbin quay.io/edge-infrastructure/assisted-installer-agent:latest cp /usr/bin/agent /hostbin\nExecStart=/usr/local/bin/agent --url http://10.1.178.20:6000 --infra-env-id 96c1f373-dc20-4301-8e37-6edc19a5d6cd --agent-version quay.io/edge-infrastructure/assisted-installer-agent:latest --insecure=true  \n\n[Unit]\nWants=network-online.target\nAfter=network-online.target\n\n[Install]\nWantedBy=multi-user.target",
        "enabled": true,
        "name": "agent.service"
      },
      {
        "contents": "[Service]\nType=oneshot\nExecStartPre=checkmodule -M -m -o /root/assisted.mod /root/assisted.te\nExecStartPre=semodule_package -o /root/assisted.pp -m /root/assisted.mod\nExecStart=semodule -i /root/assisted.pp\n\n[Install]\nWantedBy=multi-user.target",
        "enabled": true,
        "name": "selinux.service"
      },
      {
        "contents": "[Unit]\nDescription=Mount precached container images\nBefore=precache-images.service\nStopWhenUnneeded=true\n\n[Mount]\nWhat=/dev/disk/by-partlabel/data\nWhere=/var/mnt\nType=xfs\nTimeoutSec=30\n\n[Install]\nWantedBy=multi-user.target",
        "enabled": true,
        "name": "var-mnt.mount"
      },
      {
        "contents": "[Unit]\nDescription=Extracts the precached images into containers storage\nRequires=var-mnt.mount\nAfter=var-mnt.mount\nBefore=agent.service\n\n[Service]\nType=oneshot\nUser=root\nWorkingDirectory=/var/mnt/ai-images\nExecStart=bash /var/mnt/ai-images/extract-ai.sh\nExecStartPost=systemctl disable var-mnt.mount\nExecStop=systemctl stop var-mnt.mount\nTimeoutStopSec=45\n\n[Install]\nWantedBy=multi-user.target default.target\nWantedBy=agent.service",
        "enabled": true,
        "name": "precache-images.service"
      }
    ]
  }
}
Download the ISO and mount it into the VM. Then press enter to continue
Wait until hosts are ready in Assisted Installer
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...
Waiting 10s more...

This is the HOST: snonode.virt01.eko4.cloud.lab.eng.bos.redhat.com and HOSTID: 3b5f97db-464f-4792-8a97-cfb7b5c63a30 values
Updating Host snonode.virt01.eko4.cloud.lab.eng.bos.redhat.com
Validating configuration...

bootstrap: True
checked_in_at: 2022-06-14T21:14:33.162Z
cluster_id: 4aca008e-38d1-40b6-a5ef-0bdda93bf5c8
created_at: 2022-06-14T21:14:32.893096Z
id: 3b5f97db-464f-4792-8a97-cfb7b5c63a30
ignition_config_overrides: {"ignition":{"version":"3.1.0"},"passwd":{"users":[{"groups":["sudo"],"name":"core","passwordHash":"!","sshAuthorizedKeys":["ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZnG8AIzlDAhpyENpK2qKiTT8EbRWOrz7NXjRzopbPu215mocaJgjjwJjh1cYhgPhpAp6M/ttTk7I4OI7g4588Apx4bwJep6oWTU35LkY8ZxkGVPAJL8kVlTdKQviDv3XX12l4QfnDom4tm4gVbRH0gNT1wzhnLP+LKYm2Ohr9D7p9NBnAdro6k++XWgkDeijLRUTwdEyWunIdW1f8G0Mg8Y1Xzr13BUo3+8aey7HLKJMDtobkz/C8ESYA/f7HJc5FxF0XbapWWovSSDJrr9OmlL9f4TfE+cQk3s+eoKiz2bgNPRgEEwihVbGsCN4grA+RzLCAOpec+2dTJrQvFqsD alosadag@sonnelicht.local"]}]},"systemd":{"units":[{"name":"var-mnt.mount","enabled":true,"contents":"[Unit]\nDescription=Mount precached container images\nBefore=precache-images.service\nStopWhenUnneeded=true\n\n[Mount]\nWhat=/dev/disk/by-partlabel/data\nWhere=/var/mnt\nType=xfs\nTimeoutSec=30\n\n[Install]\nWantedBy=multi-user.target"},{"name":"precache-ocp-images.service","enabled":true,"contents":"[Unit]\nDescription=Extracts the precached OCP images into containers storage\nRequires=var-mnt.mount\nAfter=var-mnt.mount\nBefore=machine-config-daemon-pull.service\n\n[Service]\nType=oneshot\nUser=root\nWorkingDirectory=/var/mnt/ocp-images\nExecStart=bash /var/mnt/ocp-images/extract-ocp.sh\nExecStartPost=systemctl disable var-mnt.mount\nExecStop=systemctl stop var-mnt.mount\nTimeoutStopSec=45\n\n[Install]\nWantedBy=machine-config-daemon-pull.service"}]}}
infra_env_id: 2ae4bd72-93b9-4862-97af-e297447b70dd
installation_disk_id: /dev/disk/by-path/pci-0000:05:00.0
installation_disk_path: /dev/vda
installer_args: ["--save-partlabel","data","--copy-network"]
logs_started_at: 0001-01-01T00:00:00.000Z
progress: {'stage_started_at': '0001-01-01T00:00:00.000Z', 'stage_updated_at': '0001-01-01T00:00:00.000Z'}
requested_hostname: snonode.virt01.eko4.cloud.lab.eng.bos.redhat.com
role: master
stage_started_at: 0001-01-01T00:00:00.000Z
stage_updated_at: 0001-01-01T00:00:00.000Z
status: insufficient
status_info: Host cannot be installed due to following failing validation(s): Host couldn't synchronize with any NTP server
status_updated_at: 2022-06-14T21:14:34.948Z
timestamp: 1655241274
updated_at: 2022-06-14T21:14:52.411736Z
user_name: admin

Press enter to continue

Updating Cluster virt01
Printing cluster information...
Validating cluster info....
base_dns_domain: eko4.cloud.lab.eng.bos.redhat.com
cluster_networks: [{'cluster_id': '4aca008e-38d1-40b6-a5ef-0bdda93bf5c8', 'cidr': '10.128.0.0/14', 'host_prefix': 23}]
connectivity_majority_groups: {"10.19.136.0/21":[],"2620:52:0:1388::/64":[],"IPv4":[],"IPv6":[]}
controller_logs_collected_at: 0001-01-01 00:00:00+00:00
controller_logs_started_at: 0001-01-01 00:00:00+00:00
cpu_architecture: x86_64
created_at: 2022-06-14 21:09:37.212004+00:00
disk_encryption: {'enable_on': 'none', 'mode': 'tpmv2', 'tang_servers': None}
email_domain: Unknown
enabled_host_count: 1
feature_usage: {"OVN network type":{"id":"OVN_NETWORK_TYPE","name":"OVN network type"},"SNO":{"id":"SNO","name":"SNO"}}
high_availability_mode: None
hyperthreading: all
id: 4aca008e-38d1-40b6-a5ef-0bdda93bf5c8
ignition_endpoint: {'url': None, 'ca_certificate': None}
install_completed_at: 0001-01-01 00:00:00+00:00
install_started_at: 0001-01-01 00:00:00+00:00
machine_networks: [{'cluster_id': '4aca008e-38d1-40b6-a5ef-0bdda93bf5c8', 'cidr': '10.19.136.0/21'}]
monitored_operators: [{'cluster_id': '4aca008e-38d1-40b6-a5ef-0bdda93bf5c8', 'name': 'console', 'namespace': None, 'subscription_name': None, 'operator_type': 'builtin', 'properties': None, 'timeout_seconds': 3600, 'status': None, 'status_info': None, 'status_updated_at': datetime.datetime(1, 1, 1, 0, 0, tzinfo=tzutc())}]
name: virt01
network_type: OVNKubernetes
ocp_release_image: quay.io/openshift-release-dev/ocp-release:4.10.3-x86_64
openshift_version: 4.10.3
platform: {'type': 'baremetal', 'ovirt': {'fqdn': None, 'username': None, 'password': None, 'insecure': True, 'ca_bundle': None, 'cluster_id': None, 'storage_domain_id': None, 'network_name': 'ovirtmgmt', 'vnic_profile_id': None}}
ready_host_count: 1
schedulable_masters: False
service_networks: [{'cluster_id': '4aca008e-38d1-40b6-a5ef-0bdda93bf5c8', 'cidr': '172.30.0.0/16'}]
status: ready
status_info: Cluster ready to be installed
status_updated_at: 2022-06-14 21:15:40.949000+00:00
total_host_count: 1
updated_at: 2022-06-14 21:15:56.351478+00:00
user_managed_networking: True
user_name: admin

Starting cluster virt01
Cluster installation started...

+-----------------------------+--------------------------------------+----------------------------+-----------------------------------+
|           Cluster           |                  Id                  |           Status           |             Dns Domain            |
+-----------------------------+--------------------------------------+----------------------------+-----------------------------------+
| test-infra-cluster-339770e9 | 386db79b-0dfa-40df-93d5-9862d32eeb6f |           ready            |             redhat.com            |
| test-infra-cluster-dfc62940 | 510bc21d-2a96-4d11-be37-212a526dcb51 |         installed          |             redhat.com            |
|            virt01           | 4aca008e-38d1-40b6-a5ef-0bdda93bf5c8 | preparing-for-installation | eko4.cloud.lab.eng.bos.redhat.com |
+-----------------------------+--------------------------------------+----------------------------+-----------------------------------+
Waiting 30s.......
+-----------------------------+--------------------------------------+------------+-----------------------------------+
|           Cluster           |                  Id                  |   Status   |             Dns Domain            |
+-----------------------------+--------------------------------------+------------+-----------------------------------+
| test-infra-cluster-339770e9 | 386db79b-0dfa-40df-93d5-9862d32eeb6f |   ready    |             redhat.com            |
| test-infra-cluster-dfc62940 | 510bc21d-2a96-4d11-be37-212a526dcb51 | installed  |             redhat.com            |
|            virt01           | 4aca008e-38d1-40b6-a5ef-0bdda93bf5c8 | installing | eko4.cloud.lab.eng.bos.redhat.com |
+-----------------------------+--------------------------------------+------------+-----------------------------------+
```

