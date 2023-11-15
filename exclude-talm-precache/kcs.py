import yaml
import json
import sys
from kubernetes import client, config
from openshift.dynamic import DynamicClient

OCP_RELEASE=sys.argv[1]
TARGET_OCP_RELEASE=sys.argv[2]
k8s_client = config.new_client_from_config()
dyn_client = DynamicClient(k8s_client)

# (2.1) GET current payload in use running on the cluster
def get_payload_in_use():
    container_images = []

    pods_list = dyn_client.resources.get(api_version='v1', kind='Pod').get()
    for pod in pods_list.items:
        for container in pod.spec.containers:
            container_images.append({"name": container.name,
                                     "digest": container.image})
    return container_images


# (2.2) GET payload for current OCP version
#oc adm release info ${OCP_RELEASE} -o json | jq -r '[.references.spec.tags[] | .name as $name | .from.name as $digest | {$name,$digest}]' > ./assets/release_payload_${OCP_RELEASE}.json


# (2.3) GET payload for TARGET_OCP_RELEASE='4.11.10' version
#oc adm release info ${TARGET_OCP_RELEASE} -o json | jq -r '[.references.spec.tags[] | .name as $name | .from.name as $digest | {$name,$digest}]' > ./assets/release_payload_${TARGET_OCP_RELEASE}.json

# (3.1) COMPUTE payload overhead for current release (Python function)
# return an array of images that are not used in the cluster but are in the ocp release payload
def compute_overhead(payload_in_cluster, payload_full_release, verbose=False):
    print(f"    Total number of release images for the {OCP_RELEASE} version:", len(payload_full_release))

    for cluster_image in payload_in_cluster:
        for image_ in payload_full_release:
            if cluster_image['digest'] == image_['digest']:
                payload_full_release.remove(image_)

    if verbose:
        print(f"    Number of release images NOT USED in this cluster:", len(payload_full_release))
        for entry in payload_full_release:
            print(entry)

    return payload_full_release


# (3.2) COMPUTE new images for target release (Python function)

def compute_new_images(payload_full_release, target_payload_full_release,verbose=False):
    new_payload_images = []
    target_payload_names = [target_image["name"] for target_image in target_payload_full_release]

    for payload_image in payload_full_release:
        if payload_image["name"] not in target_payload_names:
            new_payload_images.append(payload_image)

    if verbose:
        print(f"\n    Number of new release images in release {TARGET_OCP_RELEASE}:", len(new_payload_images))
        for entry in new_payload_images:
            print(entry)

    return new_payload_images


# (4) ESTIMATE payload overhead for target release (Python function)

def estimate_overhead(payload_not_used, target_payload_full_release, extra_images, verbose=False):
    target_payload_not_used = []
    payload_not_used_names = [image["name"] for image in payload_not_used]
    extra_image_names = [extra_image["name"] for extra_image in extra_images]

    print(f"    Total number of release images for the {TARGET_OCP_RELEASE} version", len(target_payload_full_release))
    for target_image in target_payload_full_release:
        if target_image['name'] not in payload_not_used_names or target_image['name'] in extra_image_names:
            target_payload_not_used.append(target_image)

    if verbose:
        print(f"    List of release images that WILL NOT be used after an upgrade", len(target_payload_not_used))
        for image in target_payload_not_used:
            print(image['digest'])

    return target_payload_not_used

def target_exclude_precache(current_images_not_used,target_payload_full_release,verbose=False):
    target_payload_no_precache = []
    payload_not_used_names = [image["name"] for image in current_images_not_used]

    print(f"    Total number of release images for the {TARGET_OCP_RELEASE} version", len(target_payload_full_release))
    for target_image in target_payload_full_release:
        if target_image['name'] in payload_not_used_names:
            target_payload_no_precache.append(target_image)

    if verbose:
        print(f"    List of release images that DO NOT NEED to precache for the upgrade", len(target_payload_no_precache))
        for image in target_payload_no_precache:
            print(image['name'])

    return target_payload_no_precache



#main
#OCP_RELEASE='4.13.19'
#TARGET_OCP_RELEASE='4.14.1'

# diff between what is running and the current release payload
with open('./assets/release_payload.json') as user_file:
   payload_full_release = user_file.read()
parsed_payload_full_release=json.loads(payload_full_release)
# new images in target release
with open('./assets/target_release_payload.json') as user_file:
   target_payload_full_release = user_file.read()
parsed_target_payload_full_release=json.loads(target_payload_full_release)

print("New images in the payload for the target release")
new_payload_images=compute_new_images(parsed_target_payload_full_release,parsed_payload_full_release,verbose=True)

print("Images running in the cluster")
payload_in_cluster=get_payload_in_use()

print("Images in the payload but not running in the cluster")
images_not_in_use=compute_overhead(payload_in_cluster,parsed_payload_full_release,verbose=False)

target_exclude_precache(images_not_in_use,parsed_target_payload_full_release,verbose=True)

