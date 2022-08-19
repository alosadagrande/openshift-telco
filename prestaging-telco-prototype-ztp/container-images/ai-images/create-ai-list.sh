#!/bin/bash

FOLDER="${FOLDER:-$(pwd)}"
OCP_RELEASE="${OCP_RELEASE-4.11.0}"
REGISTRY_URL="quay.io/openshift-release-dev/ocp-v4.0-art-dev"
IMAGES_LIST=auto-initial-images-${OCP_RELEASE}.txt

##Default ones
echo "quay.io/openshift-release-dev/ocp-release:${OCP_RELEASE}-x86_64" > $IMAGES_LIST
echo "registry.redhat.io/multicluster-engine/assisted-installer-agent-rhel8@sha256:54f7376e521a3b22ddeef63623fc7256addf62a9323fa004c7f48efa7388fe39" >> $IMAGES_LIST
echo "registry.redhat.io/multicluster-engine/assisted-installer-rhel8@sha256:3ea0582b14e78714b229ad381911256a397e0f07a91f5102667e2ccefe7e7f7f" >> $IMAGES_LIST
echo "quay.io/alosadag/troubleshoot:latest" >> $IMAGES_LIST

#oc adm release once
oc adm release info 4.11.0 > release-info-${OCP_RELEASE}.txt

for operator in must-gather hyperkube cloud-credential-operator cluster-policy-controller pod cluster-config-operator cluster-etcd-operator cluster-kube-controller-manager-operator cluster-kube-scheduler-operator machine-config-operator etcd cluster-bootstrap cluster-ingress-operator cluster-kube-apiserver-operator;
do
  container=$(grep "${operator} " release-info-${OCP_RELEASE}.txt | awk '{print$2}')
  echo "${REGISTRY_URL}@${container}" >> $IMAGES_LIST

done
#clear
rm -f release-info-${OCP_RELEASE}.txt

