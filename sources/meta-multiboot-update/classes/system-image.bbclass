# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."

LICENSE = "MIT"

inherit minimal-image

IMAGE_INSTALL += " \
    sudo \
    overlays-system \
    base-files-system \
"

IMAGE_FSTYPES = "ext4"