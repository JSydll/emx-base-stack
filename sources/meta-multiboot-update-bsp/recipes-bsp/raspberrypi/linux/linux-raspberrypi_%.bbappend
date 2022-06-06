FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://squashfs.cfg"
CMDLINE_remove = "root=${MMC_BLOCK_DEVICE}p2 rootfstype=ext4"
