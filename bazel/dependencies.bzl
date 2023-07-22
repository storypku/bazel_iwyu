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
                "https://github.com/storypku/bazel_iwyu/releases/download/0.20/iwyu-0.20-aarch64-linux-gnu.tar.xz",
            ],
            "linux-x86_64": [
                "https://github.com/storypku/bazel_iwyu/releases/download/0.20/iwyu-0.20-x86_64-linux-gnu.tar.xz",
            ],
        },
        strip_prefix = {
            "linux-aarch64": "iwyu-0.20-aarch64-linux-gnu",
            "linux-x86_64": "iwyu-0.20-x86_64-linux-gnu",
        },
        sha256 = {
            "linux-aarch64": "302db27d867a6d406cc63bdc0b9e23944760654aee550671c9ea527bfdca9032",
            "linux-x86_64":  "684e3e7193d6a8ee77ed485c0378f64e8c13f8a30c0709545d13c8c1655811c5",
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
