#!/usr/bin/env bash

set -eux

ver=20210910-3.1

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/libedit-${ver}"' INT TERM HUP EXIT

[ -d libedit-${ver} ] && rm -rf libedit-${ver}
tar xvf libedit-${ver}.tar.xz

pushd libedit-${ver}
./configure --prefix="${install_prefix}" --disable-shared --disable-examples
make -j
make install-exec
popd

popd
