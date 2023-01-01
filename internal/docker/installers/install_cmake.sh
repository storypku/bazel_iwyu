#! /bin/bash
###############################################################################
# Copyright 2020 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
set -euo pipefail

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck disable=SC1090,SC1091
. "${CURR_DIR}/installer_base.sh"

VERSION="3.25.1"
TARGET_ARCH="$(uname -m)"

if [[ "${TARGET_ARCH}" == "x86_64" ]]; then
  CMAKE_SH="cmake-${VERSION}-linux-x86_64.sh"
  CHECKSUM="6598da34f0e3a0f763809e25cfdd646aa1d5e4d133c4277821e63ae5cfe09457"
elif [[ "${TARGET_ARCH}" == "aarch64" ]]; then
  CMAKE_SH="cmake-${VERSION}-linux-aarch64.sh"
  CHECKSUM="8491a40148653b99877a49bf5ad6b33b595acc58f7ad2f60b659b63b38bb2cbf"
fi

DOWNLOAD_LINK="https://github.com/Kitware/CMake/releases/download/v${VERSION}/${CMAKE_SH}"
download_if_not_cached "${CMAKE_SH}" "${CHECKSUM}" "${DOWNLOAD_LINK}"

chmod a+x "${CMAKE_SH}"
./${CMAKE_SH} --skip-license --prefix="${SYSROOT_DIR}"
rm -rf "${CMAKE_SH}"
