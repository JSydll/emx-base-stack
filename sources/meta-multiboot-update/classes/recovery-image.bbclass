# -------------------------------------------------------------------
# Reusable class to create a recovery image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a recovery image / rootfs."

LICENSE = "MIT"

inherit minimal-image

IMAGE_ROOTFS_FSTYPE = "squashfs"
WKS_FILE = "${STORAGE_TYPE}-single-slot.wks.in"

RAUC_SLOT_BOOT_TYPE = "vfat"
RAUC_SLOT_ROOTFS_TYPE = "img"
inherit deploy-single-slot-partitions

IMAGE_INSTALL += " \
    sudo \
    overlays-recovery \
    base-files-recovery \
"

IMAGE_FSTYPES = "${IMAGE_ROOTFS_FSTYPE} wic.bz2"

# --------------
# Postprocessing
# --------------

postprocess_recovery_image() {
    # Mark the distro as recovery
    sed -i 's/\b [0-9]\b/ (recovery)&/' ${IMAGE_ROOTFS}${sysconfdir}/issue
}

ROOTFS_POSTPROCESS_COMMAND += "postprocess_recovery_image; "