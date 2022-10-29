#!/usr/bin/env bash

set -eux

ver=6.3

[ -d ncurses-${ver} ] && rm -rf ncurses-${ver}
tar xvf ncurses-${ver}.tar.xz

pushd ncurses-${ver}
./configure --prefix="${install_prefix}" --without-progs --without-manpages --without-tack --without-debug --without-tests
make -j
make install
popd

rm -rf ncurses-${ver}

