SRC_URI += " \
    file://fstab \
"

FILES_${PN} += " \
    ${sysconfdir}/fstab \
"

# Note: Order matters here.

# Install basic fstab
do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}
}

# Append storage type specific mounts
require fstab-${STORAGE_TYPE}.inc