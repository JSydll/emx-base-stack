# Remove default poky fstab, to be able to install a custom one.
FILES:${PN}:remove = "${sysconfdir}/fstab"

do_install:append() {
    rm ${D}${sysconfdir}/fstab
}