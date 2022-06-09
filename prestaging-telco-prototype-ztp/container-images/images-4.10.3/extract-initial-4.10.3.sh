#!/bin/bash

FOLDER="${FOLDER:-$(pwd)}"
OCP_RELEASE_LIST="${OCP_RELEASE_LIST:-initial-images-4.10.3.txt}"

pushd $FOLDER

total_copies=$(sort -u $FOLDER/$OCP_RELEASE_LIST | wc -l)  # Required to keep track of the pull task vs total
current_copy=1

while read -r line;
do
  uri=$(echo "$line" | awk '{print$1}')
  #tar=$(echo "$line" | awk '{print$2}')
  podman image exists $uri
  if [[ $? -eq 0 ]]; then
      echo "Skipping existing image $tar"
      current_copy=$((current_copy + 1))
      continue
  fi
  tar=$(echo "$uri" |  rev | cut -d "/" -f1 | rev | tr ":" "_")
  tar zxvf ${tar}.tgz
  if [ $? -eq 0 ]; then rm -f ${tar}.gz; fi
  echo "Copying ${uri} [${current_copy}/${total_copies}]"
  skopeo copy dir://$(pwd)/${tar} containers-storage:${uri}
  if [ $? -eq 0 ]; then rm -rf ${tar}; current_copy=$((current_copy + 1)); fi
done < initial-images-4.10.3.txt

# workaround while https://github.com/openshift/assisted-service/pull/3546
#cp /var/mnt/modified-rhcos-4.10.3-x86_64-metal.x86_64.raw.gz /var/tmp/.

exit 0
