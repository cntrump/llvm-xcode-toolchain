#!/usr/bin/env bash

set -eux

ver=v3.23.4

if [ ! -d cmake ]; then
  git clone https://github.com/Kitware/CMake.git cmake
fi

pushd cmake
git clean -fdx
git reset --hard
git checkout master
git pull
git checkout tags/${ver}

CPU_NUM=`sysctl -n hw.physicalcpu`
[ "${CPU_NUM}" = "" ] && CPU_NUM=2
CPU_NUM=$((CPU_NUM/2))

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM}
make -j ${CPU_NUM}
make install
popd
