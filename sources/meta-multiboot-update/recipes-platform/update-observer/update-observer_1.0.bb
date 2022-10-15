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
"

RDEPENDS:${PN} = "bash inotify-tools sw-mode-control"

SYSTEMD_SERVICE:${PN} = " \
    update-observer.service \
"

FILES:${PN} += "\
    ${sbindir}/update-observer \
    ${systemd_unitdir}/system/* \
"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    
    install -D -m 0770 ${WORKDIR}/sbin/update-observer.sh ${D}${sbindir}/update-observer
    install -m 0644 ${WORKDIR}/systemd/update-observer.service ${D}${systemd_unitdir}/system/
}