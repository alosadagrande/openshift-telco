#!/bin/bash

OCP_VERSION=$1
export pull_secret_path=/home/kni/ipi-install-cnf20/pull-secret.json

image=$(oc adm release info $OCP_VERSION -o json | jq .image | tr -d '"')
./release $image
