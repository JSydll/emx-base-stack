SUMMARY = "Provides all u-boot files required for the multiboot update setup."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

QEMU_BOOTLOADER_FILES_PACKAGE = "qemu-bootloader-files.tar.gz"

PROVIDES += "u-boot-default-script"
RPROVIDES:${PN} += "u-boot-default-script"

ALLOW_EMPTY:${PN} = "1"

SRC_URI = " \
    file://boot.script \
"

inherit deploy nopackages

DEPENDS = "u-boot-mkimage-native"
INHIBIT_DEFAULT_DEPS = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(qemuarm|qemuarm-multiboot)"

do_uboot_mkimage() {
    uboot-mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
                  -n "U-boot script" -d ${WORKDIR}/boot.script \
                  ${B}/boot.scr
}
addtask uboot_mkimage after do_compile before do_build

do_package_bootfiles() {
    mkdir -p ${WORKDIR}/bootfiles
    cp ${B}/boot.scr ${WORKDIR}/bootfiles

    bbdebug 2 "Packaging bootloader files in ${QEMU_BOOTLOADER_FILES_PACKAGE} archive..."
    tar -czf ${WORKDIR}/${QEMU_BOOTLOADER_FILES_PACKAGE} -C ${WORKDIR}/bootfiles .  
}
addtask package_bootfiles after do_uboot_mkimage before do_build

# Provide the boot files archive in the deploy dir to allow wic to pick it up
do_deploy() {
    install -d ${DEPLOYDIR}

    bbdebug 2 "Provide bootloader files in ${DEPLOY_DIR_IMAGE}..."
    install -m 0644 ${B}/boot.scr ${DEPLOYDIR}/boot.scr-${MACHINE}-${PV}-${PR}
    cd ${DEPLOYDIR}
    rm -f boot.scr
    ln -sf boot.scr-${MACHINE}-${PV}-${PR} boot.scr

    install -m 0644 ${WORKDIR}/${QEMU_BOOTLOADER_FILES_PACKAGE} ${DEPLOYDIR}

}
addtask deploy after do_package_bootfiles before do_build