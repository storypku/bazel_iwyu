# Steps to Build IWYU 0.19


## Install LLVM/Clang 15.x

1. Download LLVM/Clang 15.x distribution from https://github.com/llvm/llvm-project/releases

2. Extract and rename it to /opt/llvm after downloading.

E.g.,

```
sudo tar xJvf clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04.tar.gz -C /opt
sudo mv /opt/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04 /opt/llvm
```

## Download IWYU 0.19

IWYU 0.19 can be downloaded from https://github.com/include-what-you-use/include-what-you-use/releases/tag/0.19

## Build IWYU

When IWYU tarball is extracted, cd into the directory, and run:

```
# Already merged in mainline and upcoming 0.20
sed -i 's,^#!/usr/bin/env python,#!/usr/bin/env python3,g' iwyu_tool.py
sed -i 's,^#!/usr/bin/env python,#!/usr/bin/env python3,g' fix_includes.py

patch -p1 < /path/to/p01_angle_bracket_curse_dirty_fix.patch

# Already merged in mainline and upcoming 0.20
patch -p1 < /path/to/p02_issue_1162_crash_fix.patch
```

then build it with `build_iwyu.sh`.

To work around [IWYU Issue #100](https://github.com/include-what-you-use/include-what-you-use/issues/100#issuecomment-111944224)

We may need to run the following commands after the `make install` step in `build_iwyu.sh`.

```
pushd /tmp/iwyu-0.19.X-x86_64-linux-gnu
mkdir -p lib/clang/15.0.6
cp -r /opt/llvm/lib/clang/15.0.6/include lib/clang/15.0.6/include
popd
pushd /tmp
tar cJvf iwyu-0.19.X-x86_64-linux-gnu.tar.xz iwyu-0.19.X-x86_64-linux-gnu
```

### Special notes for IWYU 0.19 AArch64

1. Ubuntu 20.04+ should be used to build IWYU 0.19. 

   LLVM 15 depends on `libtinfo.so.6`, which was not available for Ubuntu 18.04.

2. System provided CMake (3.16.3) on Ubuntu 20.04 was too old to work with LLVM-15/IWYU-0.19.

Build would fail with the following output otherwise:

```
CMake Error at /tmp/llvm/lib/cmake/llvm/AddLLVM.cmake:932 (add_executable):
  Target "include-what-you-use" links to target "ZLIB::ZLIB" but the target
  was not found.  Perhaps a find_package() call is missing for an IMPORTED
  target, or an ALIAS target is missing?
Call Stack (most recent call first):
  CMakeLists.txt:101 (add_llvm_executable)

CMake Error at /tmp/llvm/lib/cmake/llvm/AddLLVM.cmake:932 (add_executable):
  Target "include-what-you-use" links to target "Terminfo::terminfo" but the
  target was not found.  Perhaps a find_package() call is missing for an
  IMPORTED target, or an ALIAS target is missing?
Call Stack (most recent call first):
  CMakeLists.txt:101 (add_llvm_executable)

cannot find -lZLIB::ZLIB
cannot find -lTerminfo::terminfo
```

3. LLVM distribution 15.0.3 should be used on Ubuntu 20.04 .

Prebuilt LLVM-15.0.6 requires higher versions of libstdc++ than that was available on Ubuntu 20.04 .

```
/opt/llvm/bin/clang --version
/opt/llvm/bin/clang: /lib/aarch64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by /opt/llvm/bin/clang)
/opt/llvm/bin/clang: /lib/aarch64-linux-gnu/libstdc++.so.6: version `CXXABI_1.3.13' not found (required by /opt/llvm/bin/clang)
```

## About angle-bracket-curse
See [IWYU Issues on angle-bracket-curse](https://github.com/include-what-you-use/include-what-you-use/issues?q=angle+label%3Aangle-quote-curse) for details.
We should remove `angle_bracket_curse_dirty_fix.patch` once upstream has this issue fixed.
