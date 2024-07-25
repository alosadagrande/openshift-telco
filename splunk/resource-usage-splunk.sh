#!/bin/bash

SNO_HOSTNAME="${1:-zt-sno3}"
NON_RESERVED_CORES="2-31,34-63"
NUMBER_CORES=64

#* NODE CPU AVG
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=100/64 * sum(1 - rate(node_cpu_seconds_total{mode="idle"}[30m])) by (instance)' | jq -r '.data.result[] | [.value[0], .value[1], .metric.instance] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_avg_node_noidle_cpu_percentage.txt
#oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=100/64 * max(1 - rate(node_cpu_seconds_total{mode="idle"}[30m])) by (instance)' | jq -r '.data.result[] | [.value[0], .value[1], .metric.instance] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_max_node_noidle_cpu_percentage.txt

#* NODE MEMORY
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=100 * (1 - (sum(avg_over_time(node_memory_MemAvailable_bytes[30m]))/sum(avg_over_time(node_memory_MemTotal_bytes[30m]))))' | jq -r '.data.result[] | [.value[0], .value[1]] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_node_percentage_free_memory.txt

# CONTAINER CPU USAGE SLICES
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc((rate(container_cpu_usage_seconds_total{id=~"/system.slice/.+"}[30m])))' | jq -r '.data.result[] | [.value[0], .value[1], .metric.cpu, .metric.service, .metric.id] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_system-slice-cpu.txt
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc((rate(container_cpu_usage_seconds_total{id=~"/ovs.slice/.+"}[30m])))' | jq -r '.data.result[] | [.value[0], .value[1], .metric.cpu, .metric.service, .metric.id] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_ovs-slice-cpu.txt

# CONTAINER CPU USAGE
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(avg_over_time(pod:container_cpu_usage:sum[30m]))' | jq -r '.data.result[] | [.value[0], .value[1], .metric.namespace, .metric.pod] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_pod-cpu.txt

oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(rate(container_cpu_cfs_throttled_periods_total[30m]))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.service, .metric.endpoint, .metric.id, .metric.namespace, .metric.pod, .metric.container] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_container_cpu_cfs_throttled_periods_total.txt

## NODE RESERVED CPU USAGE Replace 0|1|32|33 with the reserved cpus
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=rate(node_cpu_seconds_total{cpu=~"0|1|32|33"}[30m])' | jq -r '.data.result[] | [.value[0], .value[1], .metric.cpu, .metric.endpoint, .metric.mode, .metric.service, .metric.namespace, .metric.pod, .metric.container] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_reserved-cpu-usage.txt

# Container Memory
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(sum(container_memory_working_set_bytes{cluster="",container!=""}) by (pod))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.pod] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_memory-working-set-bytes.txt
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(sum(container_memory_rss{cluster="",container!=""}) by (pod))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.pod] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_memory-rss-bytes.txt

# NODE Networking
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(rate(node_network_receive_bytes_total[30m]))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.device, .metric.endpoint, .metric.service, .metric.namespace, .metric.pod, .metric.container] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_node-network-receive-bytes-total.txt
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(rate(node_network_transmit_bytes_total[30m]))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.device, .metric.endpoint, .metric.service, .metric.namespace, .metric.pod, .metric.container] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_node-network-transmit-bytes-total.txt

oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sum(irate(node_network_receive_bytes_total[30m])*8/(1024*1024)) by (instance)' |jq -r '.data.result[] | [.value[0], .value[1], .metric.instance] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_node-network-receive-mbps-total.txt
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sum(irate(node_network_transmit_bytes_total[30m])*8/(1024*1024)) by (instance)' |jq -r '.data.result[] | [.value[0], .value[1], .metric.instance] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_node-network-transmit-mbps-total.txt


# CONTAINER Networking
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(rate(container_network_transmit_bytes_total{interface="eth0"}[30m]))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.name, .metric.id, .metric.interface, .metric.service, .metric.namespace, .metric.pod, .metric.container] | @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_container-network-transmit-bytes-total.txt
oc --kubeconfig=/root/${SNO_HOSTNAME}/kubeconfig rsh -n openshift-monitoring prometheus-k8s-0 curl -ks 'http://localhost:9090/api/v1/query' --data-urlencode 'query=sort_desc(rate(container_network_receive_bytes_total{interface="eth0"}[30m]))' |jq -r '.data.result[] | [.value[0], .value[1], .metric.name, .metric.id, .metric.interface, .metric.service, .metric.namespace, .metric.pod, .metric.container]| @tsv' | sed 's/\t/ /g' >> ${SNO_HOSTNAME}_container-network-receive-bytes-total.txt

# On the SNO
#Collect after the above
ssh core@${SNO_HOSTNAME} sudo cat /proc/meminfo > ${SNO_HOSTNAME}_proc_meminfo.txt
#taskset -c ${NON_RESERVED_CORES} top -b -1 -d 5 -n 360 -i  > /home/core/top.out
