#!/bin/bash

DPDK_VERSION="${1:-22.11.2}"

REGISTRY='quay.io/alosadag'
PULL_SECRET="${HOME}/.docker/config.json"
DPDK_IMAGE='dpdk-testpmd'
LATEST_DPDK_VERSION="23.03"

TAG=${DPDK_VERSION}
if [ "${DPDK_VERSION}" == "${LATEST_DPDK_VERSION}" ]; then
  TAG="latest"
fi

podman build -f Dockerfile-ubi9-crypto --no-cache . \
  --build-arg DPDK_VERSION=${DPDK_VERSION} \
  --authfile=${PULL_SECRET} \
  -t ${REGISTRY}/${DPDK_IMAGE}:${TAG}

podman push --authfile=${PULL_SECRET} ${REGISTRY}/${DPDK_IMAGE}:ubi9-${TAG}-crypto
