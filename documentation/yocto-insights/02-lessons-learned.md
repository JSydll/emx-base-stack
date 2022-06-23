# Lessons learned & insights from working with Yocto

## Working with packages

**Lessons learned:**

- RPM packages have issues in directory permissions on non empty directories


## Using the `wic` tool

Official documentation can be found [here](https://docs.yoctoproject.org/ref-manual/kickstart.html).

**Lessons learned:**

- For bitbake variables to be available on parsing a `wks` file, the file extension needs to be `.wks.in`.
- Partitions of an image built with wic can be inspected with `wic ls <path/to/image.wic>` and the contents
  in a partition with `wic ls <path/to/image.wic>:<partNo>`.
- wic can copy files contained in an image via `wic cp <path/to/image.wic>:<partNo>/file.txt .`.


## Creating a (host) SDK

**Lessons learned:**

- When packages are added to the `native` SDK (via `TOOLCHAIN_HOST_TASK_append = "nativesdk-<package>"`),
  dependencies are pulled from `DEPENDS` _not_ `RDEPENDS`.