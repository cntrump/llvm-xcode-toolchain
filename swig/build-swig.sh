#!/usr/bin/env bash

set -eux

swig_version=4.0.2
pcre_version=8.45

[ -d swig-${swig_version} ] && rm -rf swig-${swig_version}
tar xvf swig-${swig_version}.tar.gz
cp pcre-${pcre_version}.tar.bz2 swig-${swig_version}

pushd swig-${swig_version}

Tools/pcre-build.sh

./configure --prefix="${install_prefix}"
make -j
make install

popd

rm -rf swig-${swig_version}

