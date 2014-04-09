#!/bin/bash
# patch v3
#set -x

SUDO_PASSWORD="architech"

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
rm /home/architech/architech_sdk/architech/hachiko/yocto/meta-hachiko/conf/machine/hachiko.conf
echo -e '#!/bin/bash\nfirefox http://architechboards-hachiko.readthedocs.org/en/latest/\nexit 0' > ../splashscreen/run_documentation
chmod 777 ../splashscreen/run_documentation

cd poky
git log -n 1 | grep f1276b066223e7f501f7f711680215ff8edee252
[ $? -eq 0 ] || { fix_error; }


#
# Hachiko-tiny Fix
#

cd ${WORK_DIR}/hachiko-tiny/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }
sed -i "s|Sysroot=/home/architech/architech_sdk/architech/hachiko-tiny/sysroot|Sysroot=/home/architech/architech_sdk/architech/hachiko-tiny/toolchain/sysroots/cortexa9hf-vfp-neon-poky-linux-uclibceabi|g" /home/architech/architech_sdk/architech/hachiko-tiny/workspace/eclipse/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.yocto.sdk.ide.1467355974.prefs
rm /home/architech/architech_sdk/architech/hachiko-tiny/yocto/meta-hachiko/conf/machine/hachiko64.conf
echo -e '#!/bin/bash\nfirefox http://architechboards-hachiko-tiny.readthedocs.org/en/latest/\nexit 0' > ../splashscreen/run_documentation
chmod 777 ../splashscreen/run_documentation

cd poky
git log -n 1 | grep f1276b066223e7f501f7f711680215ff8edee252
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
echo -e '#!/bin/bash\nfirefox http://architechboards-tibidabo.readthedocs.org/en/latest/\nexit 0' > run_documentation
chmod 777 run_documentation
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "rm -rf /home/architech/architech_sdk/architech/tibidabo/sysroot/*"

cd ${WORK_DIR}/tibidabo/yocto/poky
git log -n 1 | grep 84c2763fa0bf08a83caa2c5ee532b5bef2ff918b
[ $? -eq 0 ] || { fix_error; }
cd ../meta-openembedded
git log -n 1 | grep 40e0f371f3eb1628655c484feac0cebf810737b4
[ $? -eq 0 ] || { fix_error; }
cd ../meta-fsl-arm
git log -n 1 | grep fb1681666fac9c096314cd01242be4613b7ff140
[ $? -eq 0 ] || { fix_error; }


#
# Zedboard Fix
#

cd ${WORK_DIR}/zedboard/yocto
repo sync
[ $? -eq 0 ] || { fix_error; }
cd ${WORK_DIR}/zedboard/splashscreen
echo -e "The zedboard Board is a single-board computer based on Xilinx's Zynq device family. It uses a Xilinx Zynq Z-7020 device." > short_description.txt
chmod 777 short_description.txt
echo -e '#!/bin/bash\nfirefox http://architechboards-zedboard.readthedocs.org/en/latest/\nexit 0' > run_documentation
chmod 777 run_documentation

cd ${WORK_DIR}/zedboard/yocto/poky
git log -n 1 | grep 75bed4086eb83f1d24c31392f3dd54aa5c3679b1
[ $? -eq 0 ] || { fix_error; }
cd ../meta-openembedded
git log -n 1 | grep 40e0f371f3eb1628655c484feac0cebf810737b4
[ $? -eq 0 ] || { fix_error; }
cd ../meta-xilinx
git log -n 1 | grep cb7329a596a5ab2d1392c1962f9975eeef8e4576
[ $? -eq 0 ] || { fix_error; }


#
# Pengwyn Fix
#

sed -i "s|sysroot=/opt/poky/1.2.1/sysroots/armv7a-vfp-neon-poky-linux-gnueabi|sysroot=/home/architech/architech_sdk/architech/pengwyn/sysroot|g" /opt/poky/1.2.1/environment-setup-armv7a-vfp-neon-poky-linux-gnueabi
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "rm -rf /home/architech/architech_sdk/architech/pengwyn/sysroot/*"
cd ${WORK_DIR}/pengwyn/splashscreen
echo -e '#!/bin/bash\nfirefox http://architechboards-pengwyn.readthedocs.org/en/latest/\nexit 0' > run_documentation
chmod 777 run_documentation
echo -e '#!/bin/bash\nexit 0' > run_install
chmod 777 run_install

#
# Ubuntu Fix
#
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "echo -e \"architech\" > /etc/hostname"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "sed -i \"s|architech-alpha|architech|g\" /etc/hosts"
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "hostname -F /etc/hostname"


#
# End
#
zenity --info --text "Patch installed correctly. Now the virtual machine will reboot."
echo -e ${SUDO_PASSWORD} | sudo -S bash -c "reboot"

exit 0
