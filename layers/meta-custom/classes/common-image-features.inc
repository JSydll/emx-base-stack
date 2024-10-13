inherit set-root-pwd
inherit enable-wifi-ap

IMAGE_INSTALL += " \
    loadkeys \
    \
    static-ip-config \
    \
    media-automount \
"