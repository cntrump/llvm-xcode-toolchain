#!/usr/bin/env bash

set -eux

ver=$1
semver=(${ver//\./ })
major=${semver[0]}

pushd "$(dirname ${0})"

deps_prefix="$(pwd)/build_deps/local"
export PATH=${deps_prefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin

install_prefix="$(pwd)/build_llvm"
install_dir="${install_prefix}/releases/${ver}"
[ ! -d "${install_prefix}/releases" ] && mkdir -p "${install_prefix}/releases"

pushd llvm-project
lldb/scripts/macos-setup-codesign.sh

# https://llvm.org/docs/CMake.html
# to avoid OOMs or going into swap, permit only one link job per 15GB of RAM available on a 32GB machine,
# specify -G Ninja -DLLVM_PARALLEL_LINK_JOBS=2.
CPU_NUM=`sysctl -n hw.physicalcpu`
[ "${CPU_NUM}" = "" ] && CPU_NUM=2
CPU_NUM=$((CPU_NUM/2))
projects='bolt;clang;clang-tools-extra;libclc;lld;lldb;mlir;polly;flang'
runtimes='libunwind;libcxxabi;pstl;libcxx;compiler-rt;openmp'

# oneTBB-2021.5.0/include/oneapi/tbb/version.h: #define TBB_INTERFACE_VERSION 12050

# patch iossim archs
if [[ $major < 14 ]]; then
  sed -i'.bak' -E 's/set(DARWIN_iossim_BUILTIN_ALL_POSSIBLE_ARCHS \${X86} \${X86_64})/set(DARWIN_iossim_BUILTIN_ALL_POSSIBLE_ARCHS \${X86} \${X86_64} arm64)/g' \
      ./compiler-rt/cmake/builtin-config-ix.cmake
fi

# Remove `armv7k` arch for iOS
sed -i'.bak' -E 's/set(ARM32 armv7 armv7k armv7s)/set(ARM32 armv7 armv7s)/g' \
    ./compiler-rt/cmake/builtin-config-ix.cmake

sed -i'.bak' -E 's/set(DARWIN_osx_BUILTIN_MIN_VER 10.5)/set(DARWIN_osx_BUILTIN_MIN_VER 10.9)/g' \
    ./compiler-rt/cmake/builtin-config-ix.cmake

sed -i'.bak' -E 's/set(DARWIN_ios_BUILTIN_MIN_VER 6.0)/set(DARWIN_ios_BUILTIN_MIN_VER 9.0)/g' \
    ./compiler-rt/cmake/builtin-config-ix.cmake

cmake -S llvm -B build -G Ninja \
    -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_PARALLEL_COMPILE_JOBS=${CPU_NUM} \
    -DCMAKE_PREFIX_PATH="${deps_prefix}" \
    -DCMAKE_IGNORE_PREFIX_PATH="/usr/local;/opt/local" \
    -DCMAKE_INSTALL_PREFIX="${install_dir}" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13 \
    -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_ASM_COMPILER=$(xcrun --find clang) \
    -DCMAKE_C_COMPILER=$(xcrun --find clang) \
    -DCMAKE_CXX_COMPILER=$(xcrun --find clang++) \
    -DPython3_EXECUTABLE=$(xcrun --find python3) \
    -DCURSES_NEED_NCURSES=ON \
    -DLLDB_ENABLE_LIBEDIT=ON \
    -DLLDB_ENABLE_CURSES=ON \
    -DLLDB_ENABLE_LIBXML2=ON \
    -DLLDB_ENABLE_PYTHON=ON \
    -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
    -DPSTL_PARALLEL_BACKEND=tbb \
    -DTBB_INTERFACE_VERSION=12050 \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_CREATE_XCODE_TOOLCHAIN=ON \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_TERMINFO=ON \
    -DLLVM_ENABLE_PROJECTS=${projects} \
    -DLLVM_ENABLE_RUNTIMES=${runtimes}

[ -d "${install_dir}" ] && rm -rf "${install_dir}"

ninja -C build -j ${CPU_NUM} install install-xcode-toolchain
popd

py3fwk=Library/Frameworks/Python3.framework
xcode_dev=/Applications/Xcode.app/Contents/Developer
cmdline_dev=/Library/Developer/CommandLineTools

if [ -d ${xcode_dev} ]; then
  py3fwk=${xcode_dev}/${py3fwk}
elif [ -d ${cmdline_dev} ]; then
  py3fwk=${cmdline_dev}/${py3fwk}
fi

if [ -d ${py3fwk} ]; then
  cp -a ${py3fwk} "${install_dir}/lib"
  cp -a ${py3fwk} "${install_dir}/Toolchains/LLVM${ver}.xctoolchain/usr/lib"
fi

./archive.sh "${install_dir}" --exclude=Toolchains -cJvf ../clang+llvm-${ver}-universal-apple-darwin.tar.xz &
./archive.sh "${install_dir}/Toolchains" -cJvf ../../LLVM-${ver}-universal.xctoolchain.tar.xz &
wait

popd
