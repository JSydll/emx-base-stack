FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://boot.cmd.in"

# TODO: Derive from MMC_BLOCK_DEVICE
MMC_BLOCK_DEVICE_NUM ?= "0"

do_compile_prepend() {
    sed -e 's/@@MMC_BLOCK_DEVICE_NUM@@/${MMC_BLOCK_DEVICE_NUM}/' \
        -e 's/@@DTB_FILE_NAME@@/${DTB_FILE_NAME}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd.in"
}