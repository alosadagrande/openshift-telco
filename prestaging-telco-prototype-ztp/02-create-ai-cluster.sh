#!/bin/bash

#export AI_URL=https://assisted-installer.apps.cnf20.cloud.lab.eng.bos.redhat.com
export AI_URL=http://edge-11.edge.lab.eng.rdu2.redhat.com:6008
export AI_HOST=http://edge-11.edge.lab.eng.rdu2.redhat.com
CLUSTER_NAME=virt01
CLUSTER_NODES=1

aicli create cluster -P pull_secret=/home/alosadag/pull-secret.json -P base_dns_domain=eko4.cloud.lab.eng.bos.redhat.com -P ssh_public_key="$(cat ~/.ssh/id_rsa.pub)" ${CLUSTER_NAME} -P network_type=OVNKubernetes -P openshift_version=4.10.3 -P sno=True -P minimal=True

#Get infra-env-id
INFRAENVID=$(aicli list infraenv | tail -2 | head -1 | awk -F "|" '{print$3}' | tr -d ' ')
echo "This is the $INFRAENVID...."

curl -X PATCH "${AI_URL}/api/assisted-install/v2/infra-envs/${INFRAENVID}" -H "accept: application/json" -H "Content-Type: application/json" -d @ignition-files/proto.patch

if [ $? -eq 0 ]; then
 echo -e "\e[92m[OK] ISO is available to download. Run aicli download iso <cluster> or wget"
else
 echo -e "\e[91m[ERROR]: An error happened while creating the discovery ISO"
 exit 1
fi

echo "Validating discovery ignition..."
curl "${AI_URL}/api/assisted-install/v2/infra-envs/${INFRAENVID}/downloads/files?file_name=discovery.ign" -H "accept: application/octet-stream" | jq .

read -p "Press enter to continue"

echo "Wait until hosts are ready in Assisted Installer"
while true; do
	hosts_ready=$(aicli list hosts | grep $CLUSTER_NAME | grep "insufficient" | wc -l)
        if [ "$hosts_ready" -eq "$CLUSTER_NODES" ]; then
		break
	fi
	echo "Waiting 10s more..."
	sleep 10
done

#Get host name
HOST=$(aicli list host | grep $CLUSTER_NAME | tail -2 | head -1 | awk -F "|" '{print$2}' | tr -d ' ')
HOSTID=$(aicli list host | grep $CLUSTER_NAME | tail -2 | head -1 | awk -F "|" '{print$3}' | tr -d ' ')
echo "This is the HOST: $HOST and HOSTID: $HOSTID values"

aicli update host ${HOST} -P extra_args="--save-partlabel data --copy-network" #--image-file=/var/tmp/modified-rhcos-4.10.3-x86_64-metal.x86_64.raw.gz
curl -X PATCH "${AI_HOST}:6000/api/assisted-install/v2/infra-envs/${INFRAENVID}/hosts/${HOSTID}/ignition" -H "accept: application/json" -H "Content-Type: application/json" -d @ignition-files/ocp.patch
echo "Validating configuration..."
aicli info host $HOST
#echo "Checking host-ignition-params...."
#curl "${AI_HOST}:6000/api/assisted-install/v2/infra-envs/${INFRAENVID}/hosts/${HOSTID}" -H "accept: application/json" -H "Content-Type: application/json" | jq . | grep ignition

read -p "Press enter to continue"

aicli update cluster ${CLUSTER_NAME} -P machine_networks=[10.19.136.0/21] 
echo -e "\e[0m Printing cluster information..."
echo "Validating cluster info...."
aicli info cluster $CLUSTER_NAME

echo "Wait until cluster is ready to be installed"
while true; do
        cluster_ready=$(aicli list cluster | grep $CLUSTER_NAME | cut -d "|" -f4 | tr -d ' ')
        if [ $cluster_ready == "ready" ]; then
                break
        fi
        echo "Waiting 10s more..."
        sleep 10
done

aicli start cluster $CLUSTER_NAME

echo "Cluster installation started..."

while true; do
        cluster_installed=$(aicli list cluster | grep $CLUSTER_NAME | cut -d "|" -f4 | tr -d ' ')
        if [ $cluster_installed == "installed" ]; then
                break
        fi
        aicli list cluster
        sleep 30
        aicli list hosts
        echo "Waiting 30s......."
done

#mkdir -p $CLUSTER_NAME/auth
#aicli download kubeadmin-password --path $HOME/$CLUSTER_NAME/auth cnf21
mkdir -p /home/alosadag/Documents/CNF/sno-eko4/${CLUSTER_NAME}
aicli download kubeconfig --path /home/alosadag/Documents/CNF/sno-eko4/${CLUSTER_NAME}/ $CLUSTER_NAME
#aicli download kubeconfig --path $HOME/$CLUSTER_NAME/auth cnf21

echo "Installation completed. You can start using your new cluster. Credentials can be found in $HOME/Documents/CNF/sno-eko4/$CLUSTER_NAME/auth/kubeconfig.$CLUSTER_NAME"

command -v oc >/dev/null 2>&1 || { command -v kubectl >/dev/null 2>&1 || { echo "kubectl and oc are not installed. Install them to manage the new cluster"; exit 1; }; }
export KUBECONFIG=$HOME/Documents/CNF/sno-eko4/$CLUSTER_NAME/kubeconfig.$CLUSTER_NAME

oc get nodes,clusterversion


