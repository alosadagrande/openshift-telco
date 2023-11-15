#!/bin/bash
cd /tmp

export OCP_RELEASE=$(./oc get clusterversion -ojson | jq -r .items[0].status.history[0].version)
unset KUBECONFIG
./oc adm release info ${OCP_RELEASE} -o json | jq -r '[.references.spec.tags[] | .name as $name | .from.name as $digest | {$name,$digest}]' > ./assets/release_payload.json
./oc adm release info ${TARGET_OCP_RELEASE} -o json | jq -r '[.references.spec.tags[] | .name as $name | .from.name as $digest | {$name,$digest}]' > ./assets/target_release_payload.json

export KUBECONFIG=/tmp/kubeconfig
python /usr/bin/kcs.py $OCP_RELEASE $TARGET_OCP_RELEASE
