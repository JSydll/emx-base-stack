# Board integration

Some integration activities such as the definition of overlays and creation
of base files can be generalized while others are highly target specific.

The major complexity in the latter ones can most often be found in the adjustment
of the bootloader code to be able to deal with the multiboot partitioning scheme
as well as the creation of proper installation artifacts.

In this repository, the general multiboot integration is done in the `meta-multiboot-update`
layer, which in turn is based on the `meta-raspberrypi-multiboot-update` layer.

Hardware boards with multiboot integration:

- [RaspberryPi 3](./../board-integrations/01-raspberrypi.md)
- [QEMU](./../board-integrations/02-qemu.md)


## Bootloader integrations

Depending on the hardware and board support package, there might be a more or less free
choice of bootloaders. Usual bootloaders include (the links lead to the corresponding 
introductions and instructions for RAUC integration):

- [barebox](https://rauc.readthedocs.io/en/latest/integration.html#barebox)
- [u-boot](https://rauc.readthedocs.io/en/latest/integration.html#id5)
- [grub](https://rauc.readthedocs.io/en/latest/integration.html#grub)
- [efi](https://rauc.readthedocs.io/en/latest/integration.html#efi)

Depending on the bootloader, there are also different ways to control the **multiboot sequence**. 

### u-boot

The u-boot bootloader offers three ways how to implement a multiboot sequence:

- adjustment of the u-boot sources (e.g. via custom `defconfig`s, also using inbuilt features such as
  `bootcounter.c`)
- boot code stored in environment variables (e.g. in the `bootcmd`)
- precompiled u-boot script

For example, `meta-raspberrypi` uses a u-boot script that can easily be customized to account for
bootcounters and multiboot partition handling.