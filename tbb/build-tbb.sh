#!/usr/bin/env bash

set -eux

if [[ -f /usr/local/include/tbb/tbb.h && -f /usr/local/lib/libtbb.a ]]; then
  echo "Found tbb."
  exit 0
fi

ver=2021.5.0
[ -d oneTBB-${ver} ] && rm -rf oneTBB-${ver}
tar xvf oneTBB-${ver}.tar.xz

pushd oneTBB-${ver}
mkdir build
pushd build
cmake -G Ninja -DCMAKE_C_COMPILER=$(which clang) -DCMAKE_CXX_COMPILER=$(which clang++) \
      -DTBB_TEST=OFF \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_CXX_OSX_DEPLOYMENT_TARGET_FLAG=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_BUILD_TYPE=Release \
      ..
ninja
sudo ninja install
popd

popd

rm -rf oneTBB-${ver}

