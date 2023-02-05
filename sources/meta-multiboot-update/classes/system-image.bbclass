# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."

LICENSE = "MIT"

inherit partial-image

IMAGE_INSTALL += " \
    overlays-system \
    base-files-system \
"

IMAGE_FSTYPES = "ext4"