#!/bin/bash

set -e

TOP_DIR="."

# Set BUILD_TYPE via Cmdline:
#   /build_iwyu.sh RelWithDebInfo
BUILD_TYPE="${1:-Release}"
VERSION=0.20

[[ -d "${TOP_DIR}/build" ]] || mkdir "${TOP_DIR}/build"
rm -rf "${TOP_DIR}/build"/*

pushd "${TOP_DIR}/build" > /dev/null

ARCH="$(uname -m)"
DEST_DIR="/tmp/iwyu-${VERSION}-${ARCH}-linux-gnu"
export CC=/opt/llvm/bin/clang
export CXX=/opt/llvm/bin/clang++

cmake -G "Unix Makefiles" .. \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DCMAKE_PREFIX_PATH=/opt/llvm \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_INSTALL_PREFIX="${DEST_DIR}"

make -j"$(nproc)"
make install

popd > /dev/null
