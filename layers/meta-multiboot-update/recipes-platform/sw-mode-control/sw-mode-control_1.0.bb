# -------------------
# Provides an executable to control the software modes
# -------------------

SUMMARY = "Provides an executable to control the software modes"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://usr/bin/sw-mode-control.sh \
"

RDEPENDS:${PN} = "bash rauc"

do_install() {
    install -D -m 0770 ${WORKDIR}/usr/bin/sw-mode-control.sh ${D}${bindir}/sw-mode-control
}