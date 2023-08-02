#!/bin/bash


# 1) Set KUBECONFIG for spoke
export KUBECONFIG=/root/spoke/zt-sno1/kubeconfig-zt-sno1.yaml


# 2) Set variables
VERSIONS='4.11.44 4.12.23 4.13.5 4.14.0-ec.3'


# 3) Start upgrade procedure
for spoke_version in ${VERSIONS}; do
  echo "Upgrade towards ${spoke_version} started at: $(date)"
  start=$(date)

  # 3.2) pause machine config pools
  oc patch mcp/master --patch '{"spec":{"paused":false}}' --type=merge
  oc patch mcp/worker --patch '{"spec":{"paused":false}}' --type=merge

  # 3.3) trigger upgrade operation
  oc adm upgrade --to="${spoke_version}" --force

  # 3.4) add label to allow upgrade to continue
  oc label mcp/master operator.machineconfiguration.openshift.io/required-for-upgrade-

  # 3.5) watch upgrade procedure
  while true;
  do
    # 3.5.1) watch BMC for node reboots
    node_status=$(curl -sLk -H 'OData-Version: 4.0' -H 'Content-Type: application/json; charset=utf-8' -u <BMC_USER>:<BMC_PASS> 'https://<BMC_ADDRESS>/redfish/v1/Chassis/Self' | jq -r .PowerState)
    if [ "${node_status}" = "Off" ]
    then
      echo "Node started a reboot at ${start}"
    fi

    # 3.5.2) watch CVO for cluster upgrades
    cvo_status=$(oc get clusterversion version --no-headers | awk -v version="${spoke_version}" '{ if($2==version) print "Upgrade finished"; else print}'); echo "${cvo_status}"
    if [ "${cvo_status}" = "Upgrade finished" ]
    then
      stop=$(date)
      break
    fi

    sleep 25
  done
  echo "Upgrade to version ${spoke_version} started at ${start} and finished at ${stop}"

done
