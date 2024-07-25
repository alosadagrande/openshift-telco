#!/bin/bash

FILE=$1.json
TARGET=$1
CLIENT_TOKEN=$2
curl --insecure --silent --header "Authorization: Bearer $CLIENT_TOKEN" 'https://oran-o2ims.apps.hub0.inbound-int.se-lab.eng.rdu2.dc.redhat.com/o2ims-infrastructureInventory/v1/deploymentManagers/'${TARGET} | jq > ${FILE}

user=$(cat $FILE | jq .extensions.profileData.admin_user)
cluster_ca_cert=$(cat $FILE | jq .extensions.profileData.cluster_ca_cert)
cluster_api_endpoint=$(cat $FILE | jq .extensions.profileData.cluster_api_endpoint)
admin_client_cert=$(cat $FILE | jq .extensions.profileData.admin_client_cert)
admin_client_key=$(cat $FILE | jq .extensions.profileData.admin_client_key)
rm -f $FILE

echo -n "
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $cluster_ca_cert 
    server: $cluster_api_endpoint
  name: cluster
contexts:
- context:
    cluster: cluster
    namespace: default
    user: admin
  name: admin
current-context: $user
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: $admin_client_cert 
    client-key-data: $admin_client_key 
" > ${TARGET}.kubeconfig
