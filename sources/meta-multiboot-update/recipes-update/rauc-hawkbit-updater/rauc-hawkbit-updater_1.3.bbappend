# Provides a proper backend configuration
#
# Depends on the following custom env vars exported to the yocto build:
# - UPDATE_BACKEND_URL
# - UPDATE_AUTH_TOKEN
# - UPDATE_ENABLE_STREAMING (optional)
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Default options
UPDATE_ENABLE_STREAMING ?= "no"

SRC_URI:append := "  \
    file://update-backend.conf.j2 \
"

inherit templating

TEMPLATE_FILE = "${WORKDIR}/update-backend.conf.j2"

python do_patch:append() {
    params = {
        "update_backend_url" : d.getVar("UPDATE_BACKEND_URL"),
        "update_auth_token" : d.getVar("UPDATE_AUTH_TOKEN"),
        "enable_streaming" : bb.utils.to_boolean(d.getVar("UPDATE_ENABLE_STREAMING"), False),
        "product_name" : d.getVar("PRODUCT_NAME"),
        "product_version" : d.getVar("PRODUCT_VERSION")
    }
    render_template(d.getVar('TEMPLATE_FILE', True), params)
}

do_install:append() {
    install -m 644 ${WORKDIR}/update-backend.conf ${D}${sysconfdir}/${PN}/config.conf
}