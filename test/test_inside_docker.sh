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

yum -y install yum-plugin-priorities rpm-build python-devel gcc-c++ make

# Prepare the RPM environment
mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cat >> /etc/rpm/macros.dist << EOF
%dist .osg.el${OS_VERSION}
EOF

cd /gratia-probe
chown -R root:root .  # fix rpmbuild issues with user/group ownership
./build/build_all

package_version=`grep Version htcondor-ce/rpm/htcondor-ce.spec | awk '{print $2}'`
yum localinstall -y /tmp/rpmbuild/RPMS/noarch/gratia-probe-common-${package_version}*
