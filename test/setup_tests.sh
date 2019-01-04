#!/bin/sh -xe

# This script starts docker and systemd (if el7)

# Run tests in Container
# We use `--privileged` for cgroup compatability, which seems to be enabled by default in HTCondor 8.6.x
sudo docker run --privileged --rm=true \
     --volume `pwd`:/gratia-probe:rw \
     centos:centos${OS_VERSION} \
     /bin/bash -c "bash -xe /gratia-probe/test/test_inside_docker.sh ${OS_VERSION}"
