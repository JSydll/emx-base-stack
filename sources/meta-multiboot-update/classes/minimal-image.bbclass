# -------------------------------------------------------------------
# Reusable class representing the minimal contents of an image / rootfs.
# -------------------------------------------------------------------
SUMMARY = "Reusable class representing the minimal contents of an image / rootfs."

LICENSE = "MIT"

inherit core-image

IMAGE_INSTALL += " \
    iproute2 \
    man \
    nano \
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