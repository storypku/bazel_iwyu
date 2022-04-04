load("@com_github_storypku_bazel_iwyu//bazel:prebuilt_pkg.bzl", "prebuilt_pkg")

def bazel_iwyu_dependencies():
    # Ref to "maybe" definition github://bazelbuild/bazel:tools/build_defs/repo/utils.bzl
    if not native.existing_rule("iwyu_prebuilt_pkg"):
        prebuilt_pkg(
            name = "iwyu_prebuilt_pkg",
            build_file = Label("//bazel/iwyu:BUILD.prebuilt_pkg"),
            urls = {
                "linux-x86_64": [
                    "https://github.com/storypku/bazel_iwyu/releases/download/0.0.1/iwyu-0.18.0-x86_64-linux-gnu.tar.xz",
                ],
            },
            strip_prefix = {
                "linux-x86_64": "iwyu-0.18.0-x86_64-linux-gnu",
            },
            sha256 = {
                "linux-x86_64": "9288990cba15b9b17c649449b7ceee328e79802aa7db2a0a6e6ba815e2ea8753",
            },
        )
