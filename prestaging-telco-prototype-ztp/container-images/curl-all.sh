#!/bin/bash

HTTP_IP=$1
FOLDER=$2
OCP_RELEASE="4.10.3"
curl_artifacts ()
{
  HTTPD=$1
  LOCATION=$2

  mkdir -p ${LOCATION}

  for file in $(curl -s http://${1} | grep href | sed 's/.*href="//' | sed 's/".*//' | grep '^[0-9a-zA-Z].*'); do
      curl -s http://${1}/$file -o $LOCATION/$file
  done
}

mkdir -p ${FOLDER}/ai-images
mkdir -p ${FOLDER}/ocp-images
curl_artifacts ${HTTP_IP} ${FOLDER}
curl_artifacts ${HTTP_IP}/images-${OCP_RELEASE}/ ${FOLDER}/ai-images
curl_artifacts ${HTTP_IP}/ocp-images-${OCP_RELEASE}/ ${FOLDER}/ocp-images
