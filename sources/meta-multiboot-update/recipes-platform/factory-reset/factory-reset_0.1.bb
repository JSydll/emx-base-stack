# -------------------
# Remove all runtime data from the system.
# -------------------

SUMMARY = "Remove all runtime data from the system."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://usr/bin/factory-reset.sh \
"

FILES:${PN} += " \
    ${bindir}/factory-reset \
"

RDEPENDS:${PN} += " \
    bash \
    overlay-control \
    robust-filesystem-init \
"

do_install:append() {
    install -d ${D}/${bindir}
    install -m 0775 ${WORKDIR}/usr/bin/factory-reset.sh ${D}/${bindir}/factory-reset
}