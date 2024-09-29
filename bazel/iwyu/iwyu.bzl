load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    "CPP_COMPILE_ACTION_NAME",
    "C_COMPILE_ACTION_NAME",
)
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

_CPP_HEADER_EXTENSIONS = ["hh", "hxx", "ipp", "hpp"]
_C_OR_CPP_HEADER_EXTENSIONS = ["h"] + _CPP_HEADER_EXTENSIONS
_CPP_EXTENSIONS = ["cc", "cpp", "cxx"] + _CPP_HEADER_EXTENSIONS
_CUDA_EXTENSIONS = ["cu", "cuh"]

def _is_cpp_target(srcs):
    if all([src.extension in _C_OR_CPP_HEADER_EXTENSIONS for src in srcs]):
        return True  # assume header-only lib in C++
    return any([src.extension in _CPP_EXTENSIONS for src in srcs])

def _is_cuda_target(srcs):
    return any([src.extension in _CUDA_EXTENSIONS for src in srcs])

def _collect_cc_info(ctx):
    cc_infos = []
    for dep in ctx.rule.attr.deps:
        if CcInfo in dep:
            cc_infos.append(dep[CcInfo])
    if hasattr(ctx.rule.attr, "implementation_deps"):
        for dep in ctx.rule.attr.implementation_deps:
            if CcInfo in dep:
                cc_infos.append(dep[CcInfo])
    return cc_infos

def _run_iwyu(ctx, iwyu_executable, iwyu_mappings, iwyu_options, flags, target, infile):
    cc_infos = [target[CcInfo]] + _collect_cc_info(ctx)
    merged_cc_info = cc_common.merge_cc_infos(cc_infos = cc_infos)
    compilation_context = merged_cc_info.compilation_context

    outfile = ctx.actions.declare_file(
        "{}.{}.iwyu.txt".format(target.label.name, infile.basename),
    )

    # add args specified by iwyu_options, the toolchain, on the command line and rule copts
    args = ctx.actions.args()
    args.add(outfile)

    args.add_all(iwyu_options, before_each = "-Xiwyu")
    args.add_all(["--mapping_file={}".format(m.path) for m in iwyu_mappings], before_each = "-Xiwyu")
    args.add_all(flags)

    # add defines
    for define in compilation_context.defines.to_list():
        args.add("-D" + define)

    for define in compilation_context.local_defines.to_list():
        args.add("-D" + define)

    # add includes
    for inc in compilation_context.framework_includes.to_list():
        args.add("-F" + inc)

    for inc in compilation_context.includes.to_list():
        args.add("-I" + inc)

    args.add_all(compilation_context.quote_includes.to_list(), before_each = "-iquote")
    args.add_all(compilation_context.system_includes.to_list(), before_each = "-isystem")

    # add source to check
    args.add(infile)

    inputs = depset(
        direct = [infile] + iwyu_mappings,
        transitive = [compilation_context.headers],
    )

    # https://github.com/bazelbuild/bazel/issues/5511
    ctx.actions.run(
        inputs = inputs,
        outputs = [outfile],
        arguments = [args],
        executable = iwyu_executable,
        # It seems no-sandbox was required for x-compilation support
        execution_requirements = {
            "no-sandbox": "1",
        },
        mnemonic = "iwyu",
        progress_message = "Run include-what-you-use on {}".format(infile.short_path),
    )
    return outfile

def _rule_sources(ctx):
    srcs = []
    if hasattr(ctx.rule.attr, "srcs"):
        for src in ctx.rule.attr.srcs:
            # https://bazel.build/rules/lib/File#is_source
            srcs += [f for f in src.files.to_list() if f.is_source]
    return srcs

def _toolchain_flags(ctx, is_cpp_target):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    if is_cpp_target:
        compile_variables = cc_common.create_compile_variables(
            feature_configuration = feature_configuration,
            cc_toolchain = cc_toolchain,
            user_compile_flags = ctx.fragments.cpp.cxxopts + ctx.fragments.cpp.copts,
            add_legacy_cxx_options = True,
        )
        flags = cc_common.get_memory_inefficient_command_line(
            feature_configuration = feature_configuration,
            action_name = CPP_COMPILE_ACTION_NAME,
            variables = compile_variables,
        )
    else:
        compile_variables = cc_common.create_compile_variables(
            feature_configuration = feature_configuration,
            cc_toolchain = cc_toolchain,
            user_compile_flags = ctx.fragments.cpp.copts,
        )
        flags = cc_common.get_memory_inefficient_command_line(
            feature_configuration = feature_configuration,
            action_name = C_COMPILE_ACTION_NAME,
            variables = compile_variables,
        )
    return flags

def _safe_flags(flags):
    # Some flags might be used by GCC, but not understood by Clang.
    # Remove them here, to allow users to run IWYU, without having
    # a clang toolchain configured (that would produce a good command line with --compiler clang)
    unsupported_flags = [
        "-fno-canonical-system-headers",
        "-fstack-usage",
    ]

    return [flag for flag in flags if flag not in unsupported_flags]

def _iwyu_aspect_impl(target, ctx):
    # Interested in C, C++, and CUDA (not-ready) targets only
    if not CcInfo in target:
        return []

    srcs = _rule_sources(ctx)

    # Ref: https://github.com/include-what-you-use/include-what-you-use/issues/950
    if len(srcs) == 0 or _is_cuda_target(srcs):
        return []

    iwyu_executable = ctx.attr._iwyu_executable.files_to_run
    iwyu_mappings = ctx.attr._iwyu_mappings.files.to_list()
    iwyu_options = ctx.attr._iwyu_opts[BuildSettingInfo].value

    is_cpp_target = _is_cpp_target(srcs)
    toolchain_flags = _toolchain_flags(ctx, is_cpp_target)

    rule_flags = ["-x", "c++"] if is_cpp_target else []
    if hasattr(ctx.rule.attr, "copts"):
        rule_flags.extend(ctx.rule.attr.copts)

    all_flags = _safe_flags(toolchain_flags + rule_flags)

    outputs = [
        _run_iwyu(ctx, iwyu_executable, iwyu_mappings, iwyu_options, all_flags, target, src)
        for src in srcs
    ]
    return [
        OutputGroupInfo(report = depset(direct = outputs)),
    ]

# NOTE(storypku): You may need to perform `bazel clean` if mappings/*.imp were updated.
iwyu_aspect = aspect(
    implementation = _iwyu_aspect_impl,
    fragments = ["cpp"],
    attrs = {
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
        "_iwyu_executable": attr.label(default = Label("//bazel/iwyu:run_iwyu")),
        "_iwyu_mappings": attr.label(default = Label("//:iwyu_mappings")),
        "_iwyu_opts": attr.label(default = Label("//:iwyu_opts")),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
