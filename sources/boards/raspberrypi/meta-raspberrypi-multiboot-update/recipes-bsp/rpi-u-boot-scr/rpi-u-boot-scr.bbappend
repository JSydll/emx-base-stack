inherit logging

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://boot.cmd.pre.in"

# TODO: Derive from MMC_BLOCK_DEVICE
MMC_BLOCK_DEVICE_NUM ?= "0"

# Show native linux boot messages
RPI_EXTRA_KERNEL_CMD ?= "console=tty1 vt.global_cursor_default=0"

do_compile_prepend() {
    bbdebug 2 "Collecting default kernel command line arguments from cmdline.txt..."
    default_bootargs="$(cat ${DEPLOY_DIR_IMAGE}/${BOOTFILES_DIR_NAME}/cmdline.txt) ${RPI_EXTRA_KERNEL_CMD}"

    bbdebug 2 "Setting mmc block device to ${MMC_BLOCK_DEVICE_NUM}, DTB file to ${DTB_FILE_NAME} and kernel default arguments to '${default_bootargs}'..."
    sed -e "s/@@MMC_BLOCK_DEVICE_NUM@@/${MMC_BLOCK_DEVICE_NUM}/" \
        -e "s/@@DTB_FILE_NAME@@/${DTB_FILE_NAME}/" \
        -e "s/@@DEFAULT_BOOTARGS@@/${default_bootargs}/" \
        "${WORKDIR}/boot.cmd.pre.in" > "${WORKDIR}/boot.cmd.in"
}
do_compile[depends] += " \
    linux-raspberrypi:do_deploy \
"