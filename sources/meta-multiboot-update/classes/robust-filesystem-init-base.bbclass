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
# The persistent memory device must be specified using the FS_INIT_PERSISTENT_DEVICE
# variable.

inherit logging

FS_INIT_PERSISTENT_DEVICE[doc] = "Defines the memory device to be used for persistent data. Attention: Must be a basic /dev/* path!"
FS_INIT_SOFTWARE_MODE[doc]     = "Defines the software mode the system is running in - useful to separate data between system and recovery data. Defaults to 'system'."
FS_INIT_PARTITION_TYPE[doc]    = "Type of partition used for the persistent filesystem. Defaults to 'ext4'."

FS_INIT_SOFTWARE_MODE   ?= "system"
FS_INIT_PARTITION_TYPE  ?= "ext4"

python() {
    dev_path = d.getVar("FS_INIT_PERSISTENT_DEVICE", True)
    if dev_path == "" or "/dev/" not in dev_path:
        bb.fatal("Variable 'FS_INIT_PERSISTENT_DEVICE' not set properly!")
}

# TODO: Remove dependency on assumption that layers are checked out under ${TOPDIR}/sources.
FILESEXTRAPATHS:prepend := "${TOPDIR}/../sources/meta-multiboot-update/classes/files:"

SRC_URI += " \
    file://pre-init.j2 \
    file://fstab \
"

# Install guaranteed mountpoints and directories
# -----
FILES:${PN} += " \
    ${localstatedir}/* \
"

do_install:append() {
    install -d ${D}${localstatedir}/mounts/persistent
    install -d ${D}${localstatedir}/volatile-overlays

    install -d ${D}${localstatedir}/persistent/private
    install -d ${D}${localstatedir}/persistent/shared
}

# Install the pre-init script
# -----
inherit robust-filesystem-init-env

inherit templating

FILES:${PN} += " \
    /sbin/${FS_INIT_PRE_INIT_NAME} \
"

PRE_INIT_TEMPLATE_PATH = "${WORKDIR}/pre-init.j2"

python do_patch:append() {
    params = { 
        "original_init_name" : d.getVar('FS_INIT_ORIGINAL_INIT_NAME', True), 
        "persistent_device" : d.getVar('FS_INIT_PERSISTENT_DEVICE', True),
        "partition_type" : d.getVar('FS_INIT_PARTITION_TYPE', True),
        "software_mode" : d.getVar('FS_INIT_SOFTWARE_MODE', True),
    }
    render_template(d.getVar('PRE_INIT_TEMPLATE_PATH', True), params)
}

do_install:append() {
    install -d ${D}/sbin
    install -m 0775 ${WORKDIR}/pre-init ${D}/sbin/${FS_INIT_PRE_INIT_NAME}
}

# Define fstab with root-only filesystem and required overlays
# -----
FILES:${PN} += " \
    ${sysconfdir}/fstab \
"

DEPENDS += " \
    base-files \
"

do_install:append() {
    install -d ${D}/${sysconfdir}
    install -m 0755 ${WORKDIR}/fstab ${D}${sysconfdir}
}