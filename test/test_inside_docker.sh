#!/bin/bash -xe

OS_VERSION=$1

ls -l /home

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache
yum -y update  # Update the OS packages

# First, install all the needed packages.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${OS_VERSION}.noarch.rpm

# Broken mirror?
echo "exclude=mirror.beyondhosting.net" >> /etc/yum/pluginconf.d/fastestmirror.conf

yum -y install yum-plugin-priorities rpm-build python-devel gcc-c++

cd /gratia-probe
sudo ./build/build_all
