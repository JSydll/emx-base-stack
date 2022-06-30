# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."

LICENSE = "MIT"

inherit minimal-image

IMAGE_ROOTFS_FSTYPE = "ext4"
WKS_FILE = "${STORAGE_TYPE}-single-slot.wks.in"

inherit deploy-single-slot-partitions

IMAGE_INSTALL += " \
    sudo \
    overlays-system \
    base-files-system \
"

IMAGE_FSTYPES = "ext4 wic.bz2"