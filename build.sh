#!/usr/bin/env bash

set -eux

version=$1

if [ -z "${version}" ]; then
  echo "valid version is required, example: 13.0.0"
  exit -1
fi

git clean -fdx

./bootstrap
./checkout-llvm.sh ${version}
./build-llvm.sh ${version}
