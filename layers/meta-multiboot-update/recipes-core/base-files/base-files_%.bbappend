inherit logging

# Remove default poky fstab to be able to install a custom one
do_install:append() {
    bbnote "Removing stock fstab from ${PN} - be sure to install a customized one!"
    rm ${D}${sysconfdir}/fstab
}

FILES:${PN}:remove = "${sysconfdir}/fstab"

# Still require an fstab to be specified
RDEPENDS:${PN} += "base-files-fstab"