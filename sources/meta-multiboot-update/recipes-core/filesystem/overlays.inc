RDEPENDS_${PN} += "bash"

SRC_URI += " \
    file://systemd/overlay-setup.service \
"

SYSTEMD_SERVICE_${PN} = " \
    overlay-setup.service \
"

FILES_${PN} += "\
    ${sbindir}/* \
    ${localstatedir} \
    ${sysconfdir} \
    ${systemd_unitdir}/system/* \
    home \
"

do_install() {
    install -d ${D}/${localstatedir}/app
    install -d ${D}/${systemd_unitdir}/system
    install -m 644 ${WORKDIR}/systemd/overlay-setup.service ${D}/${systemd_unitdir}/system/
    install -d ${D}/${sbindir}
}