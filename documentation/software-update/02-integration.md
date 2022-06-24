# Integration

Some integration activities such as the definition of overlays and creation
of base files can be generalized while others are highly target specific.

The major complexity in the latter ones can most often be found in the adjustment
of the bootloader code to be able to deal with the multiboot partitioning scheme
as well as the creation of proper installation artifacts.

In this repository, the general multiboot integration is done in the `meta-multiboot-update`
layer, which in turn is based on the `meta-raspberrypi-multiboot-update` layer.

Hardware boards with multiboot integration:

- [RaspberryPi 3](./../board-integrations/01-raspberrypi.md)
