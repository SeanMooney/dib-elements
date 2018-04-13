#!/bin/bash
set -e
set -x

installer_cmd=""
package_type=""
sudo_cmd="sudo -EH"

#determin os type and installer
type yum &> /dev/null && installer_cmd="yum install -y" package_type="rpm"
# prefer dnf if both yum and dnf are installed e.g. fedora
type dnf &> /dev/null && installer_cmd="dnf install -y" package_type="rpm"

type apt-get &> /dev/null && installer_cmd="apt-get install -y" package_type="deb"

# common packages
packages="qemu-img debootstrap curl wget python-setuptools"

# add distro specifc packages here
if "deb" == "$package_type"; then
    packages="$packages"
else
    packages="$packages"
fi

#install basic dependecies
$sudo_cmd $installer_cmd $packages

#set up diskimage builder submodule
git submodule init
git submodule update

$sudo_cmd easy_install -U  pip
pushd diskimage-builder
$sudo_cmd pip install -U bindep -c https://raw.githubusercontent.com/openstack/requirements/master/upper-constraints.txt
$sudo_cmd $installer_cmd $(bindep -b) || true
$sudo_cmd pip install -U  -c https://raw.githubusercontent.com/openstack/requirements/master/upper-constraints.txt -r requirements.txt
$sudo_cmd pip install -e .
popd

set +x
