# bazel_iwyu: Bazel Support for IWYU

`bazel_iwyu` aims to provide C++ developers an convenient way to use IWYU with Bazel. It was inspired by the [bazel_clang_tidy](https://github.com/erenon/bazel_clang_tidy) project. Just like `bazel_clang_tidy`, you can run IWYU on Bazel C++ targets directly; there is NO need to generate a compilation database first.

## How To Use

1. In your WORKSPACE file, add

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_storypku_bazel_iwyu",
    strip_prefix = "bazel_iwyu-<version>",
    sha256 = "<sha256sum>",
    urls = [
        "https://github.com/storypku/bazel_iwyu/archive/<version>.tar.gz",
    ],
)

load("@com_github_storypku_bazel_iwyu//bazel:dependencies.bzl", "bazel_iwyu_dependencies")
bazel_iwyu_dependencies()
```

2. Add the following to your .bazelrc.

```
build:iwyu --aspects @com_github_storypku_bazel_iwyu//bazel/iwyu:iwyu.bzl%iwyu_aspect
build:iwyu --output_groups=report
```


If you would like to use your own IWYU mappings, put all your IMP files in a directory, say,
`bazel/iwyu/mappings`, and create a `filegroup` target for it:

```python
# bazel/iwyu/BUILD.bazel
filegroup(
    name = "my_mappings",
    srcs = glob([
        "mappings/*.imp",
    ]),
)
```

Then add the following config to your `.bazelrc` to make it effective.

```
build:iwyu --@com_github_storypku_bazel_iwyu//:iwyu_mappings=//bazel/iwyu:my_mappings
```

If custom IWYU options should be used, change the line below:

```
build:iwyu --@com_github_storypku_bazel_iwyu//:iwyu_opts=--verbose=3,--no_fwd_decls,--cxx17ns,--max_line_length=127
```

3. Run IWYU

```shell
bazel build --config=iwyu //path/to/pkg:target
```

Please note that for IWYU 0.19 to work on Ubuntu 18.04 Aarch64, you should have `libtinfo6` installed.
libtinfo6 (`libtinfo6_6.2-0ubuntu2_arm64.deb`) can be downloaded from [Here](https://mirrors.aliyun.com/ubuntu-ports/pool/main/n/ncurses/libtinfo6_6.2-0ubuntu2_arm64.deb).

4. Apply fixes

Create a top-level "external" symlink,

```shell
ln -s bazel-out/../../../external external
```

and run

```shell
external/iwyu_prebuilt_pkg/bin/fix_includes.py --nosafe_headers < bazel-bin/path/to/pkg/<target>.iwyu.txt
```

## Features

1. [x] Support both `x86_64` and `aarch64` for Linux.
2. [x] No compilation database ([Ref](https://sarcasm.github.io/notes/dev/compilation-database.html)) needed.
3. [x] Support custom IWYU mapping files.
4. [x] Support custom IWYU options.

## Roadmap

1. [x] Ship prebuilt include-what-you-use binary releases
2. [x] Make this repo accessable as an external dependency.
3. [x] Support for custom mapping files and IWYU options from users.
4. [ ] Aggregate IWYU output files (*.iwyu.txt) into one.
5. [ ] More IWYU mappings for other 3rd-party libraries, e.g., ABSL, Boost, Eigen, etc.
6. [ ] CUDA support?  Ref: [rules_cuda](https://github.com/tensorflow/runtime/tree/master/third_party/rules_cuda)
7. [ ] CI: Integrate with GitHub Workflows.

## Contributing
As with other OSS projects, Issues and PRs are always welcome.
