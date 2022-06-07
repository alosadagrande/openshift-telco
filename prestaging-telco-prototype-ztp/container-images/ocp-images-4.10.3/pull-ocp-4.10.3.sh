#!/bin/bash

PULL_SECRET_PATH="/home/kni/ipi-install-cnf20/pull-secret.json"
FOLDER=$(pwd)

rm -f $FOLDER/*.tgz

while read -r line;
do
  uri=$(echo "$line" | awk '{print$1}')
  tar=$(echo "$uri" |  cut -d ":" -f2)
  skopeo copy docker://${uri} --authfile=${PULL_SECRET_PATH} dir://${FOLDER}/${tar}
  tar zcvf ${tar}.tgz ${tar}
  if [ $? -eq 0 ]; then rm -rf ${FOLDER}/${tar}; fi
done < ocp-images-4.10.3.txt 

