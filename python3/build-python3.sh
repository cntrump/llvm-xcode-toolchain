#!/usr/bin/env bash

set -eux

ver=3.11.0

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/Python-${ver}"' INT TERM HUP EXIT

[ -d Python-${ver} ] && rm -rf Python-${ver}

tar -xvf Python-${ver}.tar.xz

pushd Python-${ver}
./configure --enable-universalsdk --with-universal-archs=universal2 --enable-optimizations
make -j
make install
popd

popd
