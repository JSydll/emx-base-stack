# -------------------
# Provides a failsafe filesystem initialization.
# -------------------

SUMMARY = "Provides a failsafe filesystem initialization."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

require robust-filesystem-init-config-${STORAGE_TYPE}.inc

inherit robust-filesystem-init-base

# Note: The variable FS_INIT_PERSISTENT_DEVICE needs to be set via .bbappends or local.conf
# by the users of this recipe.

SRC_URI += " \
    file://usr/bin/initialize-filesystem.sh \
    file://systemd/initialize-filesystem.service \
    file://etc/fstab_common \
"

# Provide the required systemd service
# -----
FILES:${PN} += " \
    /media \
    ${bindir}/initialize-filesystem \
    ${systemd_unitdir}/initialize-filesystem.service \
"

RDEPENDS:${PN} += " \
    bash \
"

inherit systemd

SYSTEMD_SERVICE:${PN} += "initialize-filesystem.service"

do_install:append() {
    install -d ${D}/${bindir}
    install -m 0775 ${WORKDIR}/usr/bin/initialize-filesystem.sh ${D}/${bindir}/initialize-filesystem

    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/systemd/initialize-filesystem.service ${D}/${systemd_unitdir}/system

    install -d ${D}/media

    cat ${WORKDIR}/etc/fstab_common >> ${D}/${sysconfdir}/fstab
}

