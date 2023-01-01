workspace(name = "com_github_storypku_bazel_iwyu")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@com_github_storypku_bazel_iwyu//bazel:dependencies.bzl", "bazel_iwyu_dependencies")

bazel_iwyu_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

absl_version = "20211102.0"

http_archive(
    name = "com_google_absl",
    sha256 = "dcf71b9cba8dc0ca9940c4b316a0c796be8fab42b070bb6b7cab62b48f0e66c4",
    strip_prefix = "abseil-cpp-{}".format(absl_version),
    urls = [
        "https://github.com/abseil/abseil-cpp/archive/refs/tags/{}.tar.gz".format(absl_version),
    ],
)

rules_boost_commit = "f1065639e6f33741abe2a6a78fa79dd1a07bbf5d"

http_archive(
    name = "com_github_nelhage_rules_boost",
    sha256 = "6ded3e8c064054c92b79aeadde2d78821c889598e634c595133da0ea8f0f0b85",
    strip_prefix = "rules_boost-{}".format(rules_boost_commit),
    urls = [
        "https://github.com/nelhage/rules_boost/archive/{}.tar.gz".format(rules_boost_commit),
    ],
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

boost_deps()

http_archive(
    name = "com_google_googletest",
    sha256 = "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5",
    strip_prefix = "googletest-release-1.11.0",
    urls = [
        "https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz",
    ],
)
