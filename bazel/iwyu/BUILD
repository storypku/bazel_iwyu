package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "iwyu",
    srcs = ["run_iwyu.sh"],
    data = [
        ":custom_mappings",
    ],
    tags = ["no-sandbox"],
)

filegroup(
    name = "custom_mappings",
    srcs = glob([
        "mappings/*.imp",
    ]),
)
