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
[[ ${CPU_NUM} -ge 2  ]] && CPU_NUM=$((CPU_NUM/2))

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM}
make -j ${CPU_NUM}
make install
popd

popd