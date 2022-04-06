load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@com_github_storypku_bazel_iwyu//bazel:prebuilt_pkg.bzl", "prebuilt_pkg")

def bazel_iwyu_dependencies():
    # Ref to "maybe" definition github://bazelbuild/bazel:tools/build_defs/repo/utils.bzl
    if not native.existing_rule("iwyu_prebuilt_pkg"):
        prebuilt_pkg(
            name = "iwyu_prebuilt_pkg",
            build_file = Label("//bazel/iwyu:BUILD.prebuilt_pkg"),
            urls = {
                "linux-aarch64": [
                    "https://github.com/storypku/bazel_iwyu/releases/download/asset/iwyu-0.18.0-aarch64-linux-gnu.tar.xz",
                ],
                "linux-x86_64": [
                    "https://github.com/storypku/bazel_iwyu/releases/download/asset/iwyu-0.18.0-x86_64-linux-gnu.tar.xz",
                ],
            },
            strip_prefix = {
                "linux-aarch64": "iwyu-0.18.0-aarch64-linux-gnu",
                "linux-x86_64": "iwyu-0.18.0-x86_64-linux-gnu",
            },
            sha256 = {
                "linux-aarch64": "2417fe28620b2fd55b7c8085706c85c607bc58c9cd2b74dc7859d06f633e22c8",
                "linux-x86_64": "9288990cba15b9b17c649449b7ceee328e79802aa7db2a0a6e6ba815e2ea8753",
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
