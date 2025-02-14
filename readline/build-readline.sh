#!/usr/bin/env bash

set -eux

ver=8.2.13

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/readline-${ver}"' INT TERM HUP EXIT

[ -d readline-${ver} ] && rm -rf readline-${ver}
tar xvf readline-${ver}.tar.gz

pushd readline-${ver}
./configure --prefix="${install_prefix}" --with-curses --disable-shared --disable-install-examples
make -j
make install-static
popd

popd
