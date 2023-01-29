# -------------------------------------------------------------------
# Reusable class to create a system image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class to create a system image / rootfs."

LICENSE = "MIT"

FS_INIT_RECIPE_NAME = "robust-filesystem-system-init"

inherit partial-image

IMAGE_FSTYPES = "ext4"