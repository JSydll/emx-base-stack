# -------------------
# Sets up a deterministic and failsafe filesystem based on a read-only rootfs.
# -------------------
#
# It assumes a persistent memory location outside of the rootfs to be mounted
# for all writable areas where changes shall persist over a powercycle.
#
# If the mounting of this external persistent space fails, a volatile filesystem
# is provided instead.
#
# The persistent memory device must be specified using the FS_PERSISTENT_DEVICE
# variable.

inherit logging

FS_PERSISTENT_DEVICE[doc] = "Defines the memory device to be used for persistent data. Attention: Must be a basic /dev/* path!"
FS_SOFTWARE_MODE[doc]     = "Defines the software mode the system is running in - useful to separate data between system and recovery data. Defaults to 'system'."
FS_PARTITION_TYPE[doc]    = "Type of partition used for the persistent filesystem. Defaults to 'ext4'."

FS_SOFTWARE_MODE   ?= "system"
FS_PARTITION_TYPE  ?= "ext4"

# Storage type specific extensions
require robust-filesystem-init-config-${STORAGE_TYPE}.inc

python() {
    dev_path = d.getVar("FS_PERSISTENT_DEVICE", True)
    if dev_path == "" or "/dev/" not in dev_path:
        bb.fatal("Variable 'FS_PERSISTENT_DEVICE' not set properly!")
}

SRC_URI += " \
    file://sbin/pre-init.j2 \
"

# Install guaranteed mountpoints and directories
# -----
FILES:${PN} += " \
    ${localstatedir}/* \
"

do_install() {
    install -d ${D}${localstatedir}/mounts/persistent
    install -d ${D}${localstatedir}/volatile-overlays

    install -d ${D}${localstatedir}/persistent/private
    install -d ${D}${localstatedir}/persistent/shared
}

# Install the pre-init script
# -----

inherit templating

FILES:${PN} += " \
    /sbin/${FS_PRE_INIT_NAME} \
"

PRE_INIT_TEMPLATE_PATH = "${WORKDIR}/pre-init.j2"

python do_patch() {
    params = { 
        "original_init_name" : d.getVar('FS_ORIGINAL_INIT_NAME', True), 
        "persistent_device" : d.getVar('FS_PERSISTENT_DEVICE', True),
        "partition_type" : d.getVar('FS_PARTITION_TYPE', True),
        "software_mode" : d.getVar('FS_SOFTWARE_MODE', True),
    }
    render_template(d.getVar('PRE_INIT_TEMPLATE_PATH', True), params)
}

do_install:append() {
    install -d ${D}/sbin
    install -m 0775 ${WORKDIR}/pre-init ${D}/sbin/${FS_PRE_INIT_NAME}
}

SRC_URI += " \
    file://usr/bin/initialize-filesystem.sh \
    file://systemd/initialize-filesystem.service \
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
}

# Install the multiboot fstab
# -----
IMAGE_INSTALL += " \
    multiboot-fstab \
"