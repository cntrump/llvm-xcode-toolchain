#!/usr/bin/env bash

set -eux

if which swig >& /dev/null; then
  swig -copyright
  exit 0
fi

swig_version=4.0.2
pcre_version=8.45

[ -d swig-${swig_version} ] && rm -rf swig-${swig_version}
tar xvf swig-${swig_version}.tar.gz
cp pcre-${pcre_version}.tar.bz2 swig-${swig_version}

pushd swig-${swig_version}

export CC=$(which clang)
export CXX=$(which clang++)
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.9"
export LDFLAGS="-mmacosx-version-min=10.9"

Tools/pcre-build.sh

./configure
make -j
sudo make install

popd

rm -rf swig-${swig_version}

