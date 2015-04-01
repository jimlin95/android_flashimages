#!/bin/bash
#
## Program: Flash utility for Android system
#
#
#   Usage: ./flash_images.sh
#
# History:
# 2014/06/20    Jim Lin,    First release
# 2014/07/04    Sakia Lien, Add flash item: userdata, cache
# 2014/07/14    Sakia Lien, Add flash item: splash
# 2014/07/31    Sakia Lien, backup and restore factory data
#-----------------------------------------------------------------------------------------------------
# Definition values
#-----------------------------------------------------------------------------------------------------

EXIT_SUCCESS=0
EXIT_FAIL=1
NULL_DEV=/dev/null

#-----------------------------------------------------------------------------------------------------
# Local definitions
#-----------------------------------------------------------------------------------------------------
rnd=$RANDOM
date=`date +%y%m%d`
IMAGE_PATH=../common/build

GPT=${IMAGE_PATH}/gpt_both0.bin

SBL1=${IMAGE_PATH}/sbl1.mbn
SDI=${IMAGE_PATH}/sdi.mbn
RPM=${IMAGE_PATH}/rpm.mbn 
TZ=${IMAGE_PATH}/tz.mbn 
NON_HLOS=${IMAGE_PATH}/NON-HLOS-APQ.bin
PERSIST=${IMAGE_PATH}/persist.img
	
APPBOOT=${IMAGE_PATH}/emmc_appsboot.mbn 
RECOVERY=${IMAGE_PATH}/recovery.img
KERNEL=${IMAGE_PATH}/boot.img
CACHE=${IMAGE_PATH}/cache.img
SYSTEM=${IMAGE_PATH}/system.img
USERDATA=${IMAGE_PATH}/userdata.img
BOOTLOGO=${IMAGE_PATH}/splash.img
LOG=${IMAGE_PATH}/Log.img
KITTING=${IMAGE_PATH}/kitting.img
FACTORY_FILE=./factory
FACTORY_PATH=.

function pause()
{
  read -p "$*"
}

#-----------------------------------------------------------------------------------------------------
# Using commands list
#-----------------------------------------------------------------------------------------------------

MENU_ENTRY()
{
#  echo -e "\x1b[1;36m"
  echo -e "\x1b[1;36mConnect DUT to PC via USB cable"
  echo -e "\x1b[1;36m=========================== Flash Utility =============================\x1b[0m"
  echo -e " 0. Flash All images (with erase all)"
  echo -e " 1. Flash All images"
  echo -e " 2. Flash SBL1 image"
  echo -e " 3. Flash lk image"
  echo -e " 4. Flash kernel image"
  echo -e " 5. Flash system image"
  echo -e " 6. Flash recovery image"
  echo -e " 7. Flash userdata image"
  echo -e " 8. Flash cache image"
  echo -e " 9. Flash bootlogo image"
  echo -e " g. Fastboot write \x1b[1;33mg\x1b[0mpt table (erase all)"
  echo -e " r. \x1b[1;33mR\x1b[0meboot DUT (fastboot)"
  echo -e " f. Enter \x1b[1;33mf\x1b[0mastboot mode"
  echo -e " l. \x1b[1;33mL\x1b[0mist usb devices"
  echo -e " q. \x1b[1;33mQ\x1b[0muit"
  echo -e " b. \x1b[1;33mB\x1b[0mackup factory data: persist, modem, fsg"
  echo -e " s. Re\x1b[1;33ms\x1b[0mtore factory data: persist, modem, fsg"
  echo -e "\x1b[1;36m=======================================================================\x1b[0m"
  echo -e "\x1b[0m \x1b[1;34m"
  read -p "Please enter your choice: " choice
  echo -e "\x1b[0m"
  CHOICE 
}
CHOICE()
{
  case $choice in 
   0)
	echo "Flash All images with oem format "
	./adb reboot-bootloader
#	./fastboot flash partition $GPT
	./fastboot flash modem $NON_HLOS
#	./fastboot flash sbl1 $SBL1
#	./fastboot flash sbl1bak $SBL1
	./fastboot flash sdi $SDI
	./fastboot flash aboot $APPBOOT
	./fastboot flash abootbak $APPBOOT
	./fastboot flash rpm $RPM
	./fastboot flash rpmbak $RPM
	./fastboot flash boot $KERNEL
	./fastboot flash tz $TZ 
	./fastboot flash tzbak $TZ
	./fastboot flash system $SYSTEM
#	./fastboot flash persist $PERSIST
	./fastboot flash recovery $RECOVERY
	./fastboot flash cache $CACHE
	./fastboot flash userdata $USERDATA
	./fastboot flash splash $BOOTLOGO
	./fastboot flash Log $LOG
	./fastboot flash kitting $KITTING
	./fastboot reboot
    ;;
  1)
	echo "Flash All images"
	./adb reboot-bootloader
	./fastboot flash modem $NON_HLOS
#	./fastboot flash sbl1 $SBL1
#	./fastboot flash sbl1bak $SBL1
	./fastboot flash sdi $SDI
	./fastboot flash aboot $APPBOOT
	./fastboot flash abootbak $APPBOOT
	./fastboot flash rpm $RPM
	./fastboot flash rpmbak $RPM
	./fastboot flash boot $KERNEL
	./fastboot flash tz $TZ 
	./fastboot flash tzbak $TZ
	./fastboot flash system $SYSTEM
	./fastboot flash recovery $RECOVERY
	./fastboot flash cache $CACHE
	./fastboot flash userdata $USERDATA
	./fastboot flash splash $BOOTLOGO
	./fastboot flash Log $LOG
	./fastboot flash kitting $KITTING
	./fastboot reboot
	;;
 
  2)
    echo "Flash sbl1.mbn "
	./adb reboot-bootloader
	./fastboot flash sbl1 $SBL1
	./fastboot flash sbl1bak $SBL1
	./fastboot reboot
    ;;
 
  3)
	echo "Flash emmc_appsboot.mbn(lk) "
	./adb reboot-bootloader
	./fastboot flash aboot $APPBOOT
	./fastboot flash abootbak $APPBOOT
	./fastboot reboot
    ;;
 
  4)
	echo "Flash boot.img "
	./adb reboot-bootloader
	./fastboot flash boot $KERNEL
	./fastboot reboot
    ;;
 
  5)
	echo "Flash system.img "
	./adb reboot-bootloader
	./fastboot flash system $SYSTEM  
	./fastboot reboot
    ;;
 
  6)
	echo "Flash recovery.img "
	./adb reboot-bootloader
	./fastboot flash recovery $RECOVERY
	./fastboot reboot
    ;;

  7)
	echo "Flash userdata.img "
	./adb reboot-bootloader
	./fastboot flash userdata $USERDATA
	./fastboot reboot
    ;;

  8)
	echo "Flash cache.img "
	./adb reboot-bootloader
	./fastboot flash cache $CACHE
	./fastboot reboot
    ;;

  9)
	echo "Flash splash.img(bootlogo) "
	./adb reboot-bootloader
	./fastboot flash splash $BOOTLOGO
	./fastboot reboot
    ;;

  g | G)
  	echo "write partition"
	./adb reboot-bootloader
	./fastboot flash partition $GPT  
    ;;

  r | R)
	echo "fastboot reboot"
	pause 'Press any key to continue...'
	./fastboot reboot 
    ;;

  f | F)
	echo "Enter fastboot mode"
	./adb reboot bootloader 
    ;;

  l | L)
	echo "List USB devices "
	./lsusb 
    ;;

  q | Q)
    echo "Quit."
    exit $EXIT_SUCCESS
    ;;

  b | B)
	echo "Backup factory data: persist, modem, fsg"
	echo -e "\x1b[0m \x1b[1;35m"
	read -p "Please input store directory: " user_input
	echo -e "\x1b[0m"
	FACTORY_PATH=${user_input:-"FACTORY_PATH"}
	echo ${FACTORY_PATH} > ${FACTORY_FILE}
	mkdir -p ${FACTORY_PATH}
	./adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/persist of=/data/persist.img"
	./adb pull /data/persist.img ${FACTORY_PATH}/.
	./adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/modemst1 of=/data/modemst1.bin"
	./adb pull /data/modemst1.bin ${FACTORY_PATH}/.
	./adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/modemst2 of=/data/modemst2.bin"
	./adb pull /data/modemst2.bin ${FACTORY_PATH}/.
	./adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/fsg of=/data/fsg.bin"
	./adb pull /data/fsg.bin ${FACTORY_PATH}/.
    ;;

  s | S)
	echo "Restore factory data: persist, modem, fsg"
	cat ${FACTORY_FILE} | while read FACTORY_PATH
	do
		if [ "${FACTORY_PATH}" == "" ] || [ ! -d "${FACTORY_PATH}" ]; then
			echo -e "\x1b[0m \x1b[1;31m"
			echo "The ${FACTORY_PATH} is NOT exist."
			echo -e "\x1b[0m"
		else
			./adb reboot-bootloader
			./fastboot flash persist ${FACTORY_PATH}/persist.img
			./fastboot flash qsns ${FACTORY_PATH}/persist.img
			./fastboot flash modemst1 ${FACTORY_PATH}/modemst1.bin
			./fastboot flash modemst2 ${FACTORY_PATH}/modemst2.bin
			./fastboot flash fsg ${FACTORY_PATH}/fsg.bin
			./fastboot reboot
		fi
	done
	;;

  *)
    echo "Unknown choice."
    MENU_ENTRY
    ;;
  esac

	if [ $interactive -eq 1 ];then
    MENU_ENTRY
	fi
}

#Main program
if [ $# -eq 0 ]; then
interactive=1
MENU_ENTRY
else
interactive=0
choice=$1
CHOICE
exit $EXIT_SUCCESS
fi
