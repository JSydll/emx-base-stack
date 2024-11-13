#!/bin/bash
# -------------------------------------------------------------------
# Implements an automatic update flow
#
# Observes the /media directory on the filesystem for update bundles.
# As soon as one is found, the appropriate software mode to run the
# update is started and the update is performed. After successful
# execution, the installed bundle will be removed and the system mode
# is started (if not already running).
#
# Note: This only works if there's exactly one bundle in the /media
# directory.
# -------------------------------------------------------------------

readonly UPDATE_EXTENSION="raucb"
readonly UPDATE_BASE_DIR="/media"

readonly SYSTEM_BUNDLE_PREFIX="system-update"
readonly RECOVERY_BUNDLE_PREFIX="recovery-update"

readonly OBSERVER_TIMEOUT_SEC=600 # Stop autoupdate after 10mins after boot.

function find_bundle()
{
    find "${UPDATE_BASE_DIR}" -type f -name "*.${UPDATE_EXTENSION}" -print -quit
}

echo "Checking for update bundles..."
match="$(find_bundle)"

if [[ -z "${match}" ]]; then
    echo "No bundles found yet, start observing ${UPDATE_BASE_DIR}..."

    # Note: As /media can contain mounted external devices, we cannot directly find added files
    # with inotify - as the mounted filesystems are not included in the monitored tree.
    timeout="${OBSERVER_TIMEOUT_SEC}"
    while [[ "${timeout}" -ge "0" ]]; do
        # Monitor the filesystem under /media
        start="$(date +%s)"
        if ! path="$(inotifywait --quiet -e create --recursive --timeout ${timeout} "${UPDATE_BASE_DIR}")"; then
            echo "No changes occurred in ${UPDATE_BASE_DIR}. Stop observing."
            exit 0
        fi
        sleep 2 # Account for mounted fs getting ready...
        echo "Checking change in ${path}..."
        match="$(find_bundle)"
        if [[ -n "${match}" ]]; then
            break
        fi
        echo "No update bundle triggered the change - keep observing..."
        timeout="$(( start + timeout - $(date +%s) ))"
    done
fi

echo "Update bundle found (${match})! Starting update..."

# Make sure the system is in a state where the update can be executed
active_mode="$(sw-mode-control print-active)"
if [[ "${match}" =~ ${SYSTEM_BUNDLE_PREFIX}* ]] && [[ "${active_mode}" =~ system ]]; then
    echo "Switching to recovery mode to update the system mode..."
    sw-mode-control start-recovery
fi

if [[ "${match}" =~ ${RECOVERY_BUNDLE_PREFIX}* ]] && [[ "${active_mode}" =~ recovery ]]; then
    echo "Switching to system mode to update the recovery mode..."
    sw-mode-control start-system
fi

if ! sw-mode-control update "${match}"; then
    echo "[ERROR] The update could not be installed."
    exit 2
fi

# To avoid repeated execution, remove the bundle after successful update
rm "${match}"

# By default, switch (back) to system mode
if [[ "${active_mode}" =~ recovery ]]; then
    sw-mode-control start-system
fi