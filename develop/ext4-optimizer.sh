#!/usr/bin/env bash

SUDO=
if [ "$EUID" != "0" ]; then
	if  [ -e /usr/bin/sudo ] || [ -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo "ERROR: In this system the binary sudo doesn't exist."
		exit 0
	fi
fi

rm /tmp/menu.sh* 2> /dev/null
rm /tmp/defrag.sh* 2> /dev/null
INPUT=/tmp/menu.sh.$$
DEFRAG=/tmp/defrag.sh.$$

function cleanup { rm $INPUT; rm $DEFRAG; exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

function core { clear; cover; sleep 1s; verify; menu; }

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

function whichverify() {
	stat=$(which "$1" 2>&1)
	if [[ "$stat" =~ ^which:* ]]; then 
		return 1
	else
		return 0
	fi
}

function ext4stat {

	COUNT=0
	EXTCOUNT=0
	ABSOLUTEPARTS=""
	DIRTYDEVS=()

	ROOT=$(df -h | sed -ne '/\/$/p' | cut -d" " -f1)

	VERIFY=$(find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///')

	for DEVICE in $VERIFY; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ...
		COUNT=$(( COUNT + 1 ))
	done
	
	COUNT=0

	for DEV in "${DIRTYDEVS[@]}"; do

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d') #/dev/sda1 /dev/sda2 ...
		if [ "$ABSOLUTEPARTS" != "" ]; then
			if [ "$ABSOLUTEPARTS" != "$ROOT" ]; then
				PARTS[$COUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///' | sed '/.*[[:alpha:]]$/d'| sed '/blk[[:digit:]]$/d') #sda1 sda2 ...
				COUNT=$(( COUNT + 1 ))
			fi
		fi

	done

	for PART in "${PARTS[@]}"; do
		TYPE="$(lsblk -f /dev/"$PART" | sed -ne '2p' | cut -d " " -f2)"
		if [ "$TYPE" == "ext4" ]; then
			EXTCOUNT=$((EXTCOUNT + 1))
		fi
	done

	if [ $EXTCOUNT -eq 0 ]; then
		clear
		echo "ERROR: There's not ext4 partitions available"
		exit 0
	fi

}

function verify {

    OPERATING=$(uname -o)
	SERVICE=$(systemctl is-active udisks2)
	SELECTOR=""

	if [ "$OPERATING" != "GNU/Linux" ]; then
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 0
	fi

	SELECTOR="e4defrag"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "ERROR: e4defrag binary is not present in this system, please install"
		exit 0
	fi

	SELECTOR="fsck.ext4"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "ERROR: fsck.ext4 is not present in this system, please install"
		exit 0
	fi

	SELECTOR="dialog"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "ERROR: The dialog binary is not available in this system, please install"
		exit 0
	fi
	
	if [ "$SERVICE" == "inactive"  ]; then
		echo "ERROR: The udisks2 service is not running, please enable the service"
		exit 0
	fi

	ext4stat

	echo "All dependencies is ok!"

	START=$(date +%s)
	CHARS="/-\|"

	while [[ $(($(date +%s) - START)) -lt 2 ]]; do
		for (( i=0; i<${#CHARS}; i++ )); do
			sleep 0.08
			echo -en "${CHARS:$i:1}" "\r"
		done
	done
	clear

}

function defragaction {
	clear
	CODE=0

	if [ "$1" == "" ]; then
		return 0;
	fi
	echo -e "=============== VERIFY FILESYSTEM ERRORS =============== \n" 
	
	$SUDO fsck.ext4 -y -f -v "$1"
	CODE=$?

	if [ $CODE -ne 0 ]; then
		echo -e "=============== FAILURE =============== \n" 
		read -r -p "Press Enter to continue..."
		return 0;
	fi
	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."
	clear

	echo -e "=============== OPTIMIZE FILESYSTEM =============== \n" 

	$SUDO fsck.ext4 -y -f -v -D "$1"
	CODE=$?

	if [ $CODE -ne 0 ]; then
		echo -e "=============== FAILURE =============== \n" 
		read -r -p "Press Enter to continue..."
		return 0;
	fi
	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."
	clear

	$SUDO mkdir /tmp/optimize 2> /dev/null
	$SUDO mount "$1" /tmp/optimize

	echo -e "=============== DEFRAG FILESYSTEM =============== \n" 
	
	$SUDO e4defrag -v "$1"
	CODE=$?

	echo " "
	$SUDO umount "$1"
	echo -e "=============== READY =============== \n" 
	read -r -p "Press Enter to continue..."
	clear

	echo -e "=============== LAST VERIFY FILESYSTEM =============== \n" 
	
	$SUDO fsck.ext4 -y -f -v "$1"
	CODE=$?

	if [ $CODE -ne 0 ]; then
		echo -e "=============== FAILURE =============== \n" 
		read -r -p "Press Enter to continue..."
		return 0;
	fi
	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."
	clear
	
}

function defragmenu {
	COUNT=0
	EXTCOUNT=0
	MOUNTCOUNT=0
	ABSOLUTEPARTS=""
	DIRTYDEVS=()
	EXTPARTS=()
	UMOUNTS=()

	ROOT=$(df -h | sed -ne '/\/$/p' | cut -d" " -f1)

	VERIFY=$(find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///')

	for DEVICE in $VERIFY; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ...
		COUNT=$(( COUNT + 1 ))
	done
	
	COUNT=0

	for DEV in "${DIRTYDEVS[@]}"; do

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d') #/dev/sda1 /dev/sda2 ...
		if [ "$ABSOLUTEPARTS" != "" ]; then
			if [ "$ABSOLUTEPARTS" != "$ROOT" ]; then
				PARTS[$COUNT]=$(echo "$DEV" | sed 's/^\.\.\/\.\.\///' | sed '/.*[[:alpha:]]$/d'| sed '/blk[[:digit:]]$/d') #sda1 sda2 ...
				COUNT=$(( COUNT + 1 ))
			fi
		fi

	done

	for PART in "${PARTS[@]}"; do
		TYPE="$(lsblk -f /dev/"$PART" | sed -ne '2p' | cut -d " " -f2)"
		if [ "$TYPE" == "ext4" ]; then
			EXTCOUNT=$((EXTCOUNT + 1))
			EXTPARTS+=("$PART")
		fi
	done

	if [ $EXTCOUNT -eq 0 ]; then
		clear
		echo "ERROR: There's not ext4 partitions available"
		exit 0
	fi

	for PARTITIONSDEF in "${EXTPARTS[@]}"; do
		MOUNTED=$(lsblk "/dev/$PARTITIONSDEF" | sed -ne '/\//p')
		if [ "$MOUNTED" != "" ]; then
			MOUNTCOUNT=$(( MOUNTCOUNT + 1 ))
		else
			UMOUNTS+=("/dev/$PARTITIONSDEF" "ext4")
		fi
	done

	if [ $MOUNTCOUNT -eq $EXTCOUNT ]; then
		clear
		echo "ERROR: All the ext4 partitions are mounted in your system, please unmount the desired partition to optimize"
		read -r -p "Press Enter to continue..."
		return 0
	fi

	dialog --clear --backtitle "036 Creative Studios" --title "Optimize a Partition" \
		--menu "Please select a partition \n" 15 50 4 "${UMOUNTS[@]}" 2>"${DEFRAG}"

	CHOICE=$(<"${DEFRAG}")
	case $CHOICE in
		"$CHOICE") defragaction "$CHOICE";;
		null) clear; exit 0; ;;
	esac
}

function menu {

	while true; do

		dialog --clear --backtitle "036 Creative Studios" \
			--title "036 ext4 Optimizer" \
			--menu "Choose a Option\n" 15 50 4 \
			Optimize "Optimize a partition of a device" \
			Exit "Exit to the shell" 2>"${INPUT}"

		menuitem=$(<"${INPUT}")

		case $menuitem in
			Optimize) defragmenu;;
			Exit) clear; exit 0;;
			*) clear; exit 0;;
		esac
	done
}

core

[ -f $INPUT ] && rm $INPUT
[ -f $DEFRAG ] && rm $DEFRAG