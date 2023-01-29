# -------------------------------------------------------------------
# Reusable class representing the minimal contents of a partial image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class representing the minimal contents of an image / rootfs."

LICENSE = "MIT"

inherit core-image
inherit image-with-robust-filesystem-init

# Include information about the build in the image
inherit image-buildinfo

IMAGE_INSTALL += " \
    bash \
    iproute2 \
    nano \
    rauc \
    \
    openssh \
    openssl \
    openssl-bin \
    \
    sw-mode-control \
    update-observer \
"

IMAGE_FEATURES += " \
    ssh-server-openssh \
"

# Enable this image / derived images to be referenced in wic images.
# ------------------------------------------------------------------
# Note: do_rootfs_wicenv creates the .env file containing meta information
# about the image, read by wic before processing .wks files.
addtask rootfs_wicenv after do_image before do_image_complete