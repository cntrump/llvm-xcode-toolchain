#!/usr/bin/env bash

set -eux

pushd "$(dirname ${0})"

pushd llvm-project
lldb/scripts/macos-setup-codesign.sh

[ -d build ] && rm -rf build

install_prefix=/tmp
install_dir=${install_prefix}/llvm

# https://llvm.org/docs/CMake.html
projects='clang;clang-tools-extra;compiler-rt;flang;libclc;libcxx;libcxxabi;libunwind;lld;lldb;openmp;polly;pstl'

# to avoid OOMs or going into swap, permit only one link job per 15GB of RAM available on a 32GB machine, 
# specify -G Ninja -DLLVM_PARALLEL_LINK_JOBS=2.
CPU_NUM=`sysctl -n hw.physicalcpu`
[ "${CPU_NUM}" = "" ] && CPU_NUM=2
CPU_NUM=$((CPU_NUM/2))

cmake -S llvm -B build -G Ninja \
    -DLLVM_PARALLEL_COMPILE_JOBS=${CPU_NUM} \
    -DLLVM_PARALLEL_LINK_JOBS=1 \
    -DCMAKE_INSTALL_PREFIX="${install_dir}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_ASM_COMPILER=$(which clang) \
    -DCMAKE_C_COMPILER=$(which clang) \
    -DCMAKE_CXX_COMPILER=$(which clang++) \
    -DLIBCXX_ENABLE_PARALLEL_ALGORITHMS=ON \
    -DLLDB_ENABLE_LIBEDIT=ON \
    -DLLDB_ENABLE_CURSES=ON \
    -DLLDB_ENABLE_LIBXML2=ON \
    -DLLDB_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$(which python3) \
    -DLLVM_CREATE_XCODE_TOOLCHAIN=YES \
    -DLLVM_ENABLE_PROJECTS=${projects}

[ -d "${install_dir}" ] && rm -rf "${install_dir}"

ninja -C build install install-xcode-toolchain
popd

popd
