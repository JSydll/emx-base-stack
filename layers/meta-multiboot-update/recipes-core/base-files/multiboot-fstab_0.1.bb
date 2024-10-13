# -------------------
# Provides a filesystem table suitable for a multiboot, readonly-rootfs setup
# -------------------

SUMMARY = "Provides a filesystem table suitable for a multiboot, readonly-rootfs setup."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RPROVIDES:${PN} = "base-files-fstab"

SRC_URI += " \
    file://etc/fstab.ro \
    file://etc/fstab.shared \
"

FILES:${PN} += " \
    ${sysconfdir}/fstab \
"

do_install() {
    install -d ${D}/${sysconfdir}

    install -m 0775 ${WORKDIR}/etc/fstab.ro ${D}/${sysconfdir}/fstab
    cat ${WORKDIR}/etc/fstab.shared >> ${D}/${sysconfdir}/fstab
}

# Storage type specific extensions
include multiboot-extramounts-${STORAGE_TYPE}.inc