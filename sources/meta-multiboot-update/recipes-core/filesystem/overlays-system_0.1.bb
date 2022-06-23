# -------------------------------------------------------------------
# Overlays for the system image
# -------------------------------------------------------------------
SUMMARY = "Overlays for the system image."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

require overlays.inc

SRC_URI += " \
    file://sbin/setup-overlays-system \
"

do_install_append() {
    install -m 755 ${WORKDIR}/sbin/setup-overlays-system ${D}/${sbindir}/setup-overlays
}