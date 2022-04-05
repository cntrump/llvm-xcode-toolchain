#!/usr/bin/env bash

set -eux

version=$1

if [ -z "${version}" ]; then
  echo "valid version is required, example: 13.0.0"
  exit -1
fi

cur_dir=$(dirname ${0})

export CC=$(which clang)
export CXX=$(which clang++)
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.9 -std=gnu11"
export CXXFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.9 -std=gnu++14"
export LDFLAGS="-mmacosx-version-min=10.9"

pushd swig
./build-swig.sh
popd

pushd ncurses
./build-ncurses.sh
popd

pushd libedit
./build-libedit.sh
popd

export -n CC
export -n CXX
export -n CFLAGS
export -n CXXFLAGS
export -n LDFLAGS

unset CC
unset CXX
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

pushd tbb
./build-tbb.sh
popd

"${cur_dir}/checkout-llvm.sh" ${version}
"${cur_dir}/build-llvm.sh" ${version}

