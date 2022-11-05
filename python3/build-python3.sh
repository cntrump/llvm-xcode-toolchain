#!/usr/bin/env bash

set -eux

ver=3.11.0

pushd "$(dirname ${0})"
path=$(pwd)
trap 'rm -rf "${path}/Python-${ver}"' INT TERM HUP EXIT

[ -d Python-${ver} ] && rm -rf Python-${ver}

tar -xvf Python-${ver}.tar.xz

pushd Python-${ver}
./configure --prefix="${install_prefix}" --without-static-libpython --enable-shared \
            --enable-universalsdk --with-universal-archs=universal2 --enable-optimizations \
            LDFLAGS="-Wl,-rpath,@executable_path/../lib"

make -j
make install
popd

rm -rf "${path}/Python-${ver}"

ver=(${ver//\./ })
python3_dylib="libpython${ver[0]}.${ver[1]}.dylib"
python3_dylib_path="${install_prefix}/lib/${python3_dylib}"
install_name_tool -change "${python3_dylib_path}" @rpath/${python3_dylib} "${install_prefix}/bin/python3"

popd
