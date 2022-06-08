#!/bin/bash

while read -r line;
do
  uri=$(echo "$line" | awk '{print$1}')
  #tar=$(echo "$line" | awk '{print$2}')
  podman image exists $uri
  if [[ $? -eq 0 ]]; then
      echo "Skipping existing image $tar"
      continue
  fi
  tar=$(echo "$uri" |  rev | cut -d "/" -f1 | rev | tr ":" "_")
  tar zxvf ${tar}.tgz
  if [ $? -eq 0 ]; then rm -f ${tar}.gz; fi
  skopeo copy dir://$(pwd)/${tar} containers-storage:${uri}
done < initial-images-4.10.3.txt

# workaround while https://github.com/openshift/assisted-service/pull/3546
#cp /var/mnt/modified-rhcos-4.10.3-x86_64-metal.x86_64.raw.gz /var/tmp/.

exit 0
