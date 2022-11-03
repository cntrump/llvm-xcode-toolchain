#!/usr/bin/env bash

set -eux

pushd "$(dirname ${0})"

ver=$1
install_dir=$2

[[ "${ver}" = "" ]] && exit 1
[[ ! -d "${install_dir}" ]] && exit 1

deps_prefix="$(pwd)/build/deps"

python3_version=($("${deps_prefix}/bin/python3" --version))
echo $python3_version
version=${python3_version[1]}
python3_version=(${version//\./ })
python3_dylib="libpython${python3_version[0]}.${python3_version[1]}.dylib"
python3_dylib_path="${deps_prefix}/lib/${python3_dylib}"

cp -a "${python3_dylib_path}" "${install_dir}/lib"
cp -a "${python3_dylib_path}" "${install_dir}/Toolchains/LLVM${ver}.xctoolchain/usr/lib"

install_name_tool -change "${python3_dylib_path}" @rpath/${python3_dylib} "${install_dir}/lib/liblldb.dylib"
install_name_tool -change "${python3_dylib_path}" @rpath/${python3_dylib} "${install_dir}/Toolchains/LLVM${ver}.xctoolchain/usr/lib/liblldb.dylib"

popd

