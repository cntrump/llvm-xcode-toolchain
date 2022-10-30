#!/usr/bin/env bash

set -eux

ver=6.3

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/ncurses-${ver}"' INT TERM HUP EXIT

[ -d ncurses-${ver} ] && rm -rf ncurses-${ver}
tar xvf ncurses-${ver}.tar.xz

pushd ncurses-${ver}
./configure --prefix="${install_prefix}" \
            --without-progs \
            --without-manpages \
            --without-tack \
            --without-debug \
            --without-tests \
            --disable-db-install
make -j
make install
popd

popd
