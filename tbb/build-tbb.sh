#!/usr/bin/env bash

set -eux

ver=2021.5.0

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/oneTBB-${ver}"' INT TERM HUP EXIT

[ -d oneTBB-${ver} ] && rm -rf oneTBB-${ver}
tar xvf oneTBB-${ver}.tar.xz

pushd oneTBB-${ver}

"${install_prefix}/bin/cmake" -S . -B cmake-build.noindex -G Ninja \
      -DCMAKE_C_COMPILER=$(xcrun --toolchain ${XCTOOLCHAIN} --find clang) \
      -DCMAKE_CXX_COMPILER=$(xcrun --toolchain ${XCTOOLCHAIN} --find clang++) \
      -DTBB_TEST=OFF \
      -DTBB_EXAMPLES=OFF \
      -DTBB_BENCH=OFF \
      -DTBB4PY_BUILD=OFF \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_CXX_STANDARD=14 -DCMAKE_CXX_EXTENSIONS=ON \
      -DCMAKE_OSX_SYSROOT="macosx" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${install_prefix}"

"${install_prefix}/bin/ninja" -C cmake-build.noindex install

popd

popd
