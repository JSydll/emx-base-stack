For EFI-based machines, the bootloader (grub-efi by default) is installed into the image at /boot. Wic can be used to split the bootloader into separate boot and rootfs partitions if necessary.


sudo apt install qemu