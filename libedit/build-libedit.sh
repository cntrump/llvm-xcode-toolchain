#!/usr/bin/env bash

set -eux

if [[ -f /usr/local/include/editline/readline.h && -f /usr/local/lib/libedit.a ]]; then
  echo Found libedit.
  exit 0
fi

ver=20210910-3.1
[ -d libedit-${ver} ] && rm -rf libedit-${ver}
tar xvf libedit-${ver}.tar.xz

pushd libedit-${ver}
CC=clang CXX=clang++ ./configure --disable-shared --disable-examples
make -j
sudo make install
popd

rm -rf libedit-${ver}

