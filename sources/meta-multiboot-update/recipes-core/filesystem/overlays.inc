RDEPENDS:${PN} += "bash overlay-control"

SRC_URI += " \
    file://systemd/overlay-setup.service \
    file://usr/bin/factory-reset.sh \
"

SYSTEMD_SERVICE:${PN} = " \
    overlay-setup.service \
"

FILES:${PN} += "\
    ${localstatedir}/* \
    ${systemd_unitdir}/system/* \
    ${sbindir}/* \
    ${bindir}/factory-reset \
"

do_install() {
    # Mount-point for the persistent data partition
    install -d ${D}/${localstatedir}/persistent

    # Project specific data directories
    install -d ${D}/${localstatedir}/data
    install -d ${D}/${localstatedir}/media

    install -d ${D}/${systemd_unitdir}/system
    install -m 644 ${WORKDIR}/systemd/overlay-setup.service ${D}/${systemd_unitdir}/system/
    
    install -d ${D}/${sbindir}

    install -d ${D}/${bindir}
    install -m 770 ${WORKDIR}/usr/bin/factory-reset.sh ${D}/${bindir}/factory-reset
}