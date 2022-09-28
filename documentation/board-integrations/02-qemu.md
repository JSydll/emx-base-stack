# Integrating multiboot and software update on the QEMU platform

The board support for the QEMU platform is shipped as part of the poky reference distribution.
It can be handy to have such a virtualized environment for testing and development purposes, therefore
this repository also provides the multiboot implementation for QEMU.

An excellent starting point for this is the [`meta-rauc-community` repo](https://github.com/rauc/meta-rauc-community).

## Bootloader integration

For EFI-based machines, the kernel image expected by the bootloader (`grub-efi` by default) is installed
into the rootfs at `/boot`. To separate the kernel from the rootfs, `wic`s `--rootfs-dir` and `--exclude-path` 
features can be used.

## Executing QEMU

Yocto uses an implementation of the QEMU project as part of the development “tool set”.
See the [corresponding documentation](https://docs.yoctoproject.org/dev-manual/qemu.html) for details.