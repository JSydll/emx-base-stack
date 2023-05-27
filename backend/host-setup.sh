#!/bin/bash
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd)"

readonly APT_PACKAGES=(
    git
    docker
    docker-compose
)
readonly UPSTREAM_GIT="https://github.com/eclipse/hawkbit"

# --- Functions ---

function print_help() {
    cat <<EOF
Script to setup an update backend on the current machine.

Usage: $0 [-h] <install_dir>

Options:
    -h|--help       Prints this help.

Positional arguments:
    <install_dir>   Destination path to where the required sources shall be unpacked.
EOF
}

function is_required() {
    local -r var_name="$1"
    if [[ -z "$(echo "\$${var_name}")" ]]; then
        echo "Required parameter ${var_name} not set!"
        exit 1
    fi
}

function install_required_packages() {
    for pkg in "${APT_PACKAGES[@]}"; do
        if ! "${pkg}" --version; then
            sudo apt install -y "${pkg}"
        fi 
    done
}

function checkout_latest_upstream() {
    if [[ -e "${HAWKBIT_SOURCE_DIR}" ]]; then
        (cd "${HAWKBIT_SOURCE_DIR}" && git reset --hard origin/master)
    else
        git clone -b master "${UPSTREAM_GIT}" "${HAWKBIT_SOURCE_DIR}"
    fi
}

function patch_known_issues() {
    # https://github.com/eclipse/hawkbit/issues/1366: Bump up the MySQL version to 8.0
    sed -i 's|mysql:5.7|mysql:8.0|' "${HAWKBIT_SOURCE_DIR}/hawkbit-runtime/docker/docker-compose.yml"
}

function install_scripts() {
    cp -r "${SCRIPT_DIR}/run" "${INSTALL_DIR}"

    # Configure the installation environment
    sed -i 's|%%HAWKBIT_REPO%%|'"${HAWKBIT_SOURCE_DIR}"'|' "${INSTALL_DIR}/run/environment.sh"
}

# --- Parameter processing ---

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -i|--install_dir)
            readonly INSTALL_DIR="$2"
            shift # past value
            ;;
        -*|--*)
            echo "Unknown option $i"
            exit 1
            ;;
        *)
            ;;
    esac
    shift # past option
done

is_required INSTALL_DIR

# --- Execution ---

readonly HAWKBIT_SOURCE_DIR="${INSTALL_DIR}/hawkbit"

echo "Preparing installation..."
mkdir -pf "${INSTALL_DIR}"

echo "Installing required packages..."
install_required_packages

echo "Checking out latest upstream sources in ${INSTALL_DIR}/hawkbit..."
checkout_latest_upstream
# This shall be removed as soon as upstream issues are resolved:
patch_known_issues

echo "Installing scripts..."
install_scripts