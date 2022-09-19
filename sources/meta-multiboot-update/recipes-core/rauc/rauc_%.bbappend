FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append := "  \
    file://ca.cert.pem \
	file://system.conf.j2 \
"

inherit templating

TEMPLATE_FILE = "${WORKDIR}/system.conf.j2"

# Add the variables used below to the environment
include rauc-environment.inc

python do_patch_append() {
    params = {
        "product_name" : d.getVar("PRODUCT_NAME"),
        "bootloader": d.getVar("BOOTLOADER"),
        "extra_bootloader_options": d.getVar("EXTRA_BOOTLOADER_OPTIONS"),
        "bootloader_slot_conf": d.getVar("BOOTLOADER_SLOT_CONF"),
        "recovery_boot_device": d.getVar("RECOVERY_BOOT_DEVICE"),
        "recovery_rootfs_device": d.getVar("RECOVERY_ROOTFS_DEVICE"),
        "system_boot_device": d.getVar("SYSTEM_BOOT_DEVICE"),
        "system_rootfs_device": d.getVar("SYSTEM_ROOTFS_DEVICE")
    }
    render_template(d.getVar('TEMPLATE_FILE', True), params)
}