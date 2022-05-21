# -------------------------------------------------------------------
# Reusable class to create a recovery image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a recovery image / rootfs."

LICENSE = "MIT"

inherit minimal-image

WKS_FILE = "${STORAGE_TYPE}-single-partition.wks.in"

IMAGE_INSTALL += " \
    sudo \
    overlays-recovery \
    base-files-recovery \
"
