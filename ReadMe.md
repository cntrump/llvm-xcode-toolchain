# LLVM Xcode toolchain

Clang toolchain for macOS

archs: `arm64`, `x86_64`

requried macOS version: `10.13` and higher

## How to install LLVM toolchain

Create `Toolchains` directory if not exists: 
```bash
sudo mkdir -p /Library/Developer/Toolchains
```

Copy `LLVM${ver}.xctoolchain` to `Toolchains` directory:
```bash
sudo cp -r LLVM12.0.0.xctoolchain /Library/Developer/Toolchains
```

Or extract `LLVM${ver}.xctoolchain.tar.xz` to `Toolchains` directory:
```bash
sudo tar -xvf LLVM12.0.0.xctoolchain.tar.xz -C /Library/Developer/Toolchains
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

# iOS and simulator
clang -isysroot $(xcrun --sdk iphoneos --show-sdk-path)
clang -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path)

# tvOS and simulator
clang -isysroot $(xcrun --sdk appletvos --show-sdk-path)
clang -isysroot $(xcrun --sdk appletvsimulator --show-sdk-path)

# watchOS and simulator
clang -isysroot $(xcrun --sdk watchos --show-sdk-path)
clang -isysroot $(xcrun --sdk watchsimulator --show-sdk-path)
```

### How to use pstl

Build a [pstl demo](https://mp-force.ziti.uni-heidelberg.de/kmbeutel/pstl-demo) for example:

pstl requried `c++17` and `tbb`:

```bash
clang -target apple-macosx10.14 \
      -arch arm64 -arch x86_64 \
      -isysroot $(xcrun --sdk macosx --show-sdk-path) \
      -std=gnu++17 -D_LIBCPP_HAS_PARALLEL_ALGORITHMS \
      -I/opt/llvm/usr/include \
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

## How to build Clang toolchain

Required: Xcode 13 with C++20 support

Build dependencies: `cmake`, `ninja`, `swig`, `libedit`, `libncurses`, `libtbb`

```bash
./bootstrap
```

Build clang toolchain:

```bash
./build.sh 14.0.0  # build LLVM 14.0.0
```
