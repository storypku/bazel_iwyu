# bazel_iwyu
Bazel Support for IWYU. No Compilation Database needed.

## How To Use

1. Build and Install IWYU 0.18.0+ (Not needed for Linux x86_64 on `master`)

2. Run IWYU

```
bazel build --config=iwyu //path/to/pkg:target
```

3. Apply fixes

Suppose IWYU binaries/scripts can be found on PATH:

```
fix_includes.py --nosafe_headers < bazel-bin/path/to/pkg/<target>.iwyu.txt
```

for Linux-x86_64, You may find it convenient to have the top-level "external" symlink

```
ln -s bazel-out/../../../external external
```

And run

```
external/iwyu_prebuilt_pkg/bin/fix_includes.py --nosafe_headers < bazel-bin/path/to/pkg/<target>.iwyu.txt
```

## TODOs

1. [x] Ship prebuilt include-what-you-use binary releases
2. [ ] Make this repo accessable as an external dependency.
3. [ ] More IWYU mappings for other 3rd-party libraries, e.g., ABSL, Boost, Eigen, etc.
4. [ ] Gather multiple X.iwyu.txt into one.
