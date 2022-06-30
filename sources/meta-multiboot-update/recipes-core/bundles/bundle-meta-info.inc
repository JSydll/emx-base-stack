# Common bundle meta information
RAUC_BUNDLE_COMPATIBLE = "${PRODUCT_NAME}"
RAUC_BUNDLE_VERSION = "${PRODUCT_VERSION}"

# The bundles will be signed with a self-signed developer only certificate.
# In production, the signing would be done using a proper PKI.

# Created development certificates using the meta-rauc/scripts/openssl-ca.sh script.
RAUC_KEY_FILE = "${THISDIR}/files/dev-selfsigned.key.pem"
RAUC_CERT_FILE = "${THISDIR}/files/dev-selfsigned.cert.pem"
