# Update backend setup

The script `host-setup.sh` can be used to provision a `hawkbit` update server
on the machine executing it.

It will install the required dependencies and use the orchestration setup from
the upstream [hawkbit repository](https://github.com/eclipse/hawkbit) to provide
the `hawkbit` Management UI and all underlying service.

Note: As there are currently some issues in the upstream sources,
the script patches some of the checked out sources to provide a working setup
until the issues are fixed.

## Getting started

Simply run `./host-setup.sh -i <installation-directory>` and initiate the `hawkbit`
instance once afterwards, using `<installation-directory>/backend.sh init`.

Afterwards, you can (re)start and stop the services using the same control script,
`<installation-directory>/backend.sh start|stop`.

If you want to remove the `hawkbit` instance (**loosing all data!**), simply run
`<installation-directory>/backend.sh clean`.
