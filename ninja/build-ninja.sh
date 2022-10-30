#!/usr/bin/env bash

set -eux

ver=1.11.1

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/ninja-${ver}"' INT TERM HUP EXIT

[ -d ninja-${ver} ] && rm -rf ninja-${ver}

tar -xvf ninja-${ver}.tar.xz

pushd ninja-${ver}

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

popd
