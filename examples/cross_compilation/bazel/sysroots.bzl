load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    http_archive(
        name = "chromium_sysroot_linux_aarch64",
        build_file = clean_dep("//:chromium_sysroot.BUILD"),
        sha256 = "2e3a344f48da76b6532f3de86759f94359292143ccaf6094814e09441a36629f",
        urls = [
            "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/0e28d9832614729bb5b731161ff96cb4d516f345/debian_bullseye_arm64_sysroot.tar.xz",
        ],
    )    
