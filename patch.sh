#!/bin/bash

function fix_error {
    zenity --error --text "An error is occured please check your Internet connection and relaunch this script."
    exit 1
}

USER_USED=`whoami`

[ "${USER_USED}" == "architech" ] || { zenity --error --text "Please launch this script with \"architech\" user, without sudo command."; exit 1; }

WORK_DIR=${HOME}/architech_sdk/architech

#
# Hachiko Fix
#

cd ${WORK_DIR}/hachiko/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }

#
# Hachiko-tiny Fix
#

cd ${WORK_DIR}/hachiko-tiny/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }

#
# Tibidabo Fix
#

cd ${WORK_DIR}/tibidabo/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }
cd ${WORK_DIR}/tibidabo/splashscreen
echo -e '#!/bin/bash\nzenity --error --text "Hob not available for Tibidabo"\nexit 0' > run_hob
chmod 777 run_hob

#
# Zedboard Fix
#

cd ${WORK_DIR}/zedboard/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }
cd ${WORK_DIR}/zedboard/splashscreen
echo -e "The zedboard Board is a single-board computer based on Xilinx's Zynq device family. It uses a Xilinx Zynq Z-7020 device." > short_description.txt
chmod 777 short_description.txt

#
# Pengwyn Fix
#

sed -i "s|sysroot=/opt/poky/1.2.1/sysroots/armv7a-vfp-neon-poky-linux-gnueabi|sysroot=/home/architech/architech_sdk/architech/pengwyn/sysroot|g" /opt/poky/1.2.1/environment-setup-armv7a-vfp-neon-poky-linux-gnueabi

SUDO_PASSWORD="architech"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "echo -e \"architech\" > /etc/hostname"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "sed -i \"s|architech-alpha|architech|g\" /etc/hosts"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "hostname -F /etc/hostname"

echo -e ${SUDO_PASSWORD} | sudo -S bash -c "rm -rf /home/architech/architech_sdk/architech/pengwyn/sysroot/*"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "rm -rf /home/architech/architech_sdk/architech/tibidabo/sysroot/*"

zenity --info --text "Patch installed correctly. Now the virtual machine will reboot."
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "reboot"

exit 0

