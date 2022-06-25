# -------------------------------------------------------------------
# Customized recovery image / rootfs
# -------------------------------------------------------------------
SUMMARY = "Customized recovery image / rootfs."

LICENSE = "MIT"

inherit recovery-image

IMAGE_INSTALL += " \
    loadkeys \
    static-ip-config \
    wifi-ap-config \
"