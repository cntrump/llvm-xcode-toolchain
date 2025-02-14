#!/usr/bin/env bash

set -eux

ver=3.31.5

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/cmake-${ver}"' INT TERM HUP EXIT

[ -d cmake-${ver} ] && rm -rf cmake-${ver}

tar -xvf cmake-${ver}.tar.gz

pushd cmake-${ver}

CPU_NUM=`sysctl -n hw.physicalcpu`
[[ ${CPU_NUM} -ge 2  ]] && CPU_NUM=$((CPU_NUM/2))

./bootstrap --prefix="${install_prefix}" --parallel=${CPU_NUM} --system-curl
make -j ${CPU_NUM}
make install
popd

popd