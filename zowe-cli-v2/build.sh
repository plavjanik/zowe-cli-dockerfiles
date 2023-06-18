#!/usr/bin/env bash
set -ex

# Setting default values for environment variables if they are not set:
: ${TAG:=zowe-cli:local}
: ${CONTAINER:=zowe-cli}
: ${IMAGE:=zowe-cli}

print_versions() {
    docker -v &&
    echo "TAG=${TAG}" &&
    echo "BRANCH_NAME=${BRANCH_NAME}"
}

build_docker_image() {
    echo "Building Docker image" &&
    docker build . -t ${TAG}
}

test_zowe() {
    echo "Running Zowe CLI as a test"
    docker run --platform=linux/amd64 --name=${CONTAINER} -d -it --mount type=bind,source="$PWD",target=/workspace,consistency=delegated ${TAG} &&
    docker exec ${CONTAINER} zowe --version &&
    docker exec ${CONTAINER} zowe --version
}

cleanup() {
    set +e
    echo "Cleanup"
    docker stop ${CONTAINER}
    docker rm ${CONTAINER} || docker rm -f ${CONTAINER}
}

{
    print_versions &&
    build_docker_image &&
    test_zowe &&
    cleanup
} ||
{
    cleanup
    exit 1
}
