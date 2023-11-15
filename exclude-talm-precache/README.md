# Build the container image

:warning: This work has been based on the work done by @leo8a to obtain the new container images included in a release, the ones currently in use and the proper algorithm to find out what images won't be used during an upgrade.

```
$ podman build . -t quay.io/alosadag/talm-precachingconfig:v4.14 

STEP 1/9: FROM registry.access.redhat.com/ubi9/python-311
STEP 2/9: ENV KUBECONFIG="/tmp/kubeconfig"
--> b16bdc049728
STEP 3/9: COPY kcs.py /usr/bin/kcs.py
--> 8f24217e22ae
STEP 4/9: COPY init.sh /usr/bin/init.sh
--> b92db0488d3b
STEP 5/9: WORKDIR /tmp
--> 99983ad45ccf
STEP 6/9: RUN curl https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz -o /tmp/oc.tgz &&     tar zxvf /tmp/oc.tgz oc &&     chmod u+x /tmp/oc &&     pip install openshift &&     mkdir assets &&     rm -f /tmp/oc.tgz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 60.9M  100 60.9M    0     0  9728k      0  0:00:06  0:00:06 --:--:--  9.9M
oc
Collecting openshift
  Downloading openshift-0.13.2-py3-none-any.whl (18 kB)
Collecting kubernetes>=12.0
  Downloading kubernetes-28.1.0-py2.py3-none-any.whl (1.6 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.6/1.6 MB 6.3 MB/s eta 0:00:00
Collecting python-string-utils
  Downloading python_string_utils-1.0.0-py3-none-any.whl (26 kB)
Collecting six
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting certifi>=14.05.14
  Downloading certifi-2023.7.22-py3-none-any.whl (158 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 158.3/158.3 kB 15.1 MB/s eta 0:00:00
Collecting python-dateutil>=2.5.3
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 kB 14.2 MB/s eta 0:00:00
Collecting pyyaml>=5.4.1
  Downloading PyYAML-6.0.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (757 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 757.7/757.7 kB 5.4 MB/s eta 0:00:00
Collecting google-auth>=1.0.1
  Downloading google_auth-2.23.4-py2.py3-none-any.whl (183 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 183.3/183.3 kB 14.3 MB/s eta 0:00:00
Collecting websocket-client!=0.40.0,!=0.41.*,!=0.42.*,>=0.32.0
  Downloading websocket_client-1.6.4-py3-none-any.whl (57 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 57.3/57.3 kB 82.2 MB/s eta 0:00:00
Collecting requests
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.6/62.6 kB 13.8 MB/s eta 0:00:00
Collecting requests-oauthlib
  Downloading requests_oauthlib-1.3.1-py2.py3-none-any.whl (23 kB)
Collecting oauthlib>=3.2.2
  Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 151.7/151.7 kB 12.2 MB/s eta 0:00:00
Collecting urllib3<2.0,>=1.24.2
  Downloading urllib3-1.26.18-py2.py3-none-any.whl (143 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 143.8/143.8 kB 10.9 MB/s eta 0:00:00
Collecting cachetools<6.0,>=2.0.0
  Downloading cachetools-5.3.2-py3-none-any.whl (9.3 kB)
Collecting pyasn1-modules>=0.2.1
  Downloading pyasn1_modules-0.3.0-py2.py3-none-any.whl (181 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 181.3/181.3 kB 13.2 MB/s eta 0:00:00
Collecting rsa<5,>=3.1.4
  Downloading rsa-4.9-py3-none-any.whl (34 kB)
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.3.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (140 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.3/140.3 kB 15.7 MB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 21.1 MB/s eta 0:00:00
Collecting pyasn1<0.6.0,>=0.4.6
  Downloading pyasn1-0.5.0-py2.py3-none-any.whl (83 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 83.9/83.9 kB 13.7 MB/s eta 0:00:00
Installing collected packages: websocket-client, urllib3, six, pyyaml, python-string-utils, pyasn1, oauthlib, idna, charset-normalizer, certifi, cachetools, rsa, requests, python-dateutil, pyasn1-modules, requests-oauthlib, google-auth, kubernetes, openshift
Successfully installed cachetools-5.3.2 certifi-2023.7.22 charset-normalizer-3.3.2 google-auth-2.23.4 idna-3.4 kubernetes-28.1.0 oauthlib-3.2.2 openshift-0.13.2 pyasn1-0.5.0 pyasn1-modules-0.3.0 python-dateutil-2.8.2 python-string-utils-1.0.0 pyyaml-6.0.1 requests-2.31.0 requests-oauthlib-1.3.1 rsa-4.9 six-1.16.0 urllib3-1.26.18 websocket-client-1.6.4

[notice] A new release of pip available: 22.2.2 -> 23.3.1
[notice] To update, run: pip install --upgrade pip
--> 4a67b4b47afb
STEP 7/9: USER 0
--> bd90ba2e74a7
STEP 8/9: RUN dnf install jq -y &&     dnf clean all  && rm -rf /var/cache/dnf 
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Red Hat Universal Base Image 9 (RPMs) - BaseOS  539 kB/s | 513 kB     00:00    
Red Hat Universal Base Image 9 (RPMs) - AppStre 2.7 MB/s | 1.8 MB     00:00    
Red Hat Universal Base Image 9 (RPMs) - CodeRea 405 kB/s | 190 kB     00:00    
Dependencies resolved.
================================================================================
 Package        Arch        Version             Repository                 Size
================================================================================
Installing:
 jq             x86_64      1.6-15.el9          ubi-9-appstream-rpms      190 k
Installing dependencies:
 oniguruma      x86_64      6.9.6-1.el9.5       ubi-9-appstream-rpms      221 k

Transaction Summary
================================================================================
Install  2 Packages

Total download size: 411 k
Installed size: 1.1 M
Downloading Packages:
(1/2): oniguruma-6.9.6-1.el9.5.x86_64.rpm       115 kB/s | 221 kB     00:01    
(2/2): jq-1.6-15.el9.x86_64.rpm                  68 kB/s | 190 kB     00:02    
--------------------------------------------------------------------------------
Total                                           147 kB/s | 411 kB     00:02     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : oniguruma-6.9.6-1.el9.5.x86_64                         1/2 
  Installing       : jq-1.6-15.el9.x86_64                                   2/2 
  Running scriptlet: jq-1.6-15.el9.x86_64                                   2/2 
  Verifying        : oniguruma-6.9.6-1.el9.5.x86_64                         1/2 
  Verifying        : jq-1.6-15.el9.x86_64                                   2/2 
Installed products updated.

Installed:
  jq-1.6-15.el9.x86_64              oniguruma-6.9.6-1.el9.5.x86_64             

Complete!
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

26 files removed
--> b13211b52ffe
STEP 9/9: ENTRYPOINT ["/bin/bash", "/usr/bin/init.sh"]
COMMIT quay.io/alosadag/talm-precachingconfig:v4.14
--> 5208ba620586
Successfully tagged quay.io/alosadag/talm-precachingconfig:v4.14
5208ba62058671b5835109292f82d8a4000fcc1b25d666f5941eced989dc170d
```

# Usage of the container image

```
$ podman run -it --rm --volume /home/alosadag/Documents/CNF/sno-worker-0/kubeconfig:/tmp/kubeconfig:Z \
  -e TARGET_OCP_RELEASE="4.14.1"   quay.io/alosadag/talm-precachingconfig:v4.14
```

Usage:

* Mount the kubeconfig of the SNO cluster to upgrade into /tmp/kubeconfig.
* Set the TARGET_OCP_RELEASE with the version of OpenShift we want to upgrade to.

See here the number of new images with regards to the current version running on SNO (4.13.19)
```
New images in the payload for the target release

    Number of new release images in release 4.14.1: 8
{'name': 'agent-installer-utils', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:ec5212aed22c20ef374dfceb51581ce151fffef8d1e35075c7358fa0002f5ad0'}
{'name': 'azure-workload-identity-webhook', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:20af431f2c3d4bc9b6828ac1677bab69cb8f7739769e68c78fa2415bd4682b80'}
{'name': 'cluster-olm-operator', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:ff5abf0c8647079e5ebf6c6dd63cd623fc8d680319b058d8be7c25012d3adcbb'}
{'name': 'monitoring-plugin', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c2f070aed882879a890494cc6f378068bbc778ee9ce739aaa3aa777ec2602ecb'}
{'name': 'olm-catalogd', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:549da6da5d787654b1d551def7ee6af171983cdaa8088f6762cac72e8986dfca'}
{'name': 'olm-operator-controller', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:7271427f1a22d082431c8251228e2e6b083b3626506015b31cb5906284aec19b'}
{'name': 'ovn-kubernetes', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:61f8cad4687ec98a750980dcd1443e158778016a6dfd2dd30864b1c3e0d57409'}
{'name': 'ovn-kubernetes-microshift', 'digest': 'quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:1b23e41d96dff46945b9491eaa7d21e8940ed01bc7c1bd055137b7234152067f'}
```

See the information with regards the images that are included in both releases:
```
Images in the payload but not running in the cluster
    Total number of release images for the 4.13.19 version: 183
    Total number of release images for the 4.14.1 version 189
```

Below the list of images that can excluded in the precacheConfig custom resources:

```
List of release images that DO NOT NEED to precache for the upgrade 128

agent-installer-api-server
agent-installer-csr-approver
agent-installer-node-agent
agent-installer-orchestrator
alibaba-cloud-controller-manager
alibaba-cloud-csi-driver
alibaba-disk-csi-driver-operator
alibaba-machine-controllers
apiserver-network-proxy
aws-cloud-controller-manager
aws-cluster-api-controllers
aws-ebs-csi-driver
aws-ebs-csi-driver-operator
aws-machine-controllers
aws-pod-identity-webhook
azure-cloud-controller-manager
azure-cloud-node-manager
azure-cluster-api-controllers
azure-disk-csi-driver
azure-disk-csi-driver-operator
azure-file-csi-driver
azure-file-csi-driver-operator
azure-machine-controllers
baremetal-installer
baremetal-machine-controllers
baremetal-operator
baremetal-runtimecfg
cli-artifacts
cloud-network-config-controller
cluster-autoscaler
cluster-baremetal-operator
cluster-bootstrap
cluster-capi-controllers
cluster-capi-operator
cluster-csi-snapshot-controller-operator
cluster-kube-cluster-api-operator
cluster-platform-operators-manager
cluster-samples-operator
cluster-storage-operator
cluster-update-keys
cluster-version-operator
configmap-reloader
console
console-operator
container-networking-plugins
csi-driver-manila
csi-driver-manila-operator
csi-driver-nfs
csi-driver-shared-resource
csi-driver-shared-resource-operator
csi-driver-shared-resource-webhook
csi-external-attacher
csi-external-provisioner
csi-external-resizer
csi-external-snapshotter
csi-livenessprobe
csi-node-driver-registrar
csi-snapshot-controller
csi-snapshot-validation-webhook
deployer
docker-builder
driver-toolkit
egress-router-cni
gcp-cloud-controller-manager
gcp-cluster-api-controllers
gcp-machine-controllers
gcp-pd-csi-driver
gcp-pd-csi-driver-operator
hypershift
ibm-cloud-controller-manager
ibm-vpc-block-csi-driver
ibm-vpc-block-csi-driver-operator
ibm-vpc-node-label-updater
ibmcloud-cluster-api-controllers
ibmcloud-machine-controllers
insights-operator
installer
installer-artifacts
ironic
ironic-agent
ironic-machine-os-downloader
ironic-static-ip-manager
keepalived-ipfailover
kube-proxy
kubevirt-cloud-controller-manager
kubevirt-csi-driver
kuryr-cni
kuryr-controller
libvirt-machine-controllers
machine-image-customization-controller
machine-os-content
machine-os-images
multus-networkpolicy
multus-route-override-cni
multus-whereabouts-ipam-cni
must-gather
network-interface-bond-cni
network-tools
nutanix-cloud-controller-manager
nutanix-machine-controllers
oc-mirror
olm-rukpak
openstack-cinder-csi-driver
openstack-cinder-csi-driver-operator
openstack-cloud-controller-manager
openstack-machine-api-provider
operator-registry
ovirt-csi-driver
ovirt-csi-driver-operator
ovirt-machine-controllers
pod
powervs-block-csi-driver
powervs-block-csi-driver-operator
powervs-cloud-controller-manager
powervs-machine-controllers
prometheus-alertmanager
rhel-coreos
rhel-coreos-extensions
sdn
telemeter
tests
tools
vsphere-cloud-controller-manager
vsphere-cluster-api-controllers
vsphere-csi-driver
vsphere-csi-driver-operator
vsphere-csi-driver-syncer
vsphere-problem-detector
```
