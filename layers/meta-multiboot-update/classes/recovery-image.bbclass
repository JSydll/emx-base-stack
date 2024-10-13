# -------------------------------------------------------------------
# Reusable class to create a recovery image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a recovery image / rootfs."
LICENSE = "MIT"

inherit partial-image

IMAGE_FSTYPES = "squashfs"

IMAGE_INSTALL += " \
    robust-filesystem-recovery-init \
"

# --------------
# Postprocessing
# --------------

postprocess_recovery_image() {
    # Mark the distro as recovery
    sed -i 's/\b [0-9]\b/ (recovery)&/' ${IMAGE_ROOTFS}${sysconfdir}/issue
}

ROOTFS_POSTPROCESS_COMMAND += "postprocess_recovery_image; "