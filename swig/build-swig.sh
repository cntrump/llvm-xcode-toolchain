#!/usr/bin/env bash

set -eux

swig_version=4.0.2
pcre_version=8.45

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/swig-${swig_version}"' INT TERM HUP EXIT

[ -d swig-${swig_version} ] && rm -rf swig-${swig_version}
tar xvf swig-${swig_version}.tar.gz
cp pcre-${pcre_version}.tar.bz2 swig-${swig_version}

pushd swig-${swig_version}

Tools/pcre-build.sh

./configure --prefix="${install_prefix}"
make -j
make install

popd

popd
