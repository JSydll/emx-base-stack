FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://boot.cmd.in"

do_compile_prepend() {
    sed -e 's/@@MMC_BLOCK_DEVICE@@/${MMC_BLOCK_DEVICE}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd.in"
}