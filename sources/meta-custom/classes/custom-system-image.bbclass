# -------------------------------------------------------------------
# Customized system image / rootfs
# -------------------------------------------------------------------
SUMMARY = "Customized system image / rootfs."

LICENSE = "MIT"

inherit system-image
inherit set-root-pwd

IMAGE_INSTALL += " \
    loadkeys \
    static-ip-config \
    wifi-ap-config \
"