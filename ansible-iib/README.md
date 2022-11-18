# Information

This is a simple ansible playbook that will allow you to create an operator index image including the last version of the operators included in the defaults/main.yaml file.

> :warning: First, you need koji-brew installed on the server where you will make the index image. Also, do not forget to set up the default vars to your needs.

```
$ sudo dnf install http://download.eng.bos.redhat.com/brewroot/packages/brewkoji/1.30/1.fc36eng/noarch/brewkoji-1.30-1.fc36eng.noarch.rpm http://download.eng.bos.redhat.com/brewroot/packages/brewkoji/1.30/1.fc36eng/noarch/python3-brewkoji-1.30-1.fc36eng.noarch.rpm
```

Then, we can just run the playbook then:

```
$ ansible-playbook main.yaml -K
BECOME password: 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [localhost] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Include vars] **************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Add bundle to index images] ************************************************************************************************************************************************************************************************************
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=ptp-operator)
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=sriov-network-operator)
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=local-storage-operator)
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=cluster-logging)
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=bare-metal-event-relay)
included: /home/alosadag/SYSENG/CNF/cnf-git/openshift-telco/ansible-iib/tasks/add_bundle.yaml for localhost => (item=odf-lvm-operator)

TASK [Retrieve ptp-operator package build from brew] *****************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve ptp-operator bundle image from package build] *********************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add ptp-operator bundle to index image] ************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve sriov-network-operator package build from brew] *******************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve sriov-network-operator bundle image from package build] ***********************************************************************************************************************************************************************
changed: [localhost]

TASK [Add sriov-network-operator bundle to index image] **************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve local-storage-operator package build from brew] *******************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve local-storage-operator bundle image from package build] ***********************************************************************************************************************************************************************
changed: [localhost]

TASK [Add local-storage-operator bundle to index image] **************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve cluster-logging package build from brew] **************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve cluster-logging bundle image from package build] ******************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add cluster-logging bundle to index image] *********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve bare-metal-event-relay package build from brew] *******************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve bare-metal-event-relay bundle image from package build] ***********************************************************************************************************************************************************************
changed: [localhost]

TASK [Add bare-metal-event-relay bundle to index image] **************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve odf-lvm-operator package build from brew] *************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Retrieve odf-lvm-operator bundle image from package build] *****************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add odf-lvm-operator bundle to index image] ********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Push index image to registry] **********************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
localhost                  : ok=32   changed=24   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

# Verification 

Let’s verify the index image by querying using grpcurl:

```
$ podman run -d -p50055:50051 -it quay.io/alosadag/redhat-operator-index:v4.12
```

```
$ grpcurl -plaintext localhost:50055 api.Registry.ListBundles | jq ' .packageName, .channelName, .bundlePath, .version' 

"bare-metal-event-relay"
"4.12"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift4-bare-metal-event-relay-operator-bundle-container-rhel8@sha256:e581e3ad39129514fce45d7e85ff1ab268decd744fe27e5f4e8bdf9cc30c3923"
"4.12.0"
"bare-metal-event-relay"
"stable"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift4-bare-metal-event-relay-operator-bundle-container-rhel8@sha256:e581e3ad39129514fce45d7e85ff1ab268decd744fe27e5f4e8bdf9cc30c3923"
"4.12.0"
"cluster-logging"
"stable"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift-logging-cluster-logging-operator-bundle@sha256:549fc3323c7ffbe12b1d3f5d150cc4858649f4731573f3f24fd38c1e4fe5c7b8"
"5.5.5"
"local-storage-operator"
"stable"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift-ose-local-storage-operator-bundle@sha256:2f7db73010b3cb62479c514c9747447acb09ee6209bcd6cdfda478dafa6b4571"
"4.12.0-202211081106"
"odf-lvm-operator"
"stable-4.12"
"registry-proxy.engineering.redhat.com/rh-osbs/odf4-odf-lvm-operator-bundle@sha256:86d7859805e65f400cfb6c10d743fb96365be8ecbda68fe4c79926e9d1286173"
"4.12.0-114.stable"
"ptp-operator"
"stable"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift-ose-ptp-operator-bundle@sha256:efe6ceeec0e912fac3590dfbc4b0057077db86760480fa44bb0d715b2f80effc"
"4.12.0-202211151637"
"sriov-network-operator"
"4.12"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift-ose-sriov-network-operator-bundle@sha256:0f464ac7af62d53000ca3c0368ae72dab848a31db0f00555b8054c276ac91655"
"4.12.0-202211181156"
"sriov-network-operator"
"stable"
"registry-proxy.engineering.redhat.com/rh-osbs/openshift-ose-sriov-network-operator-bundle@sha256:0f464ac7af62d53000ca3c0368ae72dab848a31db0f00555b8054c276ac91655"
"4.12.0-202211181156"
```

