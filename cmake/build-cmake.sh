#!/usr/bin/env bash

set -eux

ver=3.23.4

if [ -d CMake-${ver} ]; then
  rm -rf CMake-${ver}
fi

tar -xvf CMake-${ver}.tar.xz

pushd CMake-${ver}
CPU_NUM=`sysctl -n hw.physicalcpu`

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM}
make -j
make install
popd

rm -rf CMake-${ver}