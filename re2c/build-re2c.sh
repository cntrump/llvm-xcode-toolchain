#!/usr/bin/env bash

set -eux

ver=3.0

if [ ! -d re2c ]; then
  git clone https://github.com/skvadrik/re2c.git
fi

pushd re2c
git clean -fdx
git reset --hard
git checkout master
git pull
git checkout tags/${ver}

mkdir cmake-build
pushd cmake-build
cmake -DCMAKE_C_COMPILER=$(which clang) -DCMAKE_CXX_COMPILER=$(which clang++) \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_BUILD_TYPE=Release \
      ..
make -j
sudo make install
popd
popd
