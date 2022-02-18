TAG="${1:-latest}"

podman build . -t quay.io/alosadag/testpmd:${TAG} -f Dockerfile
