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
  * pre-cache/. This folder contains all the tools to create the list of OCP images required to be precached. It is based on the Cluster Group Upgrade precache feature.
│       ├── common
│       ├── images.txt
│       ├── main.sh
│       ├── olm
│       ├── parse_index.py
│       ├── pull
│       ├── README.md
│       └── release
├── create-gpt-partition.sh
├── ignition-files
│   ├── discovery.ign
│   ├── discovery.patch
│   ├── pointer.ign
│   └── pointer.patch
├── profile-sno-rhcos.yaml

 
