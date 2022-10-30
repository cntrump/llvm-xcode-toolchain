#/usr/bin/env bash

set -eux

ver=1.5.2

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/zstd-${ver}"' INT TERM HUP EXIT

[ -d zstd-${ver} ] && rm -rf zstd-${ver}

tar -xvf zstd-${ver}.tar.xz

pushd zstd-${ver}

pushd build/cmake
mkdir cmake-build

pushd cmake-build
cmake -G Ninja \
      -DCMAKE_C_COMPILER=$(xcrun --find clang) -DCMAKE_CXX_COMPILER=$(xcrun --find clang++) \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_OSX_SYSROOT="macosx" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DZSTD_BUILD_STATIC=ON \
      -DBUILD_TESTING=OFF \
      -DZSTD_BUILD_PROGRAMS=OFF \
      -DZSTD_BUILD_SHARED=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${install_prefix}" \
      ..
ninja
ninja install
popd

popd
popd

popd
