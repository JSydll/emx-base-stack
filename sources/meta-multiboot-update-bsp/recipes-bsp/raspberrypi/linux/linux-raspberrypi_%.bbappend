FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://rauc.cfg"
CMDLINE_remove = "root=${MMC_BLOCK_DEVICE}p2"
