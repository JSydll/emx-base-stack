#!/bin/bash
# -------------------------------------------
# Unified interface to manage software modes.
# -------------------------------------------
readonly COMMAND="$1"
shift

print_help() {
    cat <<EOF
Description: Unified interface to manage software modes, such as changing the software mode and updates.

Usage: ./$0 <command>

Available commands:
    status          - Print status of the software modes.
    print-active    - Print the active software mode.
    start-recovery  - Change to recovery mode.
    start-system    - Change to system mode.
    update          - Install an update bundle (parameter: path to the file).
    info            - Provide info about an update bundle (parameter: path to the file).
    help            - Print this help.
EOF
}

if [[ -z "${COMMAND}" ]]; then
    print_help
    exit 1
fi

case "${COMMAND}" in
    help)
        print_help
        ;;
    status)
        rauc status
        ;;
    print-active)
        eval "$(rauc status --output-format=shell)"
        echo "${RAUC_SYSTEM_BOOTED_BOOTNAME}"
        ;;
    start-recovery)
        rauc status mark-active recovery.0
        reboot
        ;;
    start-system)
        rauc status mark-active system.0
        reboot
        ;;
    update)
        rauc install "$1"
        ;;
    info)
        rauc info --detailed "$1"
        ;;
    *)
        echo "[ERROR] Command not supported!"
        exit 2
        ;;
esac

