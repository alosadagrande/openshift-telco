# oc-mirror plugin

> :warning: At the time being, oc-mirror needs to be compiled since there is no binary available yet at the [upstream repository](https://github.com/openshift/oc-mirror). I recommend to run hack/build.sh and copy the binary to /usr/local/bin

This folder contains an imageset config file to mirror OCP releases and telco specific operators into a disconnected or at least a different registry than the official one.

```
$ [root@fx2-1a oc-mirror]# oc-mirror --config imageset-config-fx2-1a-operators.yaml docker://fx2-1a.cloud.lab.eng.bos.redhat.com:8443 --dest-skip-tls
INFO Checking push permissions for fx2-1a.cloud.lab.eng.bos.redhat.com:8443 
INFO Found: oc-mirror-workspace/src/publish       
INFO Found: oc-mirror-workspace/src/v2            
INFO Found: oc-mirror-workspace/src/charts        
INFO Planning download for requested release 4.9.12 
INFO Planning download for requested release 4.9.19 
INFO Planning download for requested release 4.9.21 
WARN[0028] DEPRECATION NOTICE:
Sqlite-based catalogs and their related subcommands are deprecated. Support for
them will be removed in a future release. Please migrate your catalog workflows
to the new file-based catalog format. 
wrote mirroring manifests to oc-mirror-workspace/operators.1645699748/manifests-redhat-operator-index

To upload local images to a registry, run:

	oc adm catalog mirror file://redhat/redhat-operator-index:v4.9 REGISTRY/REPOSITORY
wrote mirroring manifests to oc-mirror-workspace/operators.1645699748/manifests-certified-operator-index

To upload local images to a registry, run:

	oc adm catalog mirror file://redhat/certified-operator-index:v4.9 REGISTRY/REPOSITORY
WARNING bundle : pinning related image quay.io/openshift-hive/hive:v1.1.10 to digest 
WARNING bundle : pinning related image quay.io/openshift-hive/hive:v1.1.11 to digest 
...

sha256:66bf4dc3d0a3f0559c48d7dc7b9b45af7c90e5b6be704421362645d225c09cf8 fx2-1a.cloud.lab.eng.bos.redhat.com:8443/openshift/release:4.9.12-x86_64-azure-cloud-controller-manager
info: Mirroring completed in 7m50.83s (51.26MB/s)
INFO trying next host - response was http.StatusNotFound  host=fx2-1a.cloud.lab.eng.bos.redhat.com:8443
INFO Catalog image "fx2-1a.cloud.lab.eng.bos.redhat.com:8443/redhat/certified-operator-index:v4.9" not found, using new file-based catalog 
INFO trying next host - response was http.StatusNotFound  host=fx2-1a.cloud.lab.eng.bos.redhat.com:8443
INFO Catalog image "fx2-1a.cloud.lab.eng.bos.redhat.com:8443/redhat/community-operator-index:v4.9" not found, using new file-based catalog 
INFO trying next host - response was http.StatusNotFound  host=fx2-1a.cloud.lab.eng.bos.redhat.com:8443
INFO Catalog image "fx2-1a.cloud.lab.eng.bos.redhat.com:8443/redhat/redhat-operator-index:v4.9" not found, using new file-based catalog 
INFO Wrote CatalogSource manifests to oc-mirror-workspace/results-1645700434 
INFO Wrote ICSP manifests to oc-mirror-workspace/results-1645700434 
```
