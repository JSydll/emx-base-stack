# Software update bundles

Using RAUC, a software update bundle contains meta data about the update, the actual
artifacts to be deployed as well as scripts extending the behavior of the update process.
More information can be found in the [RAUC documentation on bundles](https://rauc.readthedocs.io/en/latest/reference.html#sec-ref-formats).

In Yocto builds, the bundles can be configured using the `bundle.bbclass` and a set
up using the [documented bitbake variables](https://rauc.readthedocs.io/en/latest/integration.html#bundle-generation).

> Learning: RAUC bundles must be signed (at least with developer certificates).

## Bundle scopes

In the recovery/system update scheme, each of the slots (or slot groups) can only update
the respective other. Therefore, it does not make much sense to have a one-for-all bundle
but instead, a dedicated `system-update-bundle` and a `recovery-update-bundle` is built.

## Using `wic` artifacts in bundles

As soon as more complex update schemes (such as recovery/system) and partition layouts
shall be supported, collecting the proper build artifacts to include in the bundle may
need additional logic.

As `wic` creates images that already contain all relevant data such as kernel-partition
contents and rootfs in a partitioned image, an approach can be to fetch the respective artifacts
from that partitioned image. This is what the `deploy-single-slot-partitions.bbclass` in the
`meta-multiboot-update` layer does - given the expected partition scheme in `single-slot.wks`.

## Bundles and slot types

Each bundles contains artifacts for one or more slots, which are defined in the `/etc/rauc/system.conf`.
As documented [here](https://rauc.readthedocs.io/en/latest/integration.html#slot-type), RAUC checks the
unpacked artifact's _file extensions_ to determine, how they should be installed to the specific slot.