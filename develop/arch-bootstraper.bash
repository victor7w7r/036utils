#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
	echo "ERROR: You need to be root."
	exit 1
fi

rm /tmp/diskenvtemp.sh* 2> /dev/null
rm /tmp/diskmenutemp.sh* 2> /dev/null
rm /tmp/rootpartmenutemp.sh* 2> /dev/null
rm /tmp/swapppartmenutemp.sh* 2> /dev/null

DISKMENUTEMP=/tmp/diskmenutemp.sh.$$	
DISKENVTEMP=/tmp/diskenvtemp.sh.$$	
ROOTPARTMENUTEMP=/tmp/rootpartmenutemp.sh.$$	
SWAPPARTMENUTEMP=/tmp/swapppartmenutemp.sh.$$	

function cleanup { rm $DISKENVTEMP; rm $DISKMENUTEMP; rm $ROOTPARTMENUTEMP; rm $SWAPPARTMENUTEMP  exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

DISKENVIRONMENT=""
DISK=""
ROOTPART=""
EFIPART=""
SWAPPART=""

function corelive { clear; cover; sleep 1s; verify; diskenv; }
function corechroot { configurator; hostnamer; localer; newuser; swapper; xanmod; graphical; aur; optimizations; icons; finisher; }

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

	clear
	LABEL=$(blkid -o value -s PTTYPE "$1")
	EFI=""
	EFIORDER=""
	BLOCK=""

	if [ "$LABEL" == "dos" ]; then
		echo "ERROR: The device has a DOS Label Type (MBR), this script only works with gpt"
		exit 1
	fi

	if [[ $1 =~ sd[[:alpha:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$(echo "$EFI" | sed -ne '/[[:alpha:]]1/p' )

		if [ "$DISKENVIRONMENT" == "SSD" ]; then
			BLOCK=$(echo "$1" | cut -d "/" -f3)
			ROTATIONAL="$(cat /sys/block/"$BLOCK"/queue/rotational)"

			if  [ "$ROTATIONAL" == "1" ]; then
				echo "ERROR: You choose a SSD device, but this device is rotational, if is that not the case, that device is USB"
				exit 1
			fi

		elif [ "$DISKENVIRONMENT" == "HDD" ]; then
		
			BLOCK=$(echo "$1" | cut -d "/" -f3)
			ROTATIONAL="$(cat /sys/block/"$BLOCK"/queue/rotational)"

			if  [ "$ROTATIONAL" == "0" ]; then
				echo "ERROR: ou choose a HDD device, but this device is not rotational, please check and run this script again"
				exit 1
			fi
		fi

		if [ "$EFI" == "" ]; then
			echo "ERROR: The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			echo "ERROR: The device has the EFI partition in other side than $1 1"
			exit 1
		fi

		DISK=$1
		rootpartmenu

	elif [[ $1 =~ mmcblk[[:digit:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$(echo "$EFI" | sed -ne '/p1/p' )

		if [ "$DISKENVIRONMENT" == "HDD" ]; then
			echo "ERROR: You choose a HDD device, but this device is not rotational, please check and run this script again"
			exit 1
		fi

		if [ "$EFI" == "" ]; then
			echo "ERROR: The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			echo "ERROR: The device has the EFI partition in other side than $1 1"
			exit 1
		fi

		DISK=$1
		rootpartmenu

	elif [[ $1 =~ nvme[[:digit:]] ]]; then

		EFI=$(fdisk -l "$1" | sed -ne '/EFI/p')
		EFIORDER=$(echo "$EFI" | sed -ne '/p1/p' )

		if [ "$DISKENVIRONMENT" == "HDD" ]; then
			echo "ERROR: You choose a HDD device, but this device is not rotational, please check and run this script again"
			exit 1
		fi

		if [ "$EFI" == "" ]; then
			echo "ERROR: The device doesn't have a EFI partition"
			exit 1
		fi
		if [ "$EFIORDER" == "" ]; then
			echo "ERROR: The device has the EFI partition in other side than $1 1"
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

	DEVICES=$(find /dev/disk/by-id/ | sed 's/^\/dev\/disk\/by-id\///') # 3.0_high_speed_000000123AFF-0:0 ...

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
		*) clear; exit 0;;
	esac
}

function rootpartmenu {
	#Menu para seleccionar la particion de raiz de arch
	VERIFY=""
	TYPE=""
	COUNT=0
	COUNTMOUNT=0
	ISMOUNTED=0
	ROOTPARTS=()

	EFIPART=$(fdisk -l "$DISK" | sed -ne /EFI/p | cut -d " " -f1)

	if [[ $DISK =~ sd[[:alpha:]] ]]; then
		VERIFY=$(find "$DISK"* | sed '/[[:alpha:]]$/d')
	elif [[ $DISK =~ mmcblk[[:digit:]] ]]; then
		VERIFY=$(find "$DISK"* | sed '/k[[:digit:]]$/d')
	elif [[ $DISK =~ nvme[[:alpha:]] ]]; then
		VERIFY=$(find "$DISK"* | sed '/e[[:digit:]]$/d')
	fi

	for PART in $VERIFY; do

	if [ "$PART" != "$EFIPART" ]; then

		ISMOUNTED=$(lsblk "$PART" | sed -ne '/\//p')
		if [ "$ISMOUNTED" != "" ]; then
			COUNTMOUNT=$(( COUNTMOUNT + 1 ))
		else
			ROOTPARTS+=("$PART" "$TYPE")
		fi
		COUNT=$((COUNT + 1))

	fi

	done

	if [ "$COUNTMOUNT" -eq $COUNT ]; then
		clear
		echo "ERROR: All the partitions of the device are mounted in your system, please unmount the desired partition"
		exit 1
	fi

	dialog --clear --backtitle "036 Creative Studios" --title "Select a root partition" \
		--menu "Please select a partition \n" 15 50 4 "${ROOTPARTS[@]}" 2>"${ROOTPARTMENUTEMP}"

	CHOICE=$(<"${ROOTPARTMENUTEMP}")
	case $CHOICE in
		"$CHOICE") ROOTPART="$CHOICE"; swapmenu "$CHOICE" ;;
		*) clear; exit 0; ;;
	esac
}

function swapmenu() {

	if [ "$1" == "" ]; then
		clear
		exit 0
	fi

	if [ $DISKENVIRONMENT == "HDD" ]; then

		VERIFY=""
		TYPE=""
		COUNT=0
		COUNTMOUNT=0
		ISMOUNTED=0
		SWAPPARTS=()

		if [[ $DISK =~ sd[[:alpha:]] ]]; then
			VERIFY=$(find "$DISK"* | sed '/[[:alpha:]]$/d')
		elif [[ $DISK =~ mmcblk[[:digit:]] ]]; then
			VERIFY=$(find "$DISK"* | sed '/k[[:digit:]]$/d')
		elif [[ $DISK =~ nvme[[:alpha:]] ]]; then
			VERIFY=$(find "$DISK"* | sed '/e[[:digit:]]$/d')
		fi

		for PART in $VERIFY; do

		if [ "$PART" != "$EFIPART" ]; then

			if [ "$PART" != "$ROOTPART" ]; then

				ISMOUNTED=$(lsblk "$PART" | sed -ne '/\//p')
				if [ "$ISMOUNTED" != "" ]; then
					COUNTMOUNT=$(( COUNTMOUNT + 1 ))
				else
					SWAPPARTS+=("$PART" "$TYPE")
				fi
					COUNT=$((COUNT + 1))
			fi

		fi

		done

		if [ "$COUNTMOUNT" -eq $COUNT ]; then
			clear
			echo "ERROR: All the partitions of the device are mounted in your system, please unmount the desired partition"
			exit 1
		fi

		dialog --clear --backtitle "036 Creative Studios" --title "Select a swap partition" \
			--menu "Please select a swap partition \n" 15 50 4 "${SWAPPARTS[@]}" 2>"${SWAPPARTMENUTEMP}"

		CHOICE=$(<"${SWAPPARTMENUTEMP}")
		case $CHOICE in
			"$CHOICE") SWAPPART="$CHOICE"; diskformat "$CHOICE" ;;
			*) clear; exit 0; ;;
		esac

	elif [ $DISKENVIRONMENT == "SSD" ]; then
		diskformat
	fi

}

function diskformat {

	if [ "$1" == "" ]; then
		clear
		exit 0
	fi

	if [ $DISKENVIRONMENT == "HDD" ]; then
		dialog --title "DANGER ZONE!!!" --backtitle "036 Creative Studios" \
			--yesno "This partitions will be format Continue? \n$EFIPART (EFI) \n$ROOTPART (ROOT) \n$SWAPPART (SWAP)" 8 60
	elif [ $DISKENVIRONMENT == "SSD" ]; then
		dialog --title "DANGER ZONE!!!" --backtitle "036 Creative Studios" \
			--yesno "This partitions will be format Continue? \n$EFIPART (EFI) \n$ROOTPART (ROOT)" 7 60
	fi

	clear
	response=$?

	if [ $response = 0 ]; then

		if [ $DISKENVIRONMENT == "HDD" ]; then

			echo -e "=============== FORMAT ROOT FILESYSTEM AND SWAP =============== \n" 

			mkfs.ext4 "$ROOTPART"
			mkswap "$SWAPPART"
			swapon "$SWAPPART"

			echo " "
			echo -e "=============== OK =============== \n" 
			read -r -p "Press Enter to continue..."
			clear
	
		elif [ $DISKENVIRONMENT == "SSD" ]; then

			echo -e "=============== FORMAT ROOT FILESYSTEM =============== \n" 

			mkfs.f2fs "$ROOTPART"

			echo " "
			echo -e "=============== OK =============== \n" 
			read -r -p "Press Enter to continue..."
			clear
	
		fi

		echo -e "=============== FORMAT EFI AND MOUNT =============== \n" 

		mkfs.fat -F32 "$EFIPART"
		mount "$ROOTPART" /mnt
		mkdir /mnt/efi
		mount "$EFIPART" /mnt/efi

		echo " "
		echo -e "=============== OK =============== \n" 
		read -r -p "Press Enter to continue..."
		clear

		pacstraper


	elif [ $response -eq 1 ] || [ $response -eq 255 ]; then
		clear
		exit 0
	else
		clear
		exit 0
	fi
	
}

function unmounter {
	clear

	if [ $DISKENVIRONMENT == "HDD" ]; then
		umount "$EFIPART"
		umount "$ROOTPART"
		swapoff "$SWAPPART"
	elif [ $DISKENVIRONMENT == "SSD" ]; then
		umount "$EFIPART"
		umount "$ROOTPART"
	fi
	echo "unmounted filesystems succesfully"
	exit 0
}

function pacstraper {

	echo -e "=============== PACSTRAP: INSTALL LINUX BASE AND CORE PACKAGES =============== \n" 
	
	pacstrap /mnt base linux linux-firmware nano sudo vi vim git wget \
	grub efibootmgr reflector os-prober rsync networkmanager neofetch \
	openssh arch-install-scripts screen unrar p7zip zsh

	genfstab -U /mnt >> /mnt/etc/fstab

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

	toggler
}

function toggler {

	cp "$0" /mnt/arch-setupper.sh
	arch-chroot /mnt ./arch-setupper.sh chroot $DISKENVIRONMENT

	if [ -f /mnt/arch-setupper.sh ]; then
        echo 'ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate.'
        echo 'Please umount, and restart this script'
		#unmount_filesystems
		echo "desmontar"
    fi
}

function configurator {
	clear
	echo "$DISKENVIRONMENT"
	read -r -p "dsadsa"

	echo -e "=============== ROOT PASSWORD FOR YOUR SYSTEM =============== \n" 

	passwd

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

	clear

	echo -e "=============== CONFIGURE GRUB =============== \n" 

	grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
	umount /mnt/efi

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

	clear

	echo -e "=============== START NETWORKMANAGER AND SSH SERVICES =============== \n" 

	systemctl enable NetworkManage
	systemctl enable sshd
	systemctl start NetworkManager
	systemctl start sshd
	sed -i 's/^#PermitRootLogin\s.*$/PermitRootLogin Yes/' \
	/etc/ssh/sshd_config &> /dev/null

	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

}



if [ "$1" == "chroot" ]; then
	DISKENVIRONMENT=$2
	corechroot
else
	corelive
fi

[ -f $DISKENVTEMP ] && rm $DISKENVTEMP 
[ -f $DISKMENUTEMP ] && rm $DISKMENUTEMP 
[ -f $ROOTPARTMENUTEMP ] && rm $ROOTPARTMENUTEMP
[ -f $SWAPPARTMENUTEMP ] && rm  $SWAPPARTMENUTEMP