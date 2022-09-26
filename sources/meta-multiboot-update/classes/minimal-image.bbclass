# -------------------------------------------------------------------
# Reusable class representing the minimal contents of an image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class representing the minimal contents of an image / rootfs."

LICENSE = "MIT"

inherit core-image

# Include information about the build in the image
inherit image-buildinfo

IMAGE_INSTALL += " \
    bash \
    iproute2 \
    man \
    nano \
    rauc \
    rsync \
    screen \
    \
    openssh \
    openssl \
    openssl-bin \
    \
    sw-mode-control \
"

IMAGE_FEATURES += "\
    ssh-server-openssh \
"

# Enable this image / derived images to be referenced in wic images.
# ------------------------------------------------------------------
# Note: do_rootfs_wicenv creates the .env file containing meta information
# about the image, read by wic before processing .wks files.
addtask rootfs_wicenv after do_image before do_image_complete