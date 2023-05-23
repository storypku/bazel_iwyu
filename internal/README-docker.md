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
docker build -f docker/ubuntu2204.dockerfile --output type=tar,dest=iwyu-0.20-x86_64-linux-gnu.tar --target=x86_64 .
```

### Export build artifacts for aarch64
```
docker build -f docker/ubuntu2204.dockerfile --output type=tar,dest=iwyu-0.20-aarch64-linux-gnu.tar --target=aarch64 .
```

## Post-build
A tar file containing the build artifacts will be located at: `internal/iwyu-0.20-{ARCH}-linux-gnu.tar`

To install the build artifacts in e.g. `/usr/local`:
```
sudo tar -xf iwyu-0.20-x86_64-linux-gnu.tar -C /usr/local
```
