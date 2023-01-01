#! /bin/bash

# Ref: https://github.com/bazelbuild/bazel/blob/d2750262695b1cef7365e5491711ce411cd85215/tools/bash/runfiles/runfiles.bash
# Stack Overflow: https://stackoverflow.com/questions/53472993/how-do-i-make-a-bazel-sh-binary-target-depend-on-other-binary-targets

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail
f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2> /dev/null \
  || source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2> /dev/null \
  || source "$0.runfiles/$f" 2> /dev/null \
  || source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2> /dev/null \
  || source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2> /dev/null \
  || {
    echo >&2 "ERROR: cannot find $f"
    exit 1
  }
f=
set -e
# --- end runfiles.bash initialization v2 ---

set -euo pipefail

readonly RED='\033[0;31m'
readonly RESET='\033[0m'

IWYU_BINARY="$(rlocation iwyu_prebuilt_pkg/bin/include-what-you-use)"

function error() {
  (echo >&2 -e "${RED}[ERROR]${RESET} $*")
}

OUTPUT="$1"
shift

touch "${OUTPUT}"
truncate -s 0 "${OUTPUT}"

if ! "${IWYU_BINARY}" "$@" 2> "${OUTPUT}"; then
  error "IWYU violation found. Fixes have been written to ${OUTPUT}"
  cat "${OUTPUT}"
  exit 1
fi
