# Remove default poky fstab, to be able to install a custom one.
FILES:${PN}:remove = "${sysconfdir}/fstab"

inherit logging

do_install:append() {
    bbnote "Removing stock fstab from ${PN} - be sure to install a customized one!"
    rm ${D}${sysconfdir}/fstab
}