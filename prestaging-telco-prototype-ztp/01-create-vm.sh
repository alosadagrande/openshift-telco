#!/bin/bash

USER=core

echo "Creating a VM running RHCOS 4.10..."
echo "Setting 10.19.140.20 ipv4..."
echo "UEFI enabled..."
echo "Adding scripts to populate the partition with artifacts..."

#kcli create vm -i rhcos-410.84.202203231330-0-qemu.x86_64.qcow2 -P numcpus=8 -P disks=[20,120] -P memory=32768 -P nets=['{"name":"baremetal","nic":"enp1s0","ip":"10.19.140.20","mask":"255.255.248.0","gateway":"10.19.143.254","dns":"10.19.143.247","mac":"44:44:44:44:44:01"}'] -P uefi_legacy=true snonode.virt01.eko4.cloud.lab.eng.bos.redhat.com -P files=['{"path":"/etc/systemd/system/assistedconfig.service", "origin":"rhcos-factory/assistedconfig.service"},{"path":"/etc/systemd/system/run-media.mount","origin":"rhcos-factory/run-media.mount"},{"path":"/etc/systemd/system/container-httpd.service","origin":"rhcos-factory/container-httpd.service"},{"path":"/etc/systemd/system/precache-images.service","origin":"rhcos-factory/precache-images.service"},{"path":"/home/core/curl-all.sh","origin":"container-images/curl-all.sh"},{"path":"/home/core/extract-4.10.3.sh","origin":"container-images/extract-4.10.3.sh"}'] -P cmds=['systemctl enable run-media.mount','systemctl disable precache-images.service'] 

kcli create plan -f profile-sno-rhcos.yaml sno-factory 

ssh ${USER}@10.19.140.20 echo
while test $? -gt 0
do
   sleep 10 # highly recommended - if it's in your local network, it can try an awful lot pretty quick...
   echo "Trying again..."
   ssh ${USER}@10.19.140.20 echo
done

# downloading rhcos metal
#echo "Downloading the RHCOS metal image to SNO:/var/tmp/... it can take a while"
#ssh ${USER}@10.19.140.20  curl -o /var/tmp/rhcos-4.10.3-x86_64-metal.x86_64.raw.gz https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/latest/rhcos-4.10.3-x86_64-metal.x86_64.raw.gz

#creating the GPT partition at the end of device vdb and format vdb1 xfs
echo "creating the GPT partition at the end of device vdb, format vdb1 as XFS and mount on /var/mnt"
ssh ${USER}@10.19.140.20 sudo bash -x /home/core/create-gpt-partition.sh

#downloading bootstrap images
echo "Downloading the boostrap container images..."
ssh ${USER}@10.19.140.20 sudo bash -x /home/core/curl-all.sh 10.19.138.94 /var/mnt

echo "unmount partition and shutting down..."
ssh ${USER}@10.19.140.20 "sudo umount /var/mnt && sudo shutdown -h now"
sleep 10
echo "Pre staged server ready to be delivered..."
