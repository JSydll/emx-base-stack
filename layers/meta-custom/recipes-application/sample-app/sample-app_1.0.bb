SUMMARY = "Mimics a real-world application."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI += " \
    file://sample-app.service \
"

SYSTEMD_SERVICE:${PN} = " \
    sample-app.service \
"

FILES:${PN} += "\
    ${systemd_system_unitdir}/* \
"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sample-app.service ${D}${systemd_system_unitdir}/
}