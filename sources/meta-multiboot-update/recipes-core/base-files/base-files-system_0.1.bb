# -------------------------------------------------------------------
# Base file provisioning for the system image
# -------------------------------------------------------------------
SUMMARY = "Base file provisioning for the system image."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "base-files"
RDEPENDS:${PN} += "overlays-system"

require fstab-common.inc

SRC_URI += " \
    file://fstab_system \
"

do_install:append() {
    cat ${WORKDIR}/fstab_system >> ${D}${sysconfdir}/fstab
}