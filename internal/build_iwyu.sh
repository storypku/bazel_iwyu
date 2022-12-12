#!/bin/bash

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Set BUILD_TYPE via Cmdline:
#   /build_me.sh RelWithDebInfo
BUILD_TYPE="${1:-Release}"

[[ -d "${TOP_DIR}/build" ]] || mkdir "${TOP_DIR}/build"
rm -rf "${TOP_DIR}/build"/*

pushd "${TOP_DIR}/build" >/dev/null

ARCH="$(uname -m)"
DEST_DIR="/tmp/iwyu-${VERSION}-linux-${ARCH}"
export CC=/opt/llvm/bin/clang
export CXX=/opt/llvm/bin/clang++

cmake -G "Unix Makefiles" .. \
 -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
 -DCMAKE_PREFIX_PATH=/opt/llvm \
 -DCMAKE_VERBOSE_MAKEFILE=ON \
 -DCMAKE_INSTALL_PREFIX="${DEST_DIR}"

make -j$(nproc)
make install

popd >/dev/null
