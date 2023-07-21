# Steps to Build IWYU 0.20
The Dockerfile is set up to build in two stages. First, you will build the builder container. Second, you will export the output files into a tar package.

## Building IWYU using the Dockerfile
From the root of the repo:
```
cd internal
docker build -f docker/ubuntu2204.builder.dockerfile --tag=bazel_iwyu/builder .
```

### Export build artifacts for x86_64

```
docker build -f docker/ubuntu2204.dockerfile --output type=local,dest=iwyu-0.20-x86_64-linux-gnu --target=x86_64 .
```

### Export build artifacts for aarch64
```
docker build -f docker/ubuntu2204.dockerfile --output type=local,dest=iwyu-0.20-aarch64-linux-gnu --target=aarch64 .
```

## Post-build
A directory containing the build artifacts will be located at: `internal/iwyu-0.20-{ARCH}-linux-gnu`

To package this folder as a `.tar.xz`:
```
tar -cJf iwyu-0.20-{ARCH}-linux-gnu.tar.xz iwyu-0.20-{ARCH}-linux-gnu/
```

# About angle-bracket-curse
In the steps above, a patch named `p01_angle_quote_curse_dirty_fix.patch` was applied to workaround the "angle-quote-curse" issue.
See [IWYU Issues on angle-quote-curse](https://github.com/include-what-you-use/include-what-you-use/issues?q=angle+label%3Aangle-quote-curse) for details.
We should remove it once upstream has the forementioned issue fixed.

