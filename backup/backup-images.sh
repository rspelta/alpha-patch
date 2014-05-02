#!/bin/bash
#
# Script per fare il backup delle immagini create da yocto della vm di architech:
# image-minimal, qt4demo, i file di boot, il kernel e la cartella di yocto
#
# Attenzione le variabili DIR_<NOMEBOARD> devono avere il nome delle cartelle presenti in /home/architech/architech_sdk/architech

DIR_TARGET_BOARDS="/media/sf_shared/release_images"

DIR_SOURCE_HACHIKO="/home/architech/architech_sdk/architech/hachiko/yocto/build/tmp/deploy/images/hachiko64"
DIR_HACHIKO="hachiko"

DIR_SOURCE_HACHIKO_TINY="/home/architech/architech_sdk/architech/hachiko-tiny/yocto/build/tmp/deploy/images/hachiko"
DIR_HACHIKO_TINY="hachiko-tiny"

DIR_SOURCE_PENGWYN="/home/architech/architech_sdk/architech/pengwyn/yocto/build/tmp/deploy/images"
DIR_PENGWYN="pengwyn"

DIR_SOURCE_TIBIDABO="/home/architech/architech_sdk/architech/tibidabo/yocto/build/tmp/deploy/images/tibidabo"
DIR_TIBIDABO="tibidabo"

DIR_SOURCE_ZEDBOARD="/home/architech/architech_sdk/architech/zedboard/yocto/build/tmp/deploy/images/zedboard-zynq7"
DIR_ZEDBOARD="zedboard"

#######################################################################################################################
# Copia il file nella directory di backup della board
# $1 path con il file da copiare
# $2 nome della board
function copy_file() {
    local SOURCE=$1
    local BOARD_NAME=$2
    local TARGET="${DIR_TARGET_BOARDS}/${BOARD_NAME}"
    echo -n "copia di $1..."
    cp -f ${SOURCE} ${TARGET}
    [ $? -eq 0 ] || { echo "Errore copia"; exit 1; }
    echo "OK"
}

#######################################################################################################################
# Crea la directory di destinazione e si posiziona nella directory delle immagini della board
# $1 directory delle immagini
# $2 nome della scheda da fare il backup
function start_copy() {
    local DIR_SOURCE=$1
    local BOARD_NAME=$2
    local DIR_TARGET="${DIR_TARGET_BOARDS}/${BOARD_NAME}"

    echo -n "Inizio copia di ${BOARD_NAME}..."
    mkdir -p ${DIR_TARGET}
    [ $? -eq 0 ] || { echo "Errore accesso cartella condivisa"; exit 1; }
    cd ${DIR_SOURCE}
    [ $? -eq 0 ] || { echo "Errore builds in ${BOARD_NAME}"; exit 1; }
    echo "OK"
}

#######################################################################################################################
# Salva le cartelle di yocto tranne le cartelle "build" e ".repo"
# $1 nome della board, deve coincidere con quella della path di architech
function backup_yocto() {
    local BOARD_NAME=$1
    local DIR_YOCTO="/home/architech/architech_sdk/architech/${BOARD_NAME}/yocto"
    local DIR_TARGET="${DIR_TARGET_BOARDS}/${BOARD_NAME}"

    echo -n "Backup di yocto..."
    cd ${DIR_YOCTO}
    tar --exclude='qtcreator' --exclude='eclipse' --exclude='build' --exclude='.repo' -jcf ${DIR_TARGET}/${BOARD_NAME}-src.tar.bz2 .
    [ $? -eq 0 ] || { echo "Errore nella compressione"; exit 1; }
    echo "OK"
}

#######################################################################################################################
# Helpers
function print_usage {
cat << EOF

 Programma per fare il backup delle immagini testate.

 Usage: $1 [options]

 OPTIONS:
 -h                 Print this help and exit
 -p <directory>     Customize installation directory. Default one is:
                        "/media/sf_shared/release_images"
EOF
}



#
#   MAIN
#
echo "*** START BACKUP ***"

while getopts "hp:" option
do
    case ${option} in
        h)
            print_usage
            exit 0
            ;;
        p)
            DIR_TARGET_BOARDS=${OPTARG}
            ;;
        ?)
            print_usage
            exit 1
            ;;
    esac
done

# 1. Backup HACHIKO
start_copy ${DIR_SOURCE_HACHIKO}                                                            ${DIR_HACHIKO}
copy_file "${DIR_SOURCE_HACHIKO}/core-image-minimal-dev-hachiko64.tar.bz2"                  ${DIR_HACHIKO}
copy_file "${DIR_SOURCE_HACHIKO}/qt4e-demo-image-hachiko64.tar.bz2"                         ${DIR_HACHIKO}
copy_file "${DIR_SOURCE_HACHIKO}/u-boot.bin"                                                ${DIR_HACHIKO}
copy_file "${DIR_SOURCE_HACHIKO}/uImage"                                                    ${DIR_HACHIKO}
copy_file "${DIR_SOURCE_HACHIKO}/uImage-rza1-hachiko.dtb"                                   ${DIR_HACHIKO}
backup_yocto                                                                                ${DIR_HACHIKO}

# 2. Backup HACHIKO-TINY
start_copy ${DIR_SOURCE_HACHIKO_TINY}                                                       ${DIR_HACHIKO_TINY}
copy_file "${DIR_SOURCE_HACHIKO_TINY}/tiny-image-hachiko.tar.bz2"                           ${DIR_HACHIKO_TINY}
copy_file "${DIR_SOURCE_HACHIKO_TINY}/u-boot.bin"                                           ${DIR_HACHIKO_TINY}
copy_file "${DIR_SOURCE_HACHIKO_TINY}/uImage"                                               ${DIR_HACHIKO_TINY}
copy_file "${DIR_SOURCE_HACHIKO_TINY}/uImage-rza1-hachiko.dtb"                              ${DIR_HACHIKO_TINY}
backup_yocto                                                                                ${DIR_HACHIKO_TINY}

# 3. Backup PENGWYN
start_copy ${DIR_SOURCE_PENGWYN}                                                            ${DIR_PENGWYN}
copy_file "${DIR_SOURCE_PENGWYN}/core-image-minimal-dev-pengwyn.tar.gz"                     ${DIR_PENGWYN}
copy_file "${DIR_SOURCE_PENGWYN}/qt4e-demo-image-pengwyn.tar.gz"                            ${DIR_PENGWYN}
copy_file "${DIR_SOURCE_PENGWYN}/MLO"                                                       ${DIR_PENGWYN}
copy_file "${DIR_SOURCE_PENGWYN}/u-boot-pengwyn.img"                                        ${DIR_PENGWYN}
copy_file "${DIR_SOURCE_PENGWYN}/uImage.bin"                                                ${DIR_PENGWYN}
backup_yocto                                                                                ${DIR_PENGWYN}

# 4. Backup TIBIDABO
start_copy ${DIR_SOURCE_TIBIDABO}                                                           ${DIR_TIBIDABO}
copy_file "${DIR_SOURCE_TIBIDABO}/core-image-minimal-dev-tibidabo.sdcard"                   ${DIR_TIBIDABO}
copy_file "${DIR_SOURCE_TIBIDABO}/qt4e-demo-image-tibidabo.sdcard"                          ${DIR_TIBIDABO}
copy_file "${DIR_SOURCE_TIBIDABO}/u-boot.imx"                                               ${DIR_TIBIDABO}
copy_file "${DIR_SOURCE_TIBIDABO}/uImage"                                                   ${DIR_TIBIDABO}
backup_yocto                                                                                ${DIR_TIBIDABO}

# 5. Backup ZEDBOARD
start_copy ${DIR_SOURCE_ZEDBOARD}                                                           ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/core-image-minimal-dev-zedboard-zynq7.tar.gz"             ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/u-boot.bin"                                               ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/uImage"                                                   ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/qt4e-demo-image-zedboard-zynq7.tar.gz"                    ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/u-boot.elf"                                               ${DIR_ZEDBOARD}
copy_file "${DIR_SOURCE_ZEDBOARD}/uImage-zedboard-zynq7-mmcblk0p2.dtb"                      ${DIR_ZEDBOARD}
backup_yocto                                                                                ${DIR_ZEDBOARD}

echo "*** END BACKUP ***"
exit 0

