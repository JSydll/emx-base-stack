# ------------------------------------------------------------------
# Custom wic plugin to populate files from an archive in a partition
# ------------------------------------------------------------------
#
# Extracts an archive and copies all contents into the target partition.
#

import logging
import os
import tarfile
import functools

from wic import WicError
from wic.pluginbase import SourcePlugin

logger = logging.getLogger('wic')

class InstallFromArchivePlugin(SourcePlugin):
    """
    Populate files contained in an archive on the partition.
    """

    name = 'extract-from-archive'

    def extract_from_tar(archive_path, work_dir, available_size):
        """
        Extracts the archive at archive_path to the work_dir, given there's
        enough space available.
        """
        logger.debug("Processing TAR archive...")
        if not tarfile.is_tarfile(archive_path):
            raise WicError("Archive '%s' is not a tar file!" % archive_path)

        archive_tarfile = tarfile.open(name=archive_path, mode="r:*")
        
        estimated_size = int(functools.reduce(lambda x, y: getattr(x, 'size', x) + getattr(y, 'size', y), archive_tarfile.getmembers()) / 1024)
        if estimated_size > available_size:
            raise WicError("Estimated archive size (%s kB) larger than available size (%s kB)!" % (estimated_size, available_size))

        logger.debug("Extracting partition contents to %s...", work_dir)
        archive_tarfile.extractall(path=work_dir)

    @classmethod
    def do_prepare_partition(self, part, source_params, cr, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             rootfs_dir, native_sysroot):
        """
        Called to do the actual content population for a partition i.e. it
        'prepares' the partition to be incorporated into the image.
        """
        work_dir = "%s/part.%d" % (cr_workdir, part.lineno)

        deploy_dir_image = kernel_dir # See engine.py:wic_create for details
        if not deploy_dir_image:
            deploy_dir_image = get_bitbake_var("DEPLOY_DIR_IMAGE")
            if not deploy_dir_image:
                raise WicError("Couldn't find DEPLOY_DIR_IMAGE, exiting")
        logger.debug("Using build artifacts from %s.", deploy_dir_image)

        logger.debug("Validating archive...")
        if 'file' not in source_params:
            raise WicError("No file specified in source params (syntax: --sourceparams='file=<path>')!")
        
        archive_name = source_params['file']
        available_size = max([part.size, part.fixed_size])
        if '.tar' in archive_name:
            self.extract_from_tar(archive_path=os.path.join(deploy_dir_image, archive_name), work_dir=work_dir, available_size=available_size)
        else:
            raise WicError("This archive type is currently not supported!")

        logger.debug("Prepare partition using contents from %s.", work_dir)
        part.prepare_rootfs(cr_workdir, oe_builddir, work_dir, native_sysroot, False)

