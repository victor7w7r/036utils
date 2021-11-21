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

rm /tmp/menu.sh.* 2< /dev/null
rm /tmp/output.sh.* 2< /dev/null
rm /tmp/mounttemp.sh.* 2< /dev/null

INPUT=/tmp/menu.sh.$$	
OUTPUT=/tmp/output.sh.$$
MOUNTTEMP=/tmp/mounttemp.sh.$$

trap "rm $OUTPUT; rm $INPUT; rm $MOUNTTEMP; exit" SIGHUP SIGINT SIGTERM

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
		echo "ERROR: There's no USB drives connected in this PC"
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

function poweroff {
	clear
	read -p "Press enter to return";
		MODEL=$(cat /sys/class/block/sda/device/model)
}

function mountaction() {
	clear
	echo "$1"
	read -p "Press enter to return";
	MODEL=$(cat /sys/class/block/sda/device/model)

}

function mountmenu {
	clear
	usbstat
	USBS=$(ls -r /dev/disk/by-id | grep usb)
	PREARRAY=()
	ARRAYUSB=()
	BLOCK=0
	COUNT=0

	for DEV in $USBS; do
		PREARRAY[$COUNT]=$(readlink "/dev/disk/by-id/$DEV") 
		COUNT=$(( COUNT + 1 ))
	done
	COUNT=0
	QUANTITY=0
	BLOCKCOUNT=0
	for ARRAY in "${PREARRAY[@]}"; do
		if [ "$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d')" != "" ]; then
			ARRAYUSB[$COUNT]=$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\///' | sed '/.*sd[[:alpha:]]$/d') 
			COUNT=$(( COUNT + 1 ))
			QUANTITY=$(( QUANTITY + 1 ))
		else
			BLOCK[$BLOCKCOUNT]=$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\///') 
			BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))
		fi
	done

	COUNT=0
	TYPE=0
	MODEL=0
	DEVICE=0
	ARGS=()

	for LIST in "${ARRAYUSB[@]}"; do
		DEVICE="/dev/$LIST"
		TYPE="$(lsblk -f /dev/"$LIST" | sed -ne '2p' | cut -d " " -f2)"
		MODEL="$(cat /sys/class/block/"${BLOCK[COUNT]}"/device/model)"
		ARGS+=("$DEVICE" "$MODEL $TYPE")
		COUNT=$(( COUNT + 1 ))

	done

	dialog --clear --backtitle "036 Creative Studios" --title "Mount a Device" \
		--menu "Please Mount a device \n" 15 50 4 "${ARGS[@]}" 2>"${MOUNTTEMP}"

	CHOICE=$(<"${MOUNTTEMP}")
	REGEX=$(echo "$CHOICE" | sed 's/^\/dev\/.*/\/dev\//')

	case $REGEX in
		"$REGEX") mountaction "$CHOICE";;
		*) clear;;
	esac

}

function menu {
	while true; do
		dialog --clear --backtitle "036 Creative Studios" \
			--title "036 USB Manager" \
			--menu "Choose a Option\n" 15 50 4 \
			Mount "Mount a device" \
			Power-off "Unmount and secure turn-off a USB" \
			Exit "Exit to the shell" 2>"${INPUT}"

		menuitem=$(<"${INPUT}")

		case $menuitem in
			Mount) mountmenu;;
			Power-off) poweroff;;
			Exit) clear; exit 0;;
			*) clear; exit 0;;
		esac
	done
}

core

[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT 
[ -f $MOUNTTEMP ] && rm $MOUNTTEMP