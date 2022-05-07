#!/bin/bash -e
# ------------------
# run-env.sh
# 
# Initializes and enters/runs a command in the Yocto build environment.
#
# ------------------
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

function print_help()
{
  cat <<EOF 
Syntax: ./$(basename "$0") [-h|--help] [--rebuild] [<command>]

Initializes and enters/runs a command in the Yocto build environment.

Any positional arguments are passed to the environment to be executed in a one-shot manner.

Options:
  -h|--help      - Print this help.
  --rebuild      - Build the base image before starting.
EOF
}

function print_features()
{
  cat <<EOF
## Embedded Linux Base Stack ##

The reference implementation currently supports the following boards:

  - raspberrypi3-mb     - Includes: Multiboot, update.

For these, the following images can be built:

  - full-[dev|prod]-image
  - slot-[dev|prod]-image
  - update-bundle

EOF
}

# ----------------------
# Command line arguments
# ----------------------

POSITIONAL_ARGS=()
while (( $# )); do
  case "$1" in
  --rebuild)
    REBUILD="yes"
    ;;
  -h|--help)
    print_help
    exit 0
    ;;
  *)
    POSITIONAL_ARGS+=("$1")
    ;;
  esac
  shift
done

# ---------
# Execution
# ---------

if [[ "${REBUILD}" == "yes" ]]; then
  ./environment/build.sh --env-file "${SCRIPT_DIR}/.env" --base-only
fi

print_features

./environment/init.sh --env-file "${SCRIPT_DIR}/.env" "${POSITIONAL_ARGS[@]}"