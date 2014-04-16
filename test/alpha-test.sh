#!/bin/bash
#
# Script to fix the virtual machine alpha
#
#set -x

function clean_up {
	echo "Exit forced"
	exit 2
}

trap clean_up SIGHUP SIGINT SIGTERM

function internet_error {
    zenity --error --text "An error is occured please check your Internet connection and relaunch this script."
    exit 1
}

USER_USED=`whoami`

[ "${USER_USED}" == "architech" ] || { zenity --error --text "Please launch this script with \"architech\" user, without sudo command"; exit 1; }

WORK_DIR=${HOME}/architech_sdk/architech

cp hachiko.local.conf ~/architech_sdk/architech/hachiko/yocto/build/conf/local.conf
cp hachiko-tiny.local.conf ~/architech_sdk/architech/hachiko-tiny/yocto/build/conf/local.conf
cp tibidabo.local.conf ~/architech_sdk/architech/tibidabo/yocto/build/conf/local.conf
cp zedboard.local.conf ~/architech_sdk/architech/zedboard/yocto/build/conf/local.conf
cp pengwyn.local.conf ~/architech_sdk/architech/pengwyn/yocto/build/conf/local.conf

#
# Hachiko-tiny Fix
#
# EXTRA_IMAGE_FEATURES = "tools-debug"
# IMAGE_INSTALL_append = " tcf-agent"

echo "***************** HACHIKO-TINY *********************"
cd ${WORK_DIR}/hachiko-tiny/yocto
(source poky/oe-init-build-env; bitbake tiny-image; )


#
# Hachiko Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** HACHIKO *********************"
cd ${WORK_DIR}/hachiko/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )


#
# Tibidabo Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** TIBIDABO *********************"
cd ${WORK_DIR}/tibidabo/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )

#
# Zedboard Fix
#
# EXTRA_IMAGE_FEATURES = "debug-tweaks tools-debug"
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** ZEDBOARD *********************"
cd ${WORK_DIR}/zedboard/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; bitbake u-boot-xlnx; )

#
# Pengwyn Fix
#
# IMAGE_INSTALL_append = " tcf-agent gdbserver"

echo "***************** PENGWYN *********************"
cd ${WORK_DIR}/pengwyn/yocto
(source poky/oe-init-build-env; bitbake core-image-minimal-dev; bitbake qt4e-demo-image; )

exit 0
