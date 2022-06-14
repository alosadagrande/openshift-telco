 # Goal
 
 This folder stores all the information and scripts required to prototype a factory pre-staging solution where all the generic installation artifacts are persistent on a disk, and the cluster deployment would retrieve everything from that local partition instead of using any external network.
 
 # Structure
 
* 01-create-vm.sh. This helper scripts creates a virtual machine ready to be provisioned via ZTP with all the required precached artifacts and partition configured.
* 02-create-ai-cluster.sh. This helper scripts runs a provisioning workflow interacting with the Assisted Installer APIs
* container-images/ . This folder contains all the precached artifacts required to provision OCP with Assisted Installer.
  * curl-all.sh. This script is used by the 01-create-vm.sh script to download all the artifacts and scripts into the partition.
  * images-4.10.3/. This folder contains all the artifacts needed during the initial phase of the provisioning where the AI agent is registered against the Assisted Service.
    * extract-initial-4.10.3.sh. This script is in charge of extracting the artifacts into the container storage folder of the OS. It uses the list of container images listed below. This script is executed by a systemd service once the minimal ISO is booted on memory.
    * initial-images-4.10.3.txt. This file contains a list of all the container images with its full container name needed for the Assisted Installer registration process where the minimal ISO is running.
    * pull-initial-4.10.3.sh. This script uses the above list to pull all the container images from their official location to a local gzipped tarball.
  * ocp-images-4.10.3/. This folder contains all the artifacts and scripts required to be placed in the container storage during the OpenShift installation phase.  
    * extract-ocp-4.10.3.sh. This script is in charge of extracting the artifacts into the container storage folder of the running OS. It uses the list of container images listed below. This script is executed once the RHCOS image is persisted into disk.
    * ocp-images-4.10.3.txt. This file contains a list of all the container images with its full container name needed for the OCP installation process. 
    * pull-ocp-4.10.3.sh. This script uses the above list to pull all the container images from the official location to a local compressed tarball. In this case it only downloads container images listed in the OCP release info (oc adm release info).
  * pre-cache/. This folder contains all the tools to create the list of OCP images required to be precached. It is based on the [Cluster Group Upgrade precache feature](https://github.com/openshift-kni/cluster-group-upgrades-operator/tree/main/pre-cache).
    * main.sh. This is the principal script which calls the release script with a couple of variables. The output is a list of all container images ready to be pulled in a file called images.txt
  * create-gpt-partition.sh. This script is called by the 01-create-vm.sh in order to create a GPT partition at the end of the disk.
  * ignition-files/. This folder contains all the specific configurations applied to Assisted Service to override the default set up for the discovery and pointer ignition.
    * discovery.ign. These are the ignition systemd units that need to be included into the discovery ignition that is part of the minimal ISO.
    * discovery.patch. This is the patch applied to the Assisted Service API to override the discovery ignition. Its content is created from the previous discovery.ign
    * pointer.ign. These are the ignition systemd units that need to be added when the coreos-installer utility is written RHCOS to disk.
    * pointer.patch. This is the patch applied to the Assisted Service API to override the pointer ignition. Its content is created from the previous pointer.ign.
  * profile-sno-rhcos.yaml. This is a template used by the 01-create-vm.sh, well, actually it is used by [kcli](https://github.com/karmab/kcli) to create the KVM virtual machine. It includes memory, cpu, storage, network, etc... basically all the required configuration for creating a VM and furthermore a the extract-ocp and extract-initial scripts to be placed in the partition folder.

 
