# Export the environment variables processed in the system.conf template

inherit logging
inherit export-multiboot-properties

python __anonymous() {
    ptable_type = d.getVar("PTABLE_TYPE")
    bootloader = d.getVar("PREFERRED_PROVIDER_virtual/bootloader")
    enable_dual_bootloader = d.getVar("ENABLE_DUAL_BOOTLOADER")

    if not bootloader or not ptable_type:
        bb.error("Missing required parameters!")

    bb.debug(2, "Setting bootloader properties (%s, %s, dual bootloader: %s)..." % (bootloader, ptable_type, enable_dual_bootloader))

    # Determine bootloader configuration
    if "u-boot" in bootloader:
        d.setVar("BOOTLOADER", "uboot")
        d.setVar("EXTRA_SYSTEM_OPTIONS", "")
        d.setVar("BOOTLOADER_SLOT_CONF", "")

    elif "grub" in bootloader:
        d.setVar("BOOTLOADER", "grub")
        d.setVar("EXTRA_SYSTEM_OPTIONS", "grubenv=/grubenv/grubenv")
        if enable_dual_bootloader:
            if ptable_type == "gpt":
                # Note: This assumes a fixed layout of 2x 50M for the bootloader slots.
                d.setVar("BOOTLOADER_SLOT_CONF",
                        "[slot.bootloader.0]\n"
                        "device=" + device + "1\n"
                        "type=boot-gpt-switch\n"
                        "region-start=4M\n"
                        "region-size=100M")
}