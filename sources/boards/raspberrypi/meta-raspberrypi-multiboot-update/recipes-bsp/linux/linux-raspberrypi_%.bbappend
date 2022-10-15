FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://squashfs.cfg"
CMDLINE:remove = "root=/dev/${MMC_BLOCK_DEVICE}p2 rootfstype=ext4"
