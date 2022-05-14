# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."

LICENSE = "MIT"

inherit minimal-image

IMAGE_FSTYPES += "wic.bz2"
WKS_FILE = "${STORAGE_TYPE}-single-partition.wks.in"

IMAGE_INSTALL += " \
    sudo \
    overlays-system \
    base-files-system \
"
