#!/bin/bash
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/environment.sh"

# --- Functions ---

function print_help() {
    cat <<EOF
Interface to control the update backend.

Usage: $0 [-h] <init|start|stop|clean>

Options:
    -h|--help       Prints this help.

Positional arguments:
    <init>          Initializes (and recreates) all services.
    <start>         (Re)starts all services.
    <stop>          Stops the running services.
    <clean>         Shuts down and cleans up all services.
EOF
}

# --- Parameter processing and execution ---

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        init)
            docker-compose -f "${DOCKER_COMPOSE_PATH}" up -d
            exit $?
            ;;
        start)
            docker-compose -f "${DOCKER_COMPOSE_PATH}" start
            exit $?
            ;;
        stop)
            docker-compose -f "${DOCKER_COMPOSE_PATH}" stop
            exit $?
            ;;
        clean)
            docker-compose -f "${DOCKER_COMPOSE_PATH}" down
            exit $?
            ;;
        *)
            ;;
    esac
    shift # past option
done

