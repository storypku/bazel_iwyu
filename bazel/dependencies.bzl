load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@com_github_storypku_bazel_iwyu//bazel:prebuilt_pkg.bzl", "prebuilt_pkg")

def bazel_iwyu_dependencies():
    maybe(
        prebuilt_pkg,
        name = "iwyu_prebuilt_pkg",
        build_file = Label("//bazel/iwyu:BUILD.prebuilt_pkg"),
        urls = {
            "linux-aarch64": [
                "https://github.com/storypku/bazel_iwyu/releases/download/0.19.2/iwyu-0.19.2-aarch64-linux-gnu.tar.xz",
            ],
            "linux-x86_64": [
                "https://github.com/storypku/bazel_iwyu/releases/download/0.19.2/iwyu-0.19.2-x86_64-linux-gnu.tar.xz",
            ],
        },
        strip_prefix = {
            "linux-aarch64": "iwyu-0.19.2-aarch64-linux-gnu",
            "linux-x86_64": "iwyu-0.19.2-x86_64-linux-gnu",
        },
        sha256 = {
            "linux-aarch64": "fc4a6435905427a24918401fe51ca7a5ef87f0ab4b0b2fb10e7988f04d690c0a",
            "linux-x86_64": "39ac88a109e0078654c8061262c44ef9ceb494699cfa8c6f7b7c8aee91573658",
        },
    )

    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/archive/1.3.0.tar.gz",
        ],
        sha256 = "3b620033ca48fcd6f5ef2ac85e0f6ec5639605fa2f627968490e52fc91a9932f",
        strip_prefix = "bazel-skylib-1.3.0",
    )
