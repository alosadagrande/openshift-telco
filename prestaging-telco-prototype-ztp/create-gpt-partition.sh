#!/bin/bash

#4.10.3 is 33GB worth of artifacts
sgdisk -n 1:120000000 /dev/vdb -g
sgdisk -c:1:data /dev/vdb
mkfs.xfs /dev/vdb1
mount /dev/vdb1 /var/mnt/


