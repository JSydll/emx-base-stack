# Remove default poky fstab, to be able to install a custom one.
FILES_${PN}_remove += " \
    ${sysconfdir}/fstab \
"

do_install_append() {
    rm ${D}${sysconfdir}/fstab
}