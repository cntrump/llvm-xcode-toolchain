#!/usr/bin/env bash

set -eux

ver=3.0

if [ -d re2c-${ver} ]; then
  rm -rf re2c-${ver}
fi

tar -xvf re2c-${ver}.tar.xz

pushd re2c-${ver}

mkdir cmake-build
pushd cmake-build
cmake -G Ninja \
      -DCMAKE_C_COMPILER=$(which clang) -DCMAKE_CXX_COMPILER=$(which clang++) \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_OSX_SYSROOT="macosx" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${install_prefix}" \
      ..
ninja
ninja install
popd
popd

rm -rf re2c-${ver}