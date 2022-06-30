FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append := "  \
    file://ca.cert.pem \
	file://system.conf.j2 \
"

inherit templating

TEMPLATE_FILE = "${WORKDIR}/system.conf.j2"

require ${STORAGE_TYPE}_config.inc

python do_patch_append() {
    params = {
        "product_name" : d.getVar("PRODUCT_NAME"),
        "recovery_boot_device": d.getVar("RECOVERY_BOOT_DEVICE"),
        "recovery_device": d.getVar("RECOVERY_DEVICE"),
        "system_boot_device": d.getVar("SYSTEM_BOOT_DEVICE"),
        "system_device": d.getVar("SYSTEM_DEVICE")
    }
    render_template(d.getVar('TEMPLATE_FILE', True), params)
}