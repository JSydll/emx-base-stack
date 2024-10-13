# -------------------------------------------------------------------
# Bootloader file packaging
# -------------------------------------------------------------------
DESCRIPTION = "Creates an archive of the raspberrypi specific bootloader files."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit logging

INHIBIT_DEFAULT_DEPS = "1"

inherit deploy nopackages

PACKAGE_ARCH = "${MACHINE_ARCH}"

RPI_BOOTLOADER_FILES_PACKAGE = "rpi-bootloader-files.tar.gz"

do_compile() {
    bbdebug 2 "Collecting bootloader files (${RPI_BOOTLOADER_FILES}) from ${DEPLOY_DIR_IMAGE}..."
    mkdir -p ${WORKDIR}/files
    for f in ${RPI_BOOTLOADER_FILES}; do
        cp ${DEPLOY_DIR_IMAGE}/${f} ${WORKDIR}/files
    done

    bbdebug 2 "Adding bootloader files in ${WORKDIR}/files to archive..."
    tar -czf ${RPI_BOOTLOADER_FILES_PACKAGE} -C ${WORKDIR}/files .
}
do_compile[depends] += " \
    rpi-bootfiles:do_deploy \
    rpi-config:do_deploy \
    u-boot:do_deploy \
    u-boot-default-script:do_deploy \
"

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${RPI_BOOTLOADER_FILES_PACKAGE} ${DEPLOYDIR}
}
addtask do_deploy after do_compile before do_build


