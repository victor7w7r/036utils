#!/usr/bin/env bash

rm /tmp/diskenvtemp.sh* 2> /dev/null
DISKENVTEMP=/tmp/diskenvtemp.sh.$$	

function cleanup { rm $DISKENVTEMP; exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

DISKENVIRONMENT=""

function core { clear; cover; sleep 1s; verify; diskenv; }

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

function diskenv {

    dialog --clear --backtitle "036 Creative Studios" --title "Disk Environment" \
		--menu "Please choose your disk type \n" 15 50 4 \
        HDD "Hard Drive Disk" \
		SSD/NVMe "Solid State Disk or NVMe" 2>"${DISKENVTEMP}"

	CHOICE=$(<"${DISKENVTEMP}")
	case $CHOICE in
		HDD) DISKENVIRONMENT="HDD"; disclaimer ;;
        SSD) DISKENVIRONMENT="SSD"; disclaimer ;;
		*) clear; exit 0; ;;
	esac

}

function whichverify() {
	stat=$(which "$1" 2>&1)
	if [[ "$stat" =~ ^which:* ]]; then 
		return 1
	else
		return 0
	fi
}

function verify {

    ARCH=$(uname -m)
    OPERATING=$(uname -o)
	SELECTOR=""

	if [ "$OPERATING" != "GNU/Linux" ]; then
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 1
	fi

    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: You need to be root."
        exit 1
    fi

    if [ "$ARCH" != "x86_64" ]; then
        echo "ERROR: This script is only intended to run on x86_64 PCs."
        exit 1
    fi

    SELECTOR="pacman"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "ERROR: Arch Linux pacman is not available in this system, this system isn't Arch Linux?"
		exit 1
	fi

    PING=$(ping -c 1 8.8.8.8 2>&1) 

    if [[ "$PING" =~ unreachable* ]]; then
		echo "ERROR: This PC doesn't have internet connection, please check"
		exit 1
	fi

    echo "Updating Arch Repositories..."
    pacman -Syy &> /dev/null

    SELECTOR="lsb_release"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "lsb_release is not available in this system, installing"
		pacman -S lsb-release --noconfirm
	fi

	if [ "$OPERATING" != "GNU/Linux" ]; then
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 0
	fi

	IS_ARCH=$(lsb_release -is)

	if [ "$IS_ARCH" != "Arch" ]; then
		echo "ERROR: Your Operating System is not Arch Linux, exiting"
		exit 0
	fi

	SELECTOR="fsck.f2fs"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "f2fs.tools is not available in this system, installing"
		pacman -S f2fs-tools --noconfirm
	fi

	SELECTOR="dialog"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "dialog is not available in this system, installing"
		pacman -S dialog --noconfirm
	fi

	echo "All dependencies is ok!"

	START=$(date +%s)
	CHARS="/-\|"

	while [[ $(($(date +%s) - START)) -lt 2 ]]; do
		for (( i=0; i<${#CHARS}; i++ )); do
			sleep 0.08
			echo -en "${CHARS:$i:1}" "\r"
		done
	done

}

function disclaimer {

    clear
    while true; do
        echo $DISKENVIRONMENT
    done
    
    read -r -p "sadsda"
}

core

[ -f $DISKENVTEMP ] && rm $DISKENVTEMP 