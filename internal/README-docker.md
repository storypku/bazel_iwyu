# Steps to Build IWYU 0.20

## Building IWYU for x86_64 Linux using the Dockerfile
```
cd internal
docker build -f docker/ubuntu2204.x86_64.dockerfile --tag=iwyu --output type=tar,dest=iwyu-0.20-x86_64-linux-gnu.tar .
```
A tar file containing the build artifacts will be located at `internal/iwyu-0.20-x86_64-linux-gnu.tar`.

To install the build artifacts in e.g. `/usr/local`:
```
sudo tar -xf iwyu-0.20-x86_64-linux-gnu.tar -C /usr/local
```
