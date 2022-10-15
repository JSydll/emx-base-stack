#!/bin/bash -e
# ------------------
# run-env.sh
# 
# Initializes and enters/runs a command in the Yocto build environment.
#
# ------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR

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

  - raspberrypi3
  - qemux86-64

For these, the following images can be built:

  - full-image              - Builds the full image (including recovery & system) with the configured sub-images.
  - system-update-bundle    - Builds a system update bundle with the configured sub-image.
  - recovery-update-bundle  - Builds a recovery update bundle with the configured sub-image.

  - custom-recovery-image   - Builds the recovery image only, with custom applications included.
  - custom-system-image     - Builds the system image only, with custom applications included.

EOF
}

function rebuild_environment()
{
  ./environment/build.sh --env-file "${SCRIPT_DIR}/.env" --base-only
}

# ----------------------
# Command line arguments
# ----------------------

POSITIONAL_ARGS=()
while (( $# )); do
  case "$1" in
  --rebuild)
    rebuild_environment
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

print_features

export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} \
  BSP_LAYERS \
"

# Extend whitelist with variables from meta-common-emx
# shellcheck disable=SC1091
. ./sources/meta-common-emx/scripts/whitelisting.sh

./environment/init.sh --env-file "${SCRIPT_DIR}/.env" "${POSITIONAL_ARGS[@]}"