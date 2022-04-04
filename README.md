# bazel_iwyu

Bazel Support for IWYU. No Compilation Database needed. 
Inspired by the [Bazel-Clang-Tidy](https://github.com/erenon/bazel_clang_tidy) project.

## How To Use

1. Build and Install IWYU 0.18.0+ (Not needed for Linux x86_64 on `master`)

2. In your WORKSPACE file, add

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_storypku_bazel_iwyu",
    sha256 = "043b554c2cdaa7e7c56f2341452498a63f282baf9f086b08b29783c9b0fb6597",
    strip_prefix = "bazel_iwyu-0.0.2"
    urls = [
        "https://github.com/storypku/bazel_iwyu/archive/0.0.2.tar.gz",
    ],
)

load("@com_github_storypku_bazel_iwyu//bazel:dependencies.bzl", "bazel_iwyu_dependencies")
bazel_iwyu_dependencies()
```

3. Add the following to your bazelrc. (E.g., `.bazelrc`)

```
build:iwyu --aspects @com_github_storypku_bazel_iwyu//bazel/iwyu:iwyu.bzl%iwyu_aspect
build:iwyu --output_groups=report
```

4. Run IWYU

```shell
bazel build --config=iwyu //path/to/pkg:target
```

5. Apply fixes

Suppose IWYU binaries/scripts can be found on PATH:

```shell
fix_includes.py --nosafe_headers < bazel-bin/path/to/pkg/<target>.iwyu.txt
```

for Linux-x86_64, You may find it convenient to have the top-level "external" symlink

```shell
ln -s bazel-out/../../../external external
```

And run

```shell
external/iwyu_prebuilt_pkg/bin/fix_includes.py --nosafe_headers < bazel-bin/path/to/pkg/<target>.iwyu.txt
```

## TODOs

1. [x] Ship prebuilt include-what-you-use binary releases
2. [x] Make this repo accessable as an external dependency.
3. [ ] More IWYU mappings for other 3rd-party libraries, e.g., ABSL, Boost, Eigen, etc.
4. [ ] Gather multiple X.iwyu.txt into one.
5. [ ] Support for custom mapping files and IWYU options from users.

## How to Contribute
As with other OSS projects, suggestions and PRs are welcome!

