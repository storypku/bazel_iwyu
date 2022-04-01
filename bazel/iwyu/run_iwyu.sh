#!/bin/bash
set -euo pipefail

# Usage: run_iwyu.sh <OUTPUT> [ARGS...]

OUTPUT=$1
shift

IWYU_BIN="${LLVM_DIR:-/opt/llvm}/bin/include-what-you-use"

if [[ ! -x "${IWYU_BIN}" ]]; then
	echo >&2 "[Warning]: ${IWYU_BIN} doesn't exist or is not executable."
	IWYU_BIN="$(command -v include-what-you-use)"
	if [[ -z "${IWYU_BIN}" ]]; then
		echo >&2 "Error: command 'include-what-you-use' not found on PATH"
	fi
fi

echo >&2 "[OK]: IWYU output will be saved to ${OUTPUT}"

# touch $OUTPUT
# truncate -s 0 $OUTPUT

"${IWYU_BIN}" "$@" &>"${OUTPUT}" || exit 0
