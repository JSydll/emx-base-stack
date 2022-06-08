inherit logging

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://boot.cmd.pre.in"

# TODO: Derive from MMC_BLOCK_DEVICE
MMC_BLOCK_DEVICE_NUM ?= "0"

do_compile_prepend() {
    bbdebug 2 "Setting mmc block device to ${MMC_BLOCK_DEVICE_NUM} and DTB file to ${DTB_FILE_NAME}..."
    sed -e 's/@@MMC_BLOCK_DEVICE_NUM@@/${MMC_BLOCK_DEVICE_NUM}/' \
        -e 's/@@DTB_FILE_NAME@@/${DTB_FILE_NAME}/' \
        "${WORKDIR}/boot.cmd.pre.in" > "${WORKDIR}/boot.cmd.in"
}