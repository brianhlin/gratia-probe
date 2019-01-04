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

# Prepare the RPM environment
mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cat >> /etc/rpm/macros.dist << EOF
%dist .${BUILD_ENV}.el${OS_VERSION}
%${BUILD_ENV} 1
EOF

cd /gratia-probe
./build/build_all

package_version=`grep Version htcondor-ce/rpm/htcondor-ce.spec | awk '{print $2}'`
yum localinstall -y /tmp/rpmbuild/RPMS/noarch/gratia-probe-common-${package_version}*
