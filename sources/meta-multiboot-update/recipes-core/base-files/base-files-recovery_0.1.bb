# -------------------------------------------------------------------
# Base file provisioning for the recovery image
# -------------------------------------------------------------------
SUMMARY = "Base file provisioning for the recovery image."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "base-files"
RDEPENDS_${PN} += "overlays-recovery"

require fstab-common.inc

SRC_URI += " \
    file://fstab_recovery \
"

do_install_append() {
    cat ${WORKDIR}/fstab_recovery >> ${D}${sysconfdir}/fstab
}