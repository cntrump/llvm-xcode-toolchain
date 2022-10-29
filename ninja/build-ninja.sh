#!/usr/bin/env bash

set -eux

ver=v1.11.1

if [ ! -d ninja ]; then
  git clone https://github.com/ninja-build/ninja.git
fi

pushd ninja
git clean -fdx
git reset --hard
git checkout master
git pull
git checkout tags/${ver}

mkdir build

pushd build
cmake -DCMAKE_C_COMPILER=$(which clang) -DCMAKE_CXX_COMPILER=$(which clang++) \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_OSX_SYSROOT="macosx" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${install_prefix}" \
      ..
make -j
make install
popd

popd
