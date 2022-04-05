#!/usr/bin/env bash

set -eux

dir=$1

args=($@)
args=${args[@]:1}

archive() {
    tar --uid 0 --gid 0 $@
}

pushd "${dir}"
archive ${args} $(ls)
popd
