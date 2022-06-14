 # Goal
 
 This folder stores all the information and scripts required to prototype a factory pre-staging solution where all the generic installation artifacts are persistent on a disk, and the cluster deployment would retrieve everything from that local partition instead of using any external network.
 
 # Structure
 
* **01-create-vm.sh**. This helper scripts creates a virtual machine ready to be provisioned via ZTP with all the required precached artifacts and partition configured.
* **02-create-ai-cluster.sh**. This helper scripts runs a provisioning workflow interacting with the Assisted Installer APIs
* **container-images/** . This folder contains all the precached artifacts required to provision OCP with Assisted Installer.
  * curl-all.sh. This script is used by the 01-create-vm.sh script to download all the artifacts and scripts into the partition.
  * **images-4.10.3/**. This folder contains all the artifacts needed during the initial phase of the provisioning where the AI agent is registered against the Assisted Service.
    * extract-initial-4.10.3.sh. This script is in charge of extracting the artifacts into the container storage folder of the OS. It uses the list of container images listed below. This script is executed by a systemd service once the minimal ISO is booted on memory.
    * initial-images-4.10.3.txt. This file contains a list of all the container images with its full container name needed for the Assisted Installer registration process where the minimal ISO is running.
    * pull-initial-4.10.3.sh. This script uses the above list to pull all the container images from their official location to a local gzipped tarball.
  * **ocp-images-4.10.3/**. This folder contains all the artifacts and scripts required to be placed in the container storage during the OpenShift installation phase.  
    * extract-ocp-4.10.3.sh. This script is in charge of extracting the artifacts into the container storage folder of the running OS. It uses the list of container images listed below. This script is executed once the RHCOS image is persisted into disk.
    * ocp-images-4.10.3.txt. This file contains a list of all the container images with its full container name needed for the OCP installation process. 
    * pull-ocp-4.10.3.sh. This script uses the above list to pull all the container images from the official location to a local compressed tarball. In this case it only downloads container images listed in the OCP release info (oc adm release info).
  * **pre-cache/**. This folder contains all the tools to create the list of OCP images required to be precached. It is based on the [Cluster Group Upgrade precache feature](https://github.com/openshift-kni/cluster-group-upgrades-operator/tree/main/pre-cache).
    * main.sh. This is the principal script which calls the release script with a couple of variables. The output is a list of all container images ready to be pulled in a file called images.txt
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
# ./pull-initial-4.10.3.sh 
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
total 68
-rwxr-xr-x. 1 root root  1227 Jun 14 13:49 common
-rw-r--r--. 1 root root 19278 Jun 14 14:02 images.txt.4.10.3
-rw-r--r--. 1 root root 19397 Jun 14 14:02 images.txt.4.10.4
-rwxr--r--. 1 root root   202 Jun 14 13:55 main.sh
-rwxr-xr-x. 1 root root  2739 Jun  8 09:30 olm
-rw-r--r--. 1 root root  3848 Jun  8 09:30 parse_index.py
-rwxr-xr-x. 1 root root  3216 Jun  8 09:30 pull
-rw-r--r--. 1 root root   631 Jun  8 09:30 README.md
-rwxr-xr-x. 1 root root  1182 Jun 14 14:01 release

