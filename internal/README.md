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
# patch python shebang for our environment (we need python3, not python)
sed -i 's,^#!/usr/bin/env python,#!/usr/bin/env python3,g' iwyu_tool.py
sed -i 's,^#!/usr/bin/env python,#!/usr/bin/env python3,g' fix_includes.py

patch -p1 < /path/to/angle_bracket_curse_dirty_fix.patch
```

then build it with `build_iwyu.sh`.

To work around [IWYU Issue #100](https://github.com/include-what-you-use/include-what-you-use/issues/100#issuecomment-111944224)

We may need to run the following commands after the `make install` step in `build_iwyu.sh`.

```
pushd /tmp/iwyu-0.19-linux-x86_64
mkdir -p lib/clang/15.0.6/include
cp -r /opt/llvm/lib/clang/15.0.6/include/* \
  lib/clang/15.0.6/include/
popd
pushd /tmp
tar czvf iwyu-0.19-linux-x86_64.tar.gz iwyu-0.19-linux-x86_64
```

## About angle-bracket-curse
See [IWYU Issues on angle-bracket-curse](https://github.com/include-what-you-use/include-what-you-use/issues?q=angle+label%3Aangle-quote-curse) for details.
We should remove `angle_bracket_curse_dirty_fix.patch` once upstream has this issue fixed.
