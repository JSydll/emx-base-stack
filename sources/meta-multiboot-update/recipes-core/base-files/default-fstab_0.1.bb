# -------------------
# Provides a default filesystem table
# -------------------

SUMMARY = "Provides a default filesystem table."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RPROVIDES:${PN} = "base-files-fstab"

SRC_URI += " \
    file://etc/fstab.default \
"

FILES:${PN} += " \
    ${sysconfdir}/fstab \
"

do_install() {
    install -d ${D}/${sysconfdir}
    install -m 0775 ${WORKDIR}/etc/fstab.default ${D}/${sysconfdir}/fstab
}