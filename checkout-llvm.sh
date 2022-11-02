#!/usr/bin/env bash

set -eux

version=$1

if [ -z "${version}" ]; then
  echo "valid version is required, example: 13.0.0"
  exit -1
fi

if [ ! -d llvm-project ]; then
  git clone https://github.com/llvm/llvm-project.git llvm-project
fi

pushd llvm-project
git clean -fdx
git reset --hard origin/main
git reset --hard tags/llvmorg-${version}
popd
