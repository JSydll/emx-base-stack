FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Enable kernel features required by rauc or related update processes
SRC_URI += " \
    file://rauc.cfg \
"

CMDLINE:remove = "root=/dev/${MMC_BLOCK_DEVICE}p2 rootfstype=ext4"
