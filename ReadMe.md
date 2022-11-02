# LLVM Xcode toolchain

Clang toolchain for macOS

archs: `arm64`, `x86_64`

requried macOS version: `10.13` and higher

projects: `clang;clang-tools-extra;lld;polly`

runtimes: `libunwind;libcxxabi;pstl;libcxx;compiler-rt;openmp`

latest release: [LLVM Xcode Toolchain](https://github.com/cntrump/llvm-xcode-toolchain/releases)

## How to install LLVM toolchain

Create `Toolchains` directory if not exists: 
```bash
sudo mkdir -p /Library/Developer/Toolchains
```

Copy `LLVM${ver}.xctoolchain` to `Toolchains` directory:
```bash
sudo cp -r LLVM12.0.0.xctoolchain /Library/Developer/Toolchains
```

Or extract `LLVM-${ver}-universal.xctoolchain.tar.xz` to `Toolchains` directory:
```bash
sudo tar -xvf LLVM-12.0.0-universal.xctoolchain.tar.xz -C /Library/Developer/Toolchains
```

The format of LLVM toolchain name is: `org.llvm.${ver}`
```bash
org.llvm.14.0.0
org.llvm.13.0.1
org.llvm.13.0.0
org.llvm.12.0.1
org.llvm.12.0.0
```

Using `xcrun --toolchain ${name}` find the tool for LLVM toolchain:
```bash
CC=$(xcrun --toolchain org.llvm.12.0.0 --find clang)
# /Library/Developer/Toolchains/LLVM12.0.0.xctoolchain/usr/bin/clang

AR=$(xcrun --toolchain org.llvm.12.0.0 --find llvm-ar)
# /Library/Developer/Toolchains/LLVM12.0.0.xctoolchain/usr/bin/llvm-ar

RANLIB=$(xcrun --toolchain org.llvm.12.0.0 --find llvm-ranlib)
# /Library/Developer/Toolchains/LLVM12.0.0.xctoolchain/usr/bin/llvm-ranlib
```

Xcode: see [Using Alternative Toolchains](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/AlternativeToolchains.html)

## Develop requriement

[Command Line Tools for Xcode](https://developer.apple.com/download/all/) contains SDK: `macosx`

[Xcode](https://developer.apple.com/download/release/) contains SDK: `macosx`, `iphoneos`, `tvos`, `watchos`

Don't use `clang -fuse-ld=lld` on macOS, It's not work correctly.

Use `ld` builtin [Command Line Tools for Xcode](https://developer.apple.com/download/all/) or [Xcode](https://developer.apple.com/download/release/) instead of `lld` builtin llvm toolchain.

Use `xcrun` find SDKROOT correctly:

```bash
# macOS
clang -isysroot $(xcrun --sdk macosx --show-sdk-path)
# `xcrun --sdk macosx clang` or `SDKROOT=macosx xcrun clang`

# iOS and simulator
clang -isysroot $(xcrun --sdk iphoneos --show-sdk-path)
# `xcrun --sdk iphoneos clang` or `SDKROOT=iphoneos xcrun clang`

clang -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path)
# `xcrun --sdk iphonesimulator clang` or `SDKROOT=iphonesimulator xcrun clang`

# tvOS and simulator
clang -isysroot $(xcrun --sdk appletvos --show-sdk-path)
# `xcrun --sdk appletvos clang` or `SDKROOT=appletvos xcrun clang`

clang -isysroot $(xcrun --sdk appletvsimulator --show-sdk-path)
# `xcrun --sdk appletvsimulator clang` or `SDKROOT=appletvsimulator xcrun clang`

# watchOS and simulator
clang -isysroot $(xcrun --sdk watchos --show-sdk-path)
# `xcrun --sdk watchos clang` or `SDKROOT=watchos xcrun clang`

clang -isysroot $(xcrun --sdk watchsimulator --show-sdk-path)
# `xcrun --sdk watchsimulator clang` or `SDKROOT=watchsimulator xcrun clang`
```

### How to use pstl

Build a [pstl demo](https://mp-force.ziti.uni-heidelberg.de/kmbeutel/pstl-demo) for example:

`pstl` requried `c++17` and `tbb`.

`tbb` requried macOS 10.14 and higher.

```bash
CXX="$(xcrun --toolchain org.llvm.12.0.0 --find clang++)"
LLVM_HOME="$(dirname $CXX)/.."

${CXX} -target apple-macosx10.14 \
      -arch arm64 -arch x86_64 \
      -isysroot $(xcrun --sdk macosx --show-sdk-path) \
      -std=gnu++17 -D_LIBCPP_HAS_PARALLEL_ALGORITHMS \
      -I${LLVM_HOME}/include \
      -I/usr/local/include \
      -L/usr/local/lib \
      -ltbb -lc++ \
      main.cpp
```

Or using `xcrun` auto configure environment:
```bash
LLVM_HOME="$(dirname $(xcrun --toolchain org.llvm.12.0.0 --find clang))/.."

xcrun --toolchain org.llvm.12.0.0 --sdk macosx \
      clang -target apple-macosx10.14 \
      -arch arm64 -arch x86_64 \
      -std=gnu++17 -D_LIBCPP_HAS_PARALLEL_ALGORITHMS \
      -I${LLVM_HOME}/include \
      -I/usr/local/include \
      -L/usr/local/lib \
      -ltbb -lc++ \
      main.cpp
```

Test pstl:

```bash
❯ ./a.out 10000000

parallel 0.752187 s
serial   1.53965 s
```

## How to build app for Mac Catalyst

Mac Catalyst requried: clang version >= `13`, `-mmaccatalyst-version-min` >= `13.1`.

[[clang][driver][darwin] Add driver support for Mac Catalyst](https://reviews.llvm.org/rG2542c1a5a1306398d73c3c0c5d71cacf7c690093)

```bash
xcrun --toolchain org.llvm.13.0.0 --sdk macosx \
      clang -target apple-ios13.1-macabi \
            -arch arm64 -arch x86_64 \
            -lc++ -lSystem \
            main.cc
```

Mac Catalyst must be signed before running:

Signing identity `lldb_codesign` is created by [macos-setup-codesign.sh](https://github.com/llvm/llvm-project/blob/main/lldb/scripts/macos-setup-codesign.sh)

```bash
codesign -s lldb_codesign a.out
```

## How to build LLVM toolchain

Required: Xcode 13 with C++20 support

Install `CMake` and `Ninja`:

Using [Macports](https://www.macports.org/):

```bash
sudo port install cmake ninja
```

Using [Brew](https://brew.sh/):

```bash
brew install cmake ninja
```

My Macports installed at `/opt/local`, so I added `-DCMAKE_IGNORE_PREFIX_PATH="/opt/local"` in `build-llvm.sh`.

Build dependencies: `swig`, `libedit`, `libncurses`, `libtbb`, `zstd`

```bash
./bootstrap
```

Build clang toolchain:

```bash
./build.sh 14.0.0  # build LLVM 14.0.0
```

## BYW

Since LLVM 15, pre-built arm64 binaries is available in the [Official Releases Page](https://github.com/llvm/llvm-project/releases).
