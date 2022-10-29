#!/usr/bin/env bash

set -eux

ver=3.23.4

if [ -d CMake-${ver} ]; then
  rm -rf CMake-${ver}
fi

tar -xvf CMake-${ver}.tar.xz

pushd CMake-${ver}
CPU_NUM=`sysctl -n hw.physicalcpu`
[ "${CPU_NUM}" = "" ] && CPU_NUM=2
CPU_NUM=$((CPU_NUM/2))

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM}
make -j ${CPU_NUM}
make install
popd

rm -rf CMake-${ver}