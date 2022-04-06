# IWYU: Bazel Integration

Bazel Support for IWYU. No Compilation Database needed.
Inspired by the [Bazel-Clang-Tidy](https://github.com/erenon/bazel_clang_tidy) project.

## How To Use

1. In your WORKSPACE file, add

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_storypku_bazel_iwyu",
    strip_prefix = "bazel_iwyu-0.0.5",
    sha256 = "b4596e4f11e61c1ead77065dca8755fccff51e98a903b79ff61562c93ae7138d",
    urls = [
        "https://github.com/storypku/bazel_iwyu/archive/0.0.5.tar.gz",
    ],
)

load("@com_github_storypku_bazel_iwyu//bazel:dependencies.bzl", "bazel_iwyu_dependencies")
bazel_iwyu_dependencies()

# You may need to add the following lines.
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()
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

4. Apply fixes

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

## Features

1. [x] Support both x86_64 and aarch64 for Linux.
2. [x] No compilation database ([Ref](https://sarcasm.github.io/notes/dev/compilation-database.html)) needed.
3. [x] Support custom IWYU mapping files.
4. [x] Support custom IWYU options.

## Roadmap

1. [x] Ship prebuilt include-what-you-use binary releases
2. [x] Make this repo accessable as an external dependency.
3. [x] Support for custom mapping files and IWYU options from users.
4. [ ] Aggragate IWYU output files (*.iwyu.txt) into one.
5. [ ] More IWYU mappings for other 3rd-party libraries, e.g., ABSL, Boost, Eigen, etc.
6. [ ] CUDA support?  Ref: [rules_cuda](https://github.com/tensorflow/runtime/tree/master/third_party/rules_cuda)
7. [ ] CI: Integrate with GitHub Workflows.

## How to Contribute

As with other OSS projects, suggestions and PRs are welcome! For newcomers to GitHub,
please refer to [GitHub Docs: Creating a Pull Request](https://docs.github.com/en/articles/creating-a-pull-request).

