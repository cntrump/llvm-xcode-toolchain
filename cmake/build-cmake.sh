#!/usr/bin/env bash

set -eux

ver=3.23.4

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/CMake-${ver}"' INT TERM HUP EXIT

[ -d CMake-${ver} ] && rm -rf CMake-${ver}

tar -xvf CMake-${ver}.tar.xz

pushd CMake-${ver}
CPU_NUM=`sysctl -n hw.physicalcpu`

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM}
make -j
make install
popd

popd