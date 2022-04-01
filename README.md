# bazel_iwyu
Bazel Support for IWYU. No Compilation Database needed.

## How To Use

1. Build and Install IWYU 0.17.0

2. Run IWYU
```
bazel build --config=iwyu //path/to/your/pkg:target
```

3. Apply fixes
```
fix_includes.py --nosafe_headers < bazel-bin/path/to/your/pkg/<target>.iwyu.txt
```

## TODOs

1. [] Ship prebuilt include-what-you-use binary releases
2. [] Make this repo accessable as an external dependency.
3. [] More IWYU mappings for other 3rd-party libraries, e.g., ABSL, Boost, Eigen, etc.
4. [] Gather multiple X.iwyu.txt into one.


