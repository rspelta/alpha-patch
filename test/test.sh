#!/bin/bash
#
# Script to fix the virtual machine alpha
#
set -x


function clean_up() {
	echo "Exit forced"
	exit 2
}

function clean_downloads() {
    rm -f $(find . -name "*.done")
    rm -f readline62-00*
}

trap clean_up SIGHUP SIGINT SIGTERM

function internet_error() {
    zenity --error --text "An error is occured please check your Internet connection and relaunch this script."
    exit 1
}

USER_USED=`whoami`

[ "${USER_USED}" == "architech" ] || { zenity --error --text "Please launch this script with \"architech\" user, without sudo command"; exit 1; }

WORK_DIR=${HOME}/architech_sdk/architech

#
# Imx6sxsabresd Fix
#
# EXTRA_IMAGE_FEATURES = "tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** IMX6SXSABRESD *********************"
cd ${WORK_DIR}/imx6sxsabresd/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; )

#
# Picozed Fix
#
# EXTRA_IMAGE_FEATURES = "tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** PICOZED *********************"
cd ${WORK_DIR}/picozed/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; )

#
# Hachiko Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** HACHIKO *********************"
cd ${WORK_DIR}/hachiko/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; bitbake qt4e-demo-image; clean_downloads; )

#
# Hachiko-tiny Fix
#
# EXTRA_IMAGE_FEATURES = "tools-debug"
# IMAGE_INSTALL_append = " tcf-agent"

echo "***************** HACHIKO-TINY *********************"
cd ${WORK_DIR}/hachiko-tiny/yocto
(source poky/oe-init-build-env && bitbake tiny-image; clean_downloads; )

#
# Tibidabo Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** TIBIDABO *********************"
cd ${WORK_DIR}/tibidabo/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; bitbake qt4e-demo-image; clean_downloads; )

#
# Zedboard Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** ZEDBOARD *********************"
cd ${WORK_DIR}/zedboard/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; bitbake qt4e-demo-image; clean_downloads; bitbake u-boot-xlnx; clean_downloads; )

#
# Pengwyn Fix
#
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** PENGWYN *********************"
cd ${WORK_DIR}/pengwyn/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; bitbake qt4e-demo-image; clean_downloads; )

#
# Microzed Fix
#
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** MICROZED *********************"
cd ${WORK_DIR}/microzed/yocto
(source poky/oe-init-build-env && bitbake core-image-minimal-dev; clean_downloads; )

exit 0
