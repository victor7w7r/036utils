#!/bin/bash 
####!/usr/bin/env bash
SUDO=
if [ "$EUID" != "0" ]; then
	if  [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo "ERROR: In this system the binary sudo doesn't exist."
		exit 0
	fi
fi

rm /tmp/menu.sh* 2< /dev/null
rm /tmp/output.sh* 2< /dev/null
rm /tmp/mounttemp.sh* 2< /dev/null
rm /tmp/powerofftemp.sh* 2< /dev/null

INPUT=/tmp/menu.sh.$$	
OUTPUT=/tmp/output.sh.$$
MOUNTTEMP=/tmp/mounttemp.sh.$$
POWEROFFTEMP=/tmp/powerofftemp.sh$$

trap "rm $OUTPUT; rm $INPUT; rm $MOUNTTEMP; rm $POWEROFFTEMP; exit" SIGHUP SIGINT SIGTERM

function core { clear; cover; logo; sleep 1s; verify; usbstat; menu; }

function cover {
	echo '          					    ``...`                                                    '
	echo '                                      `..:/+++/--/shdmmmmmhy+:.`                                              '
	echo '                                  `-+ydmMMMMMMMMMMMMMMMMMMMMMMNds:`                                           '
	echo '                               `/ymMMMMMNmNMMMMMMMMMMMMNhooyNNMMMMmy:`                                        '
	echo '                             -yNMMMMMNy//hMMMMMMMNyymMMMMNdhm-:sNMMMMd/                                       '
	echo '                           .yMMMMMMNo.`oMMMMMMMMod: .ydMMMMMM+.``omMMMMh.                                     '
	echo '                         `oNMMMMMMo` -MMMMMMMMMmdmMNNmyNMMMMMMMNy/`oNMMMN/                                    '
	echo '                        /mMMMMMMs.  oMMMMMMMNo.  :Mo:hMMs:mMMMMNMMmyhMMMMMo-`                                  '
	echo '                      -hMMMMMMy. .sdMMMMMMMh.o/-/sy:+NMNhys+/:-......--:/+oshddyo/-`                           '
	echo '                    `sNMMMMMh: ` +MMMMMMMMo` .dshs yMh.` `.-..               ``-/oydds/.                       '
	echo '                   /mMMMMMm/`  odMMMMMMMm- s::ydomsMy``+o+:-:/++/`                 `./sdds/.                   '
	echo '                 `yMMMMMMs`   -mMMMMMMMh.  +y+/:-hMs `h-       `:y.                    `.+hmh+.               '
	echo '                -dMMMMMm:  `.:NMMMMMMMs` ./hyso/dMo  :y   //:/-  :y                        ./hmh/`            '
	echo '               :mMMMMMd.   `+NMMMMMMN+ .-ohyyhhhMo   `h.  :: `y   N                           .odmo.           '
	echo '              +NMMMMMy`  `./NMMMMMMN/   `+/-:/yMo     .o:.`.-+-  -d                             `/dNs.        '
	echo '             oMMMMMMs`  o-+MMMMMMMN:`::/oo-  +Ms        -----`  -y-                               `oNm/       '
	echo '           `sMMMMMMo   +yoNMMMMMMm-`o/`-oyh`+Ms          `````-oo`                                  -dMy`     '
	echo '          `yMMMMMN/    /yNMMMMMMd. -h--h+-ysMy          `-////:`                                     `dMh`    '
	echo '          yMMMMMN:  -+:oMMMMMMMd````y++o++sNh`                                                        `mMy    '
	echo '        /MMMMMy`   /+ooMMMMMMh`  ./+N:-+oNm`                                                            mMd   '
	echo '       .NMMMMs  `+ +++MMMMMMy   so++s++oNNs+oooo/-       `/oysyyso/.                                    yMM   '
	echo '       dMMMM+    :s `mMMMMMs `o +++o.-:mN.     `-o-     -h+-`   `-/sh+                                  yMM   '
	echo '      /MMMM+  -/o msoMMMMMo   :y `-s-`dN-                            `                                  hMN    '
	echo '      dMMM+   +oooy:mMMMMo ./o`do:+y/yM/                  `:/`                                         `NMh    '
	echo '     /MMMs  --:+s+osMMMM+  :sy/d//+hNM+            `/   .  `:y                                         sMM:    '
	echo '     mMMd` .mss+`hoyMMM+  `./ss++oohMo             .+  `y+/:+:                                        :MMy     '
	echo '    /MMN. o+mhym/yyNMMs  syo+./y. +Ny               -:::. ``                                         :NMd`     '
	echo '    dMM/`-ysoshh.`+MMm``-yhhdohysyMM:                                                               /NMd.      '
	echo '   :MMy.-sd:oy+y.`dMM/ :od+dhs./oNmmNh/.                                                          `oMMs`      '
	echo '   yMN.-/oy.+yys-hMMd -hy:yy+o `dm.`/ymdyysooo+///::--.......................--::////////+++++oooshNmo   	    '
	echo '  `MMy/+yyosy/-/dMMM/:/ss-oys/`dN-    `.--:://++ooosssyyyyyhyyyyhhhhhhhyyyhyyyssoo++++++///////::::-`         '
	echo '  +Mm`.+dy+sy.-mmNMm`.oys/yyo+hN:                                                                             '
	echo '  yMo/m+.`.-o/Nd-MMo+hho:oh``yM/                                                                               '
	echo '  hMd+ysy+:/yMy`:Mm :+ysoo+ yM/                                                                                '
	echo '  yM/h+-h``hMo  +My+d:`- :syM+                                                                                '
	echo '  oMds+ms+Nm-   +Mm/yyd//:hM/                                                                                  '
	echo '  -Mh  :dNs`    /Mod+:h``dN:                                                                                  	'
	echo '   oNdmms.      -Mmhody/mm-                                                                                    '
	echo '    .--`         mN. -yMy.                                                                                     '
	echo '                  /Nhsmd/                                                                                       '
	echo '                  -/+-`                     '
}

function logo {
	echo '                                                                                                                     '
	echo '.oPYo. .oPYo. .pPYo.   .oPYo.                       o   o                 .oPYo.   o              8  o                '
	echo '8  .o8     `8 8        8    8                       8                     8        8              8                   '
	echo '8 .P`8   .oP` 8oPYo.   8      oPYo. .oPYo. .oPYo.  o8P o8 o    o .oPYo.   `Yooo.  o8P o    o .oPYo8 o8 .oPYo. .oPYo.  '
	echo '8.d` 8    `b. 8`  `8   8      8  `` 8oooo8 .oooo8   8   8 Y.  .P 8oooo8       `8   8  8    8 8    8  8 8    8 Yb..   '
	echo '8o`  8     :8 8.  .P   8    8 8     8.     8    8   8   8 `b..d` 8.            8   8  8    8 8    8  8 8    8   `Yb. '
	echo '`YooP` `YooP` `YooP`   `YooP` 8     `Yooo` `YooP8   8   8  `YP`  `Yooo`   `YooP`   8  `YooP` `YooP`  8 `YooP` `YooP. '
	echo ':.....::.....::.....::::.....:..:::::.....::.....:::..::..::...:::.....::::.....:::..::.....::.....::..:.....::.....:'
	echo ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
	echo ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'

}

function usbstat { 

	VERIFYUSB=$(ls /dev/disk/by-id | grep -c usb)
	if [ "$VERIFYUSB" -eq 0 ]; then
		clear
		echo "ERROR: There's no USB drives connected in this PC, or the devices are shutdown"
		exit 0
	fi
}

function verify {

    OPERATING=$(uname -o)
	SERVICE=$(systemctl is-active udisks2)

	if [ "$OPERATING" != "GNU/Linux" ]; then
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 0
	fi
	if [ -f /usr/bin/udisksctl ]; then
		echo 'ready' > /dev/null
	else
		echo "ERROR: The udisks command line tool (udisksctl) doesn't exist, please install udisks"
		exit 0
	fi
		if [ -f /usr/bin/dialog ]; then
		echo 'ready' > /dev/null
	else
		echo "ERROR: The dialog binary is not available in this system, please install"
		exit 0
	fi
	if [ "$SERVICE" == "inactive"  ]; then
		echo "ERROR: The udisks2 service is not running, please enable the service"
		exit 0
	fi

	usbstat

	echo "All dependencies is ok!"

	START=$(date +%s)
	CHARS="/-\|"

	while [[ $(($(date +%s) - $START)) -lt 2 ]]; do
		for (( i=0; i<${#CHARS}; i++ )); do
			sleep 0.08
			echo -en "${CHARS:$i:1}" "\r"
		done
	done
	clear

}

function poweroffaction() {
	clear
	
	if [ "$1" == "" ]; then
		return 0;
	fi

	BLOCKTEMP=$(echo "$1" | cut -d "/" -f3)
	PARTITIONSQUERY=$(ls /dev | grep -i "^""$BLOCKTEMP""[[:digit:]]$")
	
	for PARTITION in $PARTITIONSQUERY; do
		$SUDO udisksctl unmount -b "/dev/$PARTITION" 2> /dev/null
		for (( i=0; i<${#CHARS}; i++ )); do
			sleep 0.08
			echo -en "${CHARS:$i:1}" "\r"
		done
	done
	MODEL="$(cat /sys/class/block/"${BLOCKTEMP}"/device/model)"
	$SUDO udisksctl power-off -b "$1"
	dialog --msgbox "SUCCESS: Your device $MODEL was succesfully power-off" 7 35
	
}

function mountaction() {
	clear

	if [ "$1" == "" ]; then
		return 0;
	fi

	DATAMOUNT=$(udisksctl mount -b "$1" 2>&1)
	if [[ $DATAMOUNT =~ NotAuthorized* ]]; then
		echo "ERROR: Your attempt to get authorization is not valid (Invalid Password)"
		read -p "Press Enter to continue..."
	elif [[ $DATAMOUNT =~ AlreadyMounted* ]]; then
		echo "ERROR: Your USB drive is already mounted"
		read -p "Press Enter to continue..."
	else
		dialog --msgbox "SUCCESS: $DATAMOUNT" 7 35
	fi
}

function unmountmenu {
	clear
	usbstat
	MOUNTED=0
	MOUNTS=()
	DIRTYDEVS=()
	BLOCK=()


	USBS=$(ls /dev/disk/by-id | grep usb) # usb-USB3.0_high_speed_000000123AFF-0:0 ...

	for DEVICE in $USBS; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ... 
		COUNT=$(( COUNT + 1 ))
	done

	for DEV in "${DIRTYDEVS[@]}"; do

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d') #/dev/sda1 /dev/sda2 ...

		if [ "$ABSOLUTEPARTS" == "" ]; then
			BLOCK[$BLOCKCOUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///') #sda sdb 
			BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))
		fi
	done

	MOUNTED=$(lsblk /dev/sda | sed -ne '/\//p')

	if [ "$MOUNTED" == "" ]; then
		
	fi

	for MOUNTS in $MOUNTED; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ... 
		COUNT=$(( COUNT + 1 ))
	done

}

function poweroffmenu {
	clear
	usbstat

	DIRTYDEVS=()
	BLOCK=()

	USBS=$(ls /dev/disk/by-id | grep usb) # usb-USB3.0_high_speed_000000123AFF-0:0 ...

	for DEVICE in $USBS; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ... 
		COUNT=$(( COUNT + 1 ))
	done

	for DEV in "${DIRTYDEVS[@]}"; do

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d') #/dev/sda1 /dev/sda2 ...

		if [ "$ABSOLUTEPARTS" == "" ]; then
			BLOCK[$BLOCKCOUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///') #sda sdb 
			BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))
		fi
	done

	COUNT=0
	MODEL=0
	DEVICE=0
	ARGSPOWEROFF=()

	for PART in "${BLOCK[@]}"; do
		DEVICE="/dev/$PART"
		BLOCKSTAT="${BLOCK[$COUNT]}"
		MODEL="$(cat /sys/class/block/"$BLOCKSTAT"/device/model)" #KINGSTON 
		ARGSPOWEROFF+=("$DEVICE" "$MODEL")
		COUNT=$(( COUNT + 1 ))
	done

	dialog --clear --backtitle "036 Creative Studios" --title "Poweroff a Device" \
		--menu "Choose for poweroff a device \n" 15 50 4 "${ARGSPOWEROFF[@]}" 2>"${POWEROFFTEMP}"

	CHOICEOFF=$(<"${POWEROFFTEMP}")

	case $CHOICEOFF in
		"$CHOICEOFF") poweroffaction "$CHOICEOFF";;
		*) clear;;
	esac
}

function mountmenu {

	clear
	usbstat

	PARTS=()
	FLAGS=()
	BLOCK=()
	CHOICE=0
	COUNT=0
	BLOCKCOUNT=0

	USB=$(ls /dev/disk/by-id | grep usb) # usb-USB3.0_high_speed_000000123AFF-0:0 ...
	
	for DEVICE in $USB; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ...
		COUNT=$(( COUNT + 1 ))
	done
	
	COUNT=0

	for DEV in "${DIRTYDEVS[@]}"; do

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d') #/dev/sda1 /dev/sda2 ...

		if [ "$ABSOLUTEPARTS" != "" ]; then
			PARTS[$COUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///' | sed '/.*sd[[:alpha:]]$/d') #sda1 sda2 ...
			COUNT=$(( COUNT + 1 ))
		else
			BLOCK[$BLOCKCOUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///') #sda sdb
			BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))
			FLAGS+=( "$COUNT" ) #FLAGS FOR EVERY BLOCK CHANGE
		fi
		
	done

	COUNT=0

	TYPE=0
	MODEL=0
	DEVICE=0
	FLAGSCOUNT=0
	ARGS=()

	for PART in "${PARTS[@]}"; do
		DEVICE="/dev/$PART"
		TYPE="$(lsblk -f /dev/"$PART" | sed -ne '2p' | cut -d " " -f2)" #vfat, ext4
		TEMP="${FLAGS[$FLAGSCOUNT]}"
		
		if [ "$COUNT" == "$TEMP" ]; then
			BLOCKSTAT="${BLOCK[$FLAGSCOUNT]}"
			FLAGSCOUNT=$(( FLAGSCOUNT + 1 ))
		fi

		MODEL="$(cat /sys/class/block/"$BLOCKSTAT"/device/model)" #KINGSTON 
		ARGS+=("$DEVICE" "$MODEL $TYPE")
		COUNT=$(( COUNT + 1 ))
	done

	COUNT=0

	dialog --clear --backtitle "036 Creative Studios" --title "Mount a Device" \
		--menu "Please Mount a partition \n" 15 50 4 "${ARGS[@]}" 2>"${MOUNTTEMP}"

	CHOICE=$(<"${MOUNTTEMP}")
	case $CHOICE in
		"$CHOICE") mountaction "$CHOICE";;
		null) clear; exit 0; ;;
	esac

}

function menu {
	while true; do
		dialog --clear --backtitle "036 Creative Studios" \
			--title "036 USB Manager" \
			--menu "Choose a Option\n" 15 50 4 \
			Mount "Mount a partition of a device" \
			Power-off "Unmount and secure turn-off a USB" \
			Exit "Exit to the shell" 2>"${INPUT}"
		menuitem=$(<"${INPUT}")
		case $menuitem in
			Mount) mountmenu;;
			
			Power-off) poweroffmenu;;
			Exit) clear; exit 0;;
			*) clear; exit 0;;
		esac
	done
}

core

[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT 
[ -f $MOUNTTEMP ] && rm $MOUNTTEMP
[ -f $POWEROFFTEMP ] && rm $POWEROFFTEMP