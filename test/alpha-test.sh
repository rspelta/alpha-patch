#!/bin/bash
#
# Script to fix the virtual machine alpha
#
set -x

function internet_error {
    zenity --error --text "An error is occured please check your Internet connection and relaunch this script."
    exit 1
}

USER_USED=`whoami`

[ "${USER_USED}" == "architech" ] || { zenity --error --text "Please launch this script with \"architech\" user, without sudo command"; exit 1; }

WORK_DIR=${HOME}/architech_sdk/architech

#
# Hachiko Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

cd ${WORK_DIR}/hachiko/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )

#
# Hachiko-tiny Fix
#
# EXTRA_IMAGE_FEATURES = "tools-debug"
# IMAGE_INSTALL_append = " tcf-agent"

cd ${WORK_DIR}/hachiko-tiny/yocto
(source poky/oe-init-build-env; bitbake tiny-image; )

#
# Tibidabo Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

cd ${WORK_DIR}/tibidabo/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )

#
# Zedboard Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"
cd ${WORK_DIR}/zedboard/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; bitbake u-boot-xlnx; )

#
# Pengwyn Fix
#
# IMAGE_INSTALL_append = " tcf-agent gdbserver"
cd ${WORK_DIR}/pengwyn/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )

exit 0
