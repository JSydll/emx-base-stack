# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."
LICENSE = "MIT"

inherit partial-image

IMAGE_FSTYPES = "ext4"

IMAGE_INSTALL += " \
    robust-filesystem-system-init \
"