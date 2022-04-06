# NOTE(Jiaming):
# Inspired by the Bazel-Clang-Tidy Project available at https://github.com/erenon/bazel_clang_tidy.
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

_IWYU_OPTIONS = ["--no_fwd_decls", "--quoted_includes_first", "--cxx17ns", "--max_line_length=127"]
_IWYU_ISSUE_950 = "https://github.com/include-what-you-use/include-what-you-use/issues/950"

def _run_iwyu(ctx, iwyu_binary, flags, compilation_context, infile):
    inputs = depset(direct = [infile], transitive = [compilation_context.headers])

    # add args specified by iwyu_options, the toolchain, on the command line and rule copts
    args = flags

    # add defines
    for define in compilation_context.defines.to_list():
        args.append("-D" + define)

    for define in compilation_context.local_defines.to_list():
        args.append("-D" + define)

    # add includes
    for inc in compilation_context.framework_includes.to_list():
        args.append("-F" + inc)

    for inc in compilation_context.includes.to_list():
        args.append("-I" + inc)
    for inc in compilation_context.quote_includes.to_list():
        args.extend(["-iquote", inc])

    for inc in compilation_context.system_includes.to_list():
        args.extend(["-isystem", inc])

    # add source to check
    args.append(infile.path)

    output_file = ctx.actions.declare_file(infile.basename + ".iwyu.txt")
    output_path = output_file.path

    # https://github.com/bazelbuild/bazel/issues/5511
    ctx.actions.run_shell(
        inputs = inputs,
        outputs = [output_file],
        command = """{0} {2} 1>{1} 2>&1 && echo "Output saved to {1}" """.format(
            iwyu_binary,
            output_path,
            " ".join(args),
        ),
        mnemonic = "iwyu",
        progress_message = "Run include-what-you-use on {}".format(infile.short_path),
        execution_requirements = {
            "no-sandbox": "1",
        },
    )
    return output_file

def _rule_sources(ctx):
    srcs = []

    # make sure the rule has a srcs attribute
    if hasattr(ctx.rule.attr, "srcs"):
        for src in ctx.rule.attr.srcs:
            # https://bazel.build/rules/lib/File#is_source
            srcs += [s for s in src.files.to_list() if s.is_source]
    return srcs

def _toolchain_flags(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    compile_variables = cc_common.create_compile_variables(
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        user_compile_flags = ctx.fragments.cpp.cxxopts + ctx.fragments.cpp.copts,
    )
    flags = cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = "c++-compile",  # tools/build_defs/cc/action_names.bzl CPP_COMPILE_ACTION_NAME
        variables = compile_variables,
    )
    return flags

def _safe_flags(flags):
    # Some flags might be used by GCC, but not understood by Clang.
    # Remove them here, to allow users to run clang-tidy, without having
    # a clang toolchain configured (that would produce a good command line with --compiler clang)
    unsupported_flags = [
        "-fno-canonical-system-headers",
        "-fstack-usage",
    ]

    return [flag for flag in flags if flag not in unsupported_flags and not flag.startswith("--sysroot")]

def _iwyu_binary_path(ctx):
    files = [s for s in ctx.attr._iwyu_binary.files.to_list() if s.is_source]
    return files[0].path if len(files) > 0 else "include-what-you-use"

def _iwyu_aspect_impl(target, ctx):
    # Interest in C, C++, and CUDA(not-ready) targets only
    if not CcInfo in target:
        return []

    srcs = _rule_sources(ctx)
    if len(srcs) == 0:
        # print("{}: no-op. No 'srcs' in rule.".format(target.label))
        return []

    for s in srcs:
        if s.basename.endswith(".cu.cc") or s.extension == "cu":
            print("{}: no-op. CUDA support is not ready. Ref: {}".format(target.label, _IWYU_ISSUE_950))
            return []

    iwyu_binary = _iwyu_binary_path(ctx)
    iwyu_mappings = [m.path for m in ctx.attr._iwyu_mappings.files.to_list()]

    toolchain_flags = _toolchain_flags(ctx)
    rule_flags = ctx.rule.attr.copts if hasattr(ctx.rule.attr, "copts") else []

    overall_flags = ["-Xiwyu {}".format(opt) for opt in _IWYU_OPTIONS]
    overall_flags.extend(["-Xiwyu --mapping_file={}".format(m) for m in iwyu_mappings])
    overall_flags.extend(_safe_flags(toolchain_flags + rule_flags))

    compilation_context = target[CcInfo].compilation_context

    outputs = [_run_iwyu(ctx, iwyu_binary, overall_flags, compilation_context, src) for src in srcs]
    return [
        OutputGroupInfo(report = depset(direct = outputs)),
    ]

# NOTE(Jiaming): You may need to perform `bazel clean` if mappings/*.imp was updated.
iwyu_aspect = aspect(
    implementation = _iwyu_aspect_impl,
    fragments = ["cpp"],
    attrs = {
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "_iwyu_binary": attr.label(default = "@iwyu_prebuilt_pkg//:bin/include-what-you-use", allow_single_file = True),
        "_iwyu_mappings": attr.label(default = Label("//:iwyu_mappings")),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
