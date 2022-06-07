#!/bin/bash

while read -r line;
do
  uri=$(echo "$line" | awk '{print$1}')
  tar=$(echo "$line" | awk '{print$2}')
  podman image exists $uri
  if [[ $? -eq 0 ]]; then
      echo "Skipping existing image $tar"
      continue
  fi
  tar zxvf ${tar}.tgz
  if [ $? -eq 0 ]; then rm -f ${tar}.gz; fi
  skopeo copy dir:/$(pwd)/${tar} containers-storage:${uri}
done < initial-images-4.10.3.txt

# need to improve the exit codes - for prototype is enough
exit 0
