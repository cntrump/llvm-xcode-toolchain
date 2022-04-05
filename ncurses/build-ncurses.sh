#!/usr/bin/env bash

set -eux

if [[ -f /usr/local/include/ncurses/ncurses.h && -f /usr/local/lib/libncurses.a ]]; then
  echo "Found libncurses."
  exit 0
fi

ver=6.3

[ -d ncurses-${ver} ] && rm -rf ncurses-${ver}
tar xvf ncurses-${ver}.tar.xz

pushd ncurses-${ver}
CC=clang CXX=clang++ \
CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.9 -std=gnu11" \
CXXFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.9 -std=gnu++14" \
LDFLAGS="-mmacosx-version-min=10.9" \
./configure --without-debug --without-tests
make -j
sudo make install
popd

rm -rf ncurses-${ver}

