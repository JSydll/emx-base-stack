# Distribution channels

In the end, the distribution of new software to the device is rather
only a matter of choosing a suitable channel given your use case:

- **local updates via USB** or similar plug & play storage media allow
  strict control over updates as they require physical access to the device.
  However, it might be tedious to update more than one device.

- **updates via SSH access** allow for remote deployment of new software,
  but still need manual selection and execution for each device in the field.

- **remote updates via device management platforms** like `hawkbit` solve the
  former issues by providing control over all active devices in the field,
  allowing to monitor the used software versions, device availability and,
  depending on the platform, device health.

As the most wide-spead Linux update frameworks (`RAUC` and `swupdate`) both
support integration with the [Eclipse hawkbit Update Server](https://www.eclipse.org/hawkbit/),
this repository comes with a sample setup for it.

## hawkbit Update Server integration

For `RAUC`, there is a dedicated intermediate software component on device side,
taking over the communication with the `hawkbit API` and controlling the update
using `RAUC`s D-Bus API. It is called the `rauc-hawkbit-updater` and comes
with a simple [documentation](https://rauc-hawkbit-updater.readthedocs.io/en/latest/)
how to configure it.

Still, there might be a few pitfalls when setting up `hawkbit` and
the `rauc-hawkbit-updater`:

> Learning: To enable _HTTP streaming_ the bundles directly to the desired system slots,
> only the `verity` bundle format can be used - in turn requiring **certain kernel configurations** 
> to be enabled. This can introduce a breaking change when integrating this feature at a later stage.

> Learning: Depending on how _device identities_ and _authorization_ are designed to work for
> your use case, additional effort is necessary to allow device specific update bundles to be created
> so that the devices flashed with them will be accepted by `hawkbit`.
> There's a dedicated [documentation](https://www.eclipse.org/hawkbit/concepts/authentication/)
> on this topic.
