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

zenity --info --text "Patch installed correctly."

exit 0
