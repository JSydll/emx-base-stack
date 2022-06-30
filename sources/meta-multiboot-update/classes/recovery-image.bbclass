# -------------------------------------------------------------------
# Reusable class to create a recovery image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a recovery image / rootfs."

LICENSE = "MIT"

inherit minimal-image

IMAGE_ROOTFS_FSTYPE = "squashfs"
WKS_FILE = "${STORAGE_TYPE}-single-slot.wks.in"

inherit deploy-single-slot-partitions

IMAGE_INSTALL += " \
    sudo \
    overlays-recovery \
    base-files-recovery \
"

IMAGE_FSTYPES = "squashfs wic.bz2"