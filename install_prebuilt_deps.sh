#!/usr/bin/env bash

set -eux

pushd "$(dirname ${0})"

[[ -d build/deps ]] && rm -rf build/deps

mkdir -p build/deps
tar -xvf prebuilt_deps.tar.xz -C build/deps

popd

