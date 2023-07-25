load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_test")

cc_binary(
    name = "math_demo",
    srcs = ["math_demo.cc"],
)

cc_test(
    name = "atomic_test",
    srcs = ["atomic_test.cc"],
    linkopts = ["-latomic"],
)
