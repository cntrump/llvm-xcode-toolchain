#!/usr/bin/env bash

set -eux

ver=$1

archive() {
    tar --uid 0 --gid 0 $@
}

pushd "$(dirname ${0})"

pushd llvm-project
lldb/scripts/macos-setup-codesign.sh

[ -d build ] && rm -rf build

install_prefix=/opt
install_dir=${install_prefix}/llvm/releases/${ver}

# https://llvm.org/docs/CMake.html
projects='clang;clang-tools-extra;compiler-rt;flang;libclc;libcxx;libcxxabi;libunwind;lld;lldb;openmp;polly;pstl'

# to avoid OOMs or going into swap, permit only one link job per 15GB of RAM available on a 32GB machine, 
# specify -G Ninja -DLLVM_PARALLEL_LINK_JOBS=2.
CPU_NUM=`sysctl -n hw.physicalcpu`
[ "${CPU_NUM}" = "" ] && CPU_NUM=2
CPU_NUM=$((CPU_NUM/2))

arch=$(uname -m)

cmake -S llvm -B build -G Ninja \
    -DLLVM_PARALLEL_COMPILE_JOBS=${CPU_NUM} \
    -DLLVM_PARALLEL_LINK_JOBS=1 \
    -DCMAKE_INSTALL_PREFIX="${install_dir}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_ASM_COMPILER=$(which clang) \
    -DCMAKE_C_COMPILER=$(which clang) \
    -DCMAKE_CXX_COMPILER=$(which clang++) \
    -DCLANG_DEFAULT_LINKER=lld \
    -DLLDB_ENABLE_LIBEDIT=ON \
    -DLLDB_ENABLE_CURSES=ON \
    -DLLDB_ENABLE_LIBXML2=ON \
    -DLLDB_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$(which python3) \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_CREATE_XCODE_TOOLCHAIN=ON \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_PROJECTS=${projects}

[ -d "${install_dir}" ] && rm -rf "${install_dir}"

ninja -C build install install-xcode-toolchain
popd

pushd "${install_dir}"
archive --exclude=Toolchains -cJvf clang+lldb+llvm-${ver}-${arch}-apple-darwin.tar.xz *

pushd Toolchains
archive -cJvf LLVM-${ver}-${arch}.xctoolchain.tar.xz LLVM${ver}.xctoolchain
popd

popd

popd
