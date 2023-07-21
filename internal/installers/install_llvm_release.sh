#!/bin/bash
set -e

ARCH="$(uname -m)"

if [[ "${ARCH}" == "x86_64" ]]; then
    PKG_NAME="clang+llvm-16.0.4-x86_64-linux-gnu-ubuntu-22.04.tar.xz"
elif [[ "${ARCH}" == "aarch64" ]]; then
    PKG_NAME="clang+llvm-16.0.4-aarch64-linux-gnu.tar.xz"
else
    echo >&2 "CPU architecture \"${ARCH}\" is unsupported by this script."
    exit 1
fi

DOWNLOAD_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/${PKG_NAME}"

[[ -d /opt/llvm ]] && rm -rf /opt/llvm || true
mkdir /opt/llvm

wget --progress=dot:giga "${DOWNLOAD_URL}" \

tar xJf "${PKG_NAME}" \
       --strip-components=1 -C /opt/llvm

rm "${PKG_NAME}"
