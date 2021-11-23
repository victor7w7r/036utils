#!/usr/bin/env bash

rm /tmp/diskenvtemp.sh* 2> /dev/null
rm /tmp/diskmenutemp.sh* 2> /dev/null
DISKMENUTEMP=/tmp/diskmenutemp.sh.$$	
DISKENVTEMP=/tmp/diskenvtemp.sh.$$	

function cleanup { rm $DISKENVTEMP; rm=$DISKMENUTEMP  exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

DISKENVIRONMENT=""
DISK=""

function corelive { clear; cover; sleep 1s; verify; diskenv; }
function corechroot { configurator; }

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
		SSD-NVMe "Solid State Disk or NVMe" 2>"${DISKENVTEMP}"

	CHOICE=$(<"${DISKENVTEMP}")
    $CHOICE echo
	case $CHOICE in
		HDD) DISKENVIRONMENT="HDD"; disclaimer ;;
        SSD-NVMe) DISKENVIRONMENT="SSD"; disclaimer ;;
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

    #ARCH=$(uname -m)
    OPERATING=$(uname -o)
	SELECTOR=""

	if [ "$OPERATING" != "GNU/Linux" ]; then
		clear
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 1
	fi

    if [ "$(id -u)" -ne 0 ]; then
		clear
        echo "ERROR: You need to be root."
        exit 1
    fi
	
	#if [ -d /sys/firmware/efi ]; then
	#	echo "ready" &> /dev/null
	#else
	#	clear
	#	echo "ERROR: This scripts only works in UEFI/EFI systems, consider change your PC or check your BIOS"
	#	exit 1
	#fi

    #if [ "$ARCH" != "x86_64" ]; then
    #    echo "ERROR: This script is only intended to run on x86_64 PCs."
    #    exit 1
    #fi

    SELECTOR="pacman"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		clear
		echo "ERROR: Arch Linux pacman is not available in this system, this system isn't Arch Linux?"
		exit 1
	fi

    PING=$(ping -c 1 8.8.8.8 2>&1) 

    if [[ "$PING" =~ unreachable* ]]; then
		clear
		echo "ERROR: This PC doesn't have internet connection, please check"
		exit 1
	fi

    echo "Updating Arch Repositories..."
    pacman -Sy &> /dev/null

    SELECTOR="lsb_release"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		clear
		echo "lsb_release is not available in this system, installing"
		pacman -S lsb-release --noconfirm
	fi

	if [ "$OPERATING" != "GNU/Linux" ]; then
		clear
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 1
	fi

	IS_ARCH=$(lsb_release -is)

	if [ "$IS_ARCH" != "Arch" ]; then
		clear
		echo "ERROR: Your Operating System is not Arch Linux, exiting"
		exit 1
	fi

	SELECTOR="fsck.f2fs"
	whichverify "$SELECTOR"
	local res=$?
	if [ $res -eq 1 ]; then
		echo "f2fs.tools is not available in this system, installing"
		pacman -S f2fs-tools --noconfirm &> /dev/null
	fi

	SELECTOR="dialog"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "dialog is not available in this system, installing"
		pacman -S dialog --noconfirm &> /dev/null
	fi

    SELECTOR="pacstrap"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "pacstrap is not available in this system, installing"
		pacman -S arch-install-scripts --noconfirm &> /dev/null
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

	dialog --msgbox "DANGER!!!: Your destination device would be formatted and empty, formatting always cause data loss, PLEASE backup all your data before start" 8 70

	if [ "$DISKENVIRONMENT" == "HDD" ] ; then
		dialog --msgbox "Before installing, we recomend that your disk has the next partition scheme, before install\n\n\
		GPT -> \n \
		1.	/dev/sdX1	EFI			200MB		fat32		esp\n\
		2.	/dev/sdX2	archlinux	>20GB		ext4		primary\n\
		3.	/dev/sdx3	linux-swap	2GB-4GB		swap		primary\n\n\

		GNU Parted script example  for format a 20GB disk\n\n \

		mklabel gpt \ \n \
		mkpart primary fat32 1MiB 200MiB \ \n \
		set 1 esp on \ \n \
		mkpart primary ext4 200MiB 19.0GiB \ \n \
		mkpart primary linux-swap 19.0GiB 100% \ \n" 20 70

	elif [ "$DISKENVIRONMENT" == "SSD" ]; then
	dialog --msgbox "Before installing, we recomend that your disk has the next partition scheme, before install\n\n\
		GPT -> \n \
		1.	/dev/sdX1	EFI			200MB		fat32		esp\n\
		2.	/dev/sdX2	archlinux	>20GB		f2fs/ext4		primary\n\

		GNU Parted script example for format a 20GB disk\n\n \

		mklabel gpt \ \n \
		mkpart primary fat32 1MiB 200MiB \ \n \
		set 1 esp on \ \n \
		mkpart primary f2fs 200MiB 100% \ \n" 20 70
	fi
	diskmenu

}

function diskverify() {

	LABEL=$(blkid -o value -s PTTYPE "$1")
	EFI=""
	EFIORDER=""

	if [ "$LABEL" == "dos" ]; then
		ERROR: "The device has a DOS Label Type (MBR), this script only works with gpt"
		exit 1
	fi

	if [[ $1 =~ sd[[:alpha:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$($EFI | sed -ne '/[[:alpha:]]1/p' )

		if [ "$EFI" == "" ]; then
			ERROR: "The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			ERROR: "The device has the EFI partition in other side than $1 1"
			exit 1
		fi

		DISK=$1
		rootpartmenu

	elif [[ $1 =~ mmcblk[[:digit:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$($EFI | sed -ne '/p1/p' )

		if [ "$EFI" == "" ]; then
			ERROR: "The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			ERROR: "The device has the EFI partition in other side than $1 1"
			exit 1
		fi

		DISK=$1
		rootpartmenu

	elif [[ $1 =~ nvme[[:digit:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$($EFI | sed -ne '/p1/p' )

		if [ "$EFI" == "" ]; then
			ERROR: "The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			ERROR: "The device has the EFI partition in other side than $1 1"
			exit 1
		fi

		DISK=$1
		rootpartmenu

	fi

}

function diskmenu {

	clear
	COUNT=0
	BLOCK=()
	DIRTYDEVS=()

	DEVICES=$(find /dev/disk/by-id/| sort -n | sed 's/^\/dev\/disk\/by-id\///') # 3.0_high_speed_000000123AFF-0:0 ...

	for DEVICE in $DEVICES; do
		DIRTYDEVS[$COUNT]=$(readlink "/dev/disk/by-id/$DEVICE") # ../../sda ../../sda1 ... 
		COUNT=$(( COUNT + 1 ))
	done

	if [ $COUNT -eq 0 ]; then
		clear
		echo "FATAL ERROR: There's not disks available in your system, please verify!!!"
		exit 1
	fi

	COUNT=0

	echo "${DIRTYDEVS[@]}"
	read -r -p "dasdsa"

	for DEV in "${DIRTYDEVS[@]}"; do	

		ABSOLUTEPARTS=$(echo "$DEV" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d' | sed '/nvme[[:digit:]]$/d') #/dev/sda1 /dev/sda2 ...

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

		dialog --clear --backtitle "036 Creative Studios" --title "Choose a device" \
		--menu "Choose a device for install"\
		15 50 4 "${ARGSPOWEROFF[@]}" 2>"${DISKMENUTEMP}"

	CHOICE=$(<"${DISKMENUTEMP}")

	case $CHOICE in
		"$CHOICE") diskverify "$CHOICE";;
		*) clear;;
	esac
}

function rootpartmenu {
	#Menu para seleccionar la particion de raiz de arch
	diskformat
}

function diskformat {
	#Empezar a formatear el disco, poner un messagebox de si o no advirtiendo el formateo
	#poner los mensajes como rsyncer, montar los sistemas tambien
	pacstraper
}

function unmounter {
	exit 0
}

function pacstraper {
	#Poner en mensajes como el rsyncer, el pacstrapeo
	#POner el genfstab tambien
	toggler
}

function toggler {
	#realizar las primeras acciones de instalacion
	cp "$0" /mnt/arch-setupper.sh
	arch-chroot /mnt ./arch-setupper.sh chroot
	if [ -f /mnt/arch-setupper.sh ]; then
        echo 'ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate.'
        echo 'Please umount, and restart this script'
		#unmount_filesystems
		echo "desmontar"
    fi
}

function configurator {
	echo "aa"
}

if [ "$1" == "chroot" ]; then
	corechroot
else
	corelive
fi



[ -f $DISKENVTEMP ] && rm $DISKENVTEMP 
[ -f $DISKMENUTEMP ] && rm $DISKMENUTEMP 