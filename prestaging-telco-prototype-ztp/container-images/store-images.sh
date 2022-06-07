#!/bin/bash

cd /media/container-images

echo "Copying factory RH assisted installer agent image locally"
tar zxvf rhai-tech-preview.tgz
skopeo copy dir:/media/container-images/rhai-tech-preview --authfile=/home/alosadag/pull-secret.json containers-storage:registry.redhat.io/rhai-tech-preview/assisted-installer-agent-rhel8:v1.0.0-89
rm -rf rhai-tech-preview
