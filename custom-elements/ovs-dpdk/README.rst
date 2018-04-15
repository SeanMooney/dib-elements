========
OVS-DPDK
========


OVS-DPDK custom element.

This element downloads and compiles ovs with
dpdk support.

inputs
------
# default dpdk git repo
DIB_OVS_REPO=https://dpdk.org/browse/dpdk-stable/
# default git branch to clone
DIB_OVS_BRANCH=master
# default set of patches to apply as space seperated list
# e.g. "http://remote/patches/patch1 /local/patch/patch2"
# patches are applied in order specifed.
DIB_OVS_PATCHES:""
