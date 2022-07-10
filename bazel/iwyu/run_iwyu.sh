#! /bin/bash
set -u

readonly RED='\033[0;31m'
readonly RESET='\033[0m'

IWYU_BINARY="external/iwyu_prebuilt_pkg/bin/include-what-you-use"

# FIXME(storypku): The path above doesn't work for Remote execution
if [[ ! -x "${IWYU_BINARY}" ]]; then
    IWYU_BINARY="include-what-you-use"
fi

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
