#!/usr/bin/env bash

set -eux

ver=6.3

[ -d ncurses-${ver} ] && rm -rf ncurses-${ver}
tar xvf ncurses-${ver}.tar.xz

pushd ncurses-${ver}
./configure --without-progs --without-manpages --without-tack --without-debug --without-tests
make -j
sudo make install
popd

rm -rf ncurses-${ver}

