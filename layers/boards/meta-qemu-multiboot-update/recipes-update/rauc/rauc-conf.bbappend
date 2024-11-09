# As rauc's view on the system must survive updates similar to the bootloader environment,
# put them in a common partition. Having it at the beginning of the disc, allows for easier
# implementation of other use cases like repartitioning.
RAUC_DATA_DIRECTORY = "/boot/rauc"