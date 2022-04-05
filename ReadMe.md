# LLVM Xcode toolchain

Clang toolchain for macOS

archs: `arm64`, `x86_64`

## How to build

Build dependencies: `cmake`, `ninja`, `swig`, `libedit`, `libncurses`, `libtbb`

```bash
./bootstrap
```

Build clang toolchain:

```bash
./build.sh 14.0.0  # build LLVM 14.0.0
```
