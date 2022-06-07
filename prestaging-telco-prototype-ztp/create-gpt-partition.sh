#!/bin/bash

sgdisk -n 1:150000000 /dev/vdb -g
sgdisk -c:1:data /dev/vdb
mkfs.xfs /dev/vdb1
mount /dev/vdb1 /var/mnt/


