#!/bin/bash

HTTP_IP=$1
FOLDER=$2

curl_artifacts ()
{
  HTTPD=$1
  LOCATION=$2

  mkdir -p ${LOCATION}

  for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*'); do
      curl -s http://${1}/$file -o $LOCATION/$file
  done
}

mkdir -p ${FOLDER}/images-4.10.3
mkdir -p ${FOLDER}/ocp-images-4.10.3
curl_artifacts ${HTTP_IP} ${FOLDER}
curl_artifacts ${HTTP_IP}/images-4.10.3/ ${FOLDER}/images-4.10.3
curl_artifacts ${HTTP_IP}/ocp-images-4.10.3/ ${FOLDER}/ocp-images-4.10.3
