package(default_visibility = ["//visibility:public"])

# Define a platform matching any x86-compatible toolchain. See
# https://docs.bazel.build/versions/master/platforms.html.
platform(
    name = "x86_64_platform",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
)

platform(
    name = "aarch64_platform",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

platform(
    name = "j5_cross_platform",
    constraint_values = [
        "//bazel/soctype:j5",
    ],
    parents = [":aarch64_platform"],
)
