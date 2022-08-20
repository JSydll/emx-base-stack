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
"

IMAGE_FEATURES += "\
    ssh-server-openssh \
"