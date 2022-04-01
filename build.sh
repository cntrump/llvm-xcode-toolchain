#!/usr/bin/env bash

set -e

version=$1

if [ -z "${version}" ]; then
  echo "valid version is required, example: 13.0.0"
  exit -1
fi

cur_dir=$(dirname ${0})

pushd swig
./build-swig.sh
popd

"${cur_dir}/checkout-llvm.sh" ${version}
"${cur_dir}/build-llvm.sh"
