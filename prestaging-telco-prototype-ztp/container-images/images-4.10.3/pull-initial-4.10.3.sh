#!/bin/bash

PULL_SECRET_PATH="/home/kni/ipi-install-cnf20/pull-secret.json"
FOLDER="${FOLDER:-$(pwd)}"
OCP_RELEASE_LIST="${OCP_RELEASE_LIST:-initial-images-4.10.3.txt}"

rm -f $FOLDER/*.tgz
pushd $FOLDER
echo "Pulling ${uri} [${current_pull}/${total_pulls}]"if [ $? -eq 0 ]; then rm -rf ${tar}; current_pull=$((current_pull + 1)); fi
total_pulls=$(sort -u $FOLDER/$OCP_RELEASE_LIST | wc -l)  # Required to keep track of the pull task vs total
current_pull=1

while read -r line;
do
  uri=$(echo "$line" | awk '{print$1}')
  #tar=$(echo "$uri" |  cut -d ":" -f2)
  tar=$(echo "$uri" |  rev | cut -d "/" -f1 | rev | tr ":" "_")
  echo "Pulling ${uri} [${current_pull}/${total_pulls}]"
  skopeo copy docker://${uri} --authfile=${PULL_SECRET_PATH} dir://$(pwd)/${tar} -q  
  tar zcvf ${tar}.tgz ${tar}
  #mv ${tar}.gz $FOLDER/.
  if [ $? -eq 0 ]; then rm -rf ${tar}; current_pull=$((current_pull + 1)); fi
done < ${OCP_RELEASE_LIST}

popd #back to our directory
