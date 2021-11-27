#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
	echo "ERROR: You need to be root."
	exit 1
fi

rm /tmp/localestemp.sh* 2> /dev/null
rm /tmp/hosttemp.sh* 2> /dev/null
	
LOCALESTEMP=/tmp/localestemp.sh.$$
HOSTTEMP=/tmp/hosttemp.sh.$$

function cleanup { rm $LOCALESTEMP; $HOSTTEMP; exit; }

trap cleanup; SIGHUP SIGINT SIGTERM

function core { clear; cover; sleep 1s; verify; packages; hostnamer; localer; cockpit; graphical; remote; kvm; ohmyzsh; software; finisher; }

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

function whichverify() {
	stat=$(which "$1" 2>&1)
	if [[ "$stat" =~ which:* ]]; then 
		return 1
	else
		return 0
	fi
}

function verify {

    ARCH=$(uname -m)
    OPERATING=$(uname -o)
	ORACLE=$(cat /etc/os-release | head -n 1 | cut -d "=" -f2)
	SELECTOR=""

	if [ "$OPERATING" != "GNU/Linux" ]; then
		clear
		echo 'ERROR: Your Operating System is not GNU/Linux, exiting'
		exit 1
	fi
	
	if [ -d /sys/firmware/efi ]; then
		echo "ready" &> /dev/null
	else
		clear
		echo "ERROR: This scripts only works in UEFI/EFI systems, consider change your PC or check your BIOS"
		exit 1
	fi


    if [[ "$ORACLE" =~ \"Oracle.* ]]; then
		echo "ready" &> /dev/null
	else
     	echo "ERROR: This script is only intended to run on Oracle Linux"
        exit 1
    fi

	
    if [ "$ARCH" != "x86_64" ]; then
        echo "ERROR: This script is only intended to run on x86_64 PCs."
        exit 1
    fi

    SELECTOR="dnf"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		clear
		echo "ERROR: DNF is not available in this system, this system isn't Oracle Linux?"
		exit 1
	fi

    PING=$(ping -c 1 8.8.8.8 2>&1) 

    if [[ "$PING" =~ unreachable* ]]; then
		clear
		echo "ERROR: This PC doesn't have internet connection, please check"
		exit 1
	fi

    echo "Updating Oracle Linux Repositories... Please Wait"
    dnf update --assumeyes &> /dev/null

	SELECTOR="dialog"
	whichverify "$SELECTOR"
	local res=$?

	if [ $res -eq 1 ]; then
		echo "dialog is not available in this system, installing"
		dnf install dialog --assumeyes &> /dev/null
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

function packages {
	clear

	echo -e "=============== CORE PACKAGES =============== \n" 

	dnf -y install net-tools wget nano zsh

	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

}

function hostnamer {

	clear
	dialog --title "Hostname" \
    --backtitle "036 Creative Studios" \
    --inputbox "Please write your hostname (ex: A036-arch)" 8 80 2>"$HOSTTEMP"

    RESPONSE=$?
    DATA=$(<$HOSTTEMP)

    case $RESPONSE in
    0) 
		hostnamectl set-hostname "${DATA}" 
		return;;
    1) 
        clear; exit 0  
        return;;
    255) 
        clear; exit 0
        return;;
    esac
	
}

function localer {

	clear
	dialog --msgbox "America/Guayaquil is the timezone by default, if you want to change, here is the command\n\n \
		timedatectl set-timezone REGION/CITY" 9 50

	timedatectl set-timezone America/Guayaquil

	dialog --clear --backtitle "036 Creative Studios" \
		--title "Locale" \
		--menu "Choose your keyboard layout" 12 50 4 \
		Spanish "es" \
		English "us" 2>"${LOCALESTEMP}"

		menuitem=$(<"${LOCALESTEMP}")

		case $menuitem in
			Spanish) 
				clear
				localectl set-keymap es
				return;;
			English) 
				clear
				localectl set-keymap us
				return;;
			*) clear; exit 0;;
		esac
}

function cockpit {

	clear
	echo -e "=============== COCKPIT SERVICE (IP:9090) =============== \n" 
	
	systemctl enable --now cockpit.socket
	systemctl start cockpit.socket

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

}

function graphical {

	LISTHOME=""

	dialog --title "Graphical" --backtitle "036 Creative Studios" \
		--yesno "Install XFCE as Desktop Environment?" 8 60

	response=$?
	
	if [ $response = 0 ]; then

		clear
		echo -e "=============== EPEL & XFCE =============== \n" 
		
		dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm --assumeyes 
		dnf update --assumeyes 
		dnf groupinstall "base-x" --assumeyes 
		dnf groupinstall "xfce" --assumeyes 
		dnf install xfce4-whiskermenu-plugin --assumeyes 
		touch .xinitrc
		echo "xfce4-session" > .xinitrc

		LISTHOME=$(ls /home)

		for HOME in $LISTHOME; do
			touch /home/"$HOME"/.xinitrc
			echo "xfce4-session" > /home/"$HOME"/.xinitrc
			chown "$HOME" /home/"$HOME"/.xinitrc
		done

		echo " "
		echo -e "=============== OK =============== \n" 
		read -r -p "Press Enter to continue..."

	else

		clear
		echo -e "=============== EPEL =============== \n" 
		
		dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm --assumeyes 
	
		echo " "
		echo -e "=============== OK =============== \n" 
		read -r -p "Press Enter to continue..."
		return
	fi

}

function drivers {

	clear

	dialog --title "VMware" --backtitle "036 Creative Studios" \
		--yesno "This is a VMware Guest" 8 60

	clear
	response=$?

	if [ $response = 0 ]; then

	clear
	dnf install open-vm-tools open-vm-tools-desktop --assumeyes 

	elif [ $response -eq 1 ]; then
		clear
		return
	else
		clear
		return
	fi

}

function remote {

	clear

	dialog --title "SSH" --backtitle "036 Creative Studios" \
		--yesno "Permit Root Login?" 8 60

	response=$?

	if [ $response = 0 ]; then

		clear

		echo -e "=============== SSH: PERMIT ROOT LOGIN ===============  \n" 

		sed -i 's/^#PermitRootLogin\s.*$/PermitRootLogin Yes/' \
			/etc/ssh/sshd_config &> /dev/null
		systemctl enable sshd
		systemctl restart sshd

		echo " "
		echo -e "=============== OK =============== \n" 
		read -r -p "Press Enter to continue..."

	fi

	clear

	echo -e "=============== XRDP ===============  \n" 

	LISTHOME=""

	dnf install xrdp --assumeyes 

	LISTHOME=$(ls /home)

	for HOME in $LISTHOME; do
		touch /home/"$HOME"/.Xclients
		echo "xfce4-session" > /home/"$HOME"/.Xclients
		chmod a+x /home/"$HOME"/.Xclients
		chown "$HOME" /home/"$HOME"/.Xclients
	done

	systemctl enable xrdp
	systemctl enable xrdp-sesman
	systemctl start xrdp
	systemctl start xrdp-sesman
	firewall-cmd --permanent --add-port=3389/tcp 
	firewall-cmd --reload
	chcon --type=bin_t /usr/sbin/xrdp
	chcon --type=bin_t /usr/sbin/xrdp-sesman

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

}

function kvm {

	dialog --title "KVM" --backtitle "036 Creative Studios" \
		--yesno "Install Oracle Linux KVM Suite?" 8 60

	response=$?

	if [ $response = 0 ]; then

	echo -e "=============== KVM ===============  \n" 

	dnf config-manager --enable ol8_appstream ol8_kvm_appstream ol8_developer_EPEL
	dnf module install virt --assumeyes 
	dnf install virt-install virt-viewer virt-manager edk2-ovmf virt-v2v cockpit-machines --assumeyes
	virt-host-validate qemu
	systemctl enable libvirtd
	systemctl start libvirtd
	dnf install dnf-plugins-core --assumeyes 
	dnf config-manager --add-repo https://www.kraxel.org/repos/firmware.repo
	dnf install edk2.git-ovmf-x64 --assumeyes 

	echo "nvram = [" >> /etc/libvirt/qemu.conf
	echo "	\"/usr/edk.git/OVMF_CODE.fd:/usr/edk.git/OVMF_VARS.fd\"" >> /etc/libvirt/qemu.conf
	echo "]" >> /etc/libvirt/qemu.conf

	systemctl restart libvirtd
	systemctl enable serial-getty@ttyS0.service
	systemctl start serial-getty@ttyS0.service

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

	elif [ $response -eq 1 ]; then
		clear
		return
	else
		clear
		return
	fi

}

function ohmyzsh {

	clear
	echo -e "=============== OMZ =============== \n" 

	LISTHOME=$(ls /home)

	for HOME in $LISTHOME; do

		touch /home/"$HOME"/omz.sh
		{
			sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
			sed -i -e 's/ZSH_THEME=.*/ZSH_THEME=\"pmcgee\"/' .zshrc
			sed -i -e '/^source $ZSH.*/i ZSH_DISABLE_COMPFIX=true' .zshrc
			sudo ln -s "$HOME"/.zshrc /root/.zshrc
			sudo ln -s "$HOME"/.oh-my-zsh /root/.oh-my-zsh
			git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
			git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
			sed -i -e 's/plugins=(.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' .zshrc
		} > /home/"$HOME"/omz.sh

		chown "$HOME" /home/"$HOME"/omz.sh

	done

	echo "We create a script called omz.sh in your home directory, after reboot, use chmod +x at omz.sh"

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."

}

function software {

	dialog --title "More Sofware!!" --backtitle "036 Creative Studios" \
		--yesno "This script has a little pack of software, Do you like it?\n \
			-> baobab \n \
			-> ntfs-3g \n \
			-> gparted \n \
			-> nautilus \n \
			-> gedit \n \
			-> tar \n \
			-> yum-utils \n \
			-> numix-gtk-theme \n \
			-> numix-icon-theme \n \
			-> numix-icon-theme-circle" 26 65
	clear
	response=$?

	if [ $response = 0 ]; then
	
	clear
	echo -e "=============== SOFTWARE =============== \n" 

	dnf install -y baobab ntfs-3g gparted exfatprogs nautilus gedit tar yum-utils --assumeyes

	dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --assumeyes
	dnf install numix-gtk-theme --assumeyes
	dnf install gnome-icon-theme --assumeyes
	dnf install numix-icon-theme --assumeyes
	dnf install numix-icon-theme-circle --assumeyes
	dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm --assumeyes

	echo " "
	echo -e "=============== OK =============== \n" 
	read -r -p "Press Enter to continue..."


	elif [ $response -eq 1 ] || [ $response -eq 255 ]; then
		clear
		return
	else
		clear
		return
	fi

}

function finisher {

	clear
	dialog --msgbox 'READY!!!, Your Server is succesfully configured, if you have errors, please report at 036bootstrap in GitHub' 7 50
	clear
	echo "Please reboot yout server to make changes"
	exit 0

}

core

[ -f $LOCALESTEMP ] && rm $LOCALESTEMP
[ -f $HOSTTEMP ] && rm $HOSTTEMP