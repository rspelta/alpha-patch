#!/bin/bash
#
# daddu-sync.sh [password] [destination folder]

BWLIMIT=12

if [ $# -eq 2 ]
then
    PASSWORD=${1}
    LOCAL_ROOT=${2}
else
    PASSWORD=`zenity --password`
    LOCAL_ROOT=`zenity --entry --text "Path of destination"`
fi

function exit_error()
{
    echo "ERROR"
    exit 1
}


function rsync_commonboard_godaddy()
{
    REMOTE_DIR=${1}
    LOCAL_DIR=${1}
    echo -n "${LOCAL_DIR}..."
    mkdir -p ${LOCAL_ROOT}/${LOCAL_DIR}
    sshpass -p ${PASSWORD} rsync --bwlimit=${BWLIMIT} -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/ ${LOCAL_ROOT}/${LOCAL_DIR}
    [ $? -eq 0 ] || { exit_error; }
    echo "OK"
}

function rsync_pengwy_godaddy()
{
    echo -n "pengwyn..."
    REMOTE_DIR="pengwyn"
    LOCAL_DIR="pengwyn"
    mkdir -p ${LOCAL_ROOT}/${LOCAL_DIR}/script
    sshpass -p ${PASSWORD} rsync --bwlimit=${BWLIMIT} -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/script
    [ $? -eq 0 ] || { exit_error; }
    mkdir -p ${LOCAL_ROOT}/${LOCAL_DIR}/sdk
    sshpass -p ${PASSWORD} rsync --bwlimit=${BWLIMIT} -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/sdk
    [ $? -eq 0 ] || { exit_error; }
    mkdir -p ${LOCAL_ROOT}/${LOCAL_DIR}/toolchain
    sshpass -p ${PASSWORD} rsync --bwlimit=${BWLIMIT} -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/toolchain
    [ $? -eq 0 ] || { exit_error; }
	echo "OK"
}

[ -d ${LOCAL_ROOT} ] || { echo "path errata: ${LOCAL_ROOT}"; exit_error; }

echo "start, save in ${LOCAL_ROOT}"


rsync_commonboard_godaddy "hachiko"
rsync_commonboard_godaddy "hachiko-tiny"
rsync_commonboard_godaddy "tibidabo"
rsync_commonboard_godaddy "zedboard"
rsync_commonboard_godaddy "microzed"
rsync_commonboard_godaddy "doc"
rsync_pengwy_godaddy

echo "end success"

exit 0

