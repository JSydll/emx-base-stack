# -------------------
# Installs a filesystem observer for update bundles.
# -------------------

SUMMARY = "Installs a filesystem observer that triggers an update as soon as an update bundle is found."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI += " \
    file://sbin/update-observer.sh \
    file://systemd/update-observer.service \
    file://systemd/regular-operation.target \
"

RDEPENDS:${PN} = "bash inotify-tools sw-mode-control"

SYSTEMD_SERVICE:${PN} = " \
    update-observer.service \
    regular-operation.target \
"

FILES:${PN} += "\
    ${sbindir}/update-observer \
    ${systemd_system_unitdir}/* \
"

do_install() {
    install -d ${D}${sbindir}
    install -d ${D}${systemd_system_unitdir}
    
    install -D -m 0770 ${WORKDIR}/sbin/update-observer.sh ${D}${sbindir}/update-observer
    install -m 0644 ${WORKDIR}/systemd/update-observer.service ${D}${systemd_system_unitdir}

    install -m 0644 ${WORKDIR}/systemd/regular-operation.target ${D}${systemd_system_unitdir}
}