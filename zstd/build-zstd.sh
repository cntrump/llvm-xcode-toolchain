#/usr/bin/env bash

set -eux

ver=v1.5.2

if [ ! -d zstd ]; then
  git clone https://github.com/facebook/zstd.git
fi

pushd zstd
git clean -fdx
git reset --hard
git checkout master
git pull
git checkout tags/${ver}

pushd build/cmake
mkdir cmake-build

pushd cmake-build
cmake -DCMAKE_C_COMPILER=$(xcrun --find clang) -DCMAKE_CXX_COMPILER=$(xcrun --find clang++) \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DZSTD_BUILD_STATIC=ON \
      -DBUILD_TESTING=OFF \
      -DZSTD_BUILD_PROGRAMS=OFF \
      -DZSTD_BUILD_SHARED=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      ..
make -j
sudo make install
popd

popd
popd
