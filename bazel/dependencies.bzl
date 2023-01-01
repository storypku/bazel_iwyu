load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@com_github_storypku_bazel_iwyu//bazel:prebuilt_pkg.bzl", "prebuilt_pkg")

def bazel_iwyu_dependencies():
    # Ref to "maybe" definition github://bazelbuild/bazel:tools/build_defs/repo/utils.bzl
    if not native.existing_rule("iwyu_prebuilt_pkg"):
        prebuilt_pkg(
            name = "iwyu_prebuilt_pkg",
            build_file = Label("//bazel/iwyu:BUILD.prebuilt_pkg"),
            urls = {
                "linux-x86_64": [
                    "https://github.com/storypku/bazel_iwyu/releases/download/0.19.2/iwyu-0.19.2-x86_64-linux-gnu.tar.xz",
                ],
            },
            strip_prefix = {
                "linux-x86_64": "iwyu-0.19.2-x86_64-linux-gnu",
            },
            sha256 = {
                "linux-x86_64": "39ac88a109e0078654c8061262c44ef9ceb494699cfa8c6f7b7c8aee91573658",
            },
        )

    if not native.existing_rule("bazel_skylib"):
        http_archive(
            name = "bazel_skylib",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
                "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
            ],
            sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
        )
