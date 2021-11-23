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


rm /tmp/source.sh* 2> /dev/null
rm /tmp/dest.sh* 2> /dev/null
SOURCE=/tmp/source.sh.$$
DEST=/tmp/dest.sh.$$

function cleanup { rm $SOURCE; rm $DEST; exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

function core { clear; cover; sleep 1s; verify; sourceaction; destiaction; }

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

function syncer() {

    SOURCEREADY=""
    DESTREADY=""

    if [ "$2" == "" ]; then
        exit 0
    fi

    if [[ "$1" =~ .*\/$  ]]; then
        SOURCEREADY="$1"
    else
        SOURCEREADY="$1/"
    fi


    if [[ "$2" =~ .*\/$  ]]; then
        DESTREADY="$2"
    else
        DESTREADY="$2/"
    fi


    if [ -d "$2" ]; then
        clear
        echo -e "=============== START RSYNC =============== \n" 
        echo "SOURCE: $1"
        echo "DESTINATION: $2"
        $SUDO rsync -axHAWXS --numeric-ids --info=progress2 "$SOURCEREADY" "$DESTREADY"

        echo -e "\n =============== OK =============== \n" 
        echo -e "Done\n!"
        exit 0
    else
        clear
        echo "ERROR: The directory \"$2\" doesn't exist"
        read -r -p "Press Enter to continue..."
        destiaction
    fi
}

function sourceaction {

    dialog --title "036 rsyncer" \
    --backtitle "036 Creative Studios" \
    --inputbox "Please write your source directory (Always put a / at the end)" 8 80 2>"$SOURCE"

    RESPONSE=$?
    DATA=$(<$SOURCE)

    case $RESPONSE in
    0) 
        destiaction "${DATA}" ;;
    1) 
        clear; exit 0  
        return;;
    255) 
        clear; exit 0
        return;;
    esac

}

function destiaction() {

    clear

    if [ "$1" == "" ]; then
        exit 0

    elif [ -d "$1" ]; then
        dialog --title "036 rsyncer" \
        --backtitle "036 Creative Studios" \
        --inputbox "Please write your destination directory to copy (Always put a / at the end)" 8 80 2>"$DEST"

        RESPONSE=$?
        DATA=$(<$DEST)

        case $RESPONSE in
        0) 
            syncer "$1" "${DATA}" ;;
        1) 
            clear break;;
        255) 
            clear break;;
        esac
    else
        clear
        echo "ERROR: The directory \"$1\" doesn't exist"
        read -r -p "Press Enter to continue..."
        sourceaction
    fi
}

function verify {

    OPERATING=$(uname -o)
	SELECTOR=""

	if [ "$OPERATING" != "GNU/Linux" ]; then
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 0
	fi

	SELECTOR="rsync"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "ERROR: The rsync binary is not available in this system, please install"
		exit 0
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
	clear

    sourceaction
}

core

[ -f $SOURCE ] && rm $SOURCE
[ -f $DEST ] && rm $DEST

