package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"runtime"
	"strings"
	"time"
	"usb-manager/lib"

	"github.com/AlecAivazis/survey/v2"
	"github.com/briandowns/spinner"
)

func core() {
	lib.Clear(); language(); lib.Cover(); verify()
}

var LANGUAGE int = 0

func language() {

	option := 0
	promptLang := &survey.Select{
		Message: "Bienvenido / Welcome \n Choose your language / Selecciona tu idioma",
		Options: []string{"English", "Espanol"},
	}
	survey.AskOne(promptLang, &option)

	if option == 0 {
		LANGUAGE = 1
	} else {
		LANGUAGE = 2
	}
}

func usbverify() {
	SVERIFY,_ := exec.Command("bash", "-c", "find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'").Output()
	if string(SVERIFY) == "" {
		lib.Clear()
		lib.Printer("error", 6, LANGUAGE)
		fmt.Println(""); os.Exit(1)
	}
}

func verify() {
	platform := runtime.GOOS
	if platform != "linux" {
		lib.Clear(); lib.Printer("error", 0, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}
	if !lib.Commandverify("whiptail") {
		lib.Clear(); lib.Printer("error", 3, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}
	if !lib.Commandverify("udisksctl") {
		lib.Clear(); lib.Printer("error", 2, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}

	SSYSUD, _  := exec.Command("bash", "-c","systemctl is-active udisks2").Output()
	if(string(SSYSUD) == "inactive") {
		lib.Clear(); lib.Printer("error", 4, LANGUAGE)
		fmt.Println(); os.Exit(1)
	}

	usbverify()
	lib.Printer("print", 5, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear(); menu()
}

func menu() {
	option := 0
	promptMenu := &survey.Select{
		Message: lib.Reader(0, LANGUAGE),
		Options: []string{
			lib.Reader(1, LANGUAGE), lib.Reader(2, LANGUAGE),
			lib.Reader(3, LANGUAGE), lib.Reader(4, LANGUAGE),
		},
	}
	survey.AskOne(promptMenu, &option)

	switch option {
		case 0:
			lib.Clear(); usblistener("mount")
		case 1:
			lib.Clear(); usblistener("unmount")
		case 2:
			lib.Clear(); usblistener("off")
		case 3:
			lib.Clear(); os.Exit(0)
		default:
			lib.Clear(); os.Exit(0)
	}
}

func usblistener(selector string) {

	COUNT := 0
	PARTS, USB := make([]string, 20), make([]string, 20)
	BLOCK, FLAGS := make([]string, 20), make([]int, 0,20)
	MOUNTS, UNMOUNTS := make([]string, 20), make([]string, 20)
	DIRTYDEVS, ARGSPOWEROFF := make([]string, 20), make([]string, 20)
	MOUNTCOUNT, UNMOUNTCOUNT := 0,0;
	FLAGSCOUNT, ARGS := 0, make([]string, 20)
	lib.Clear(); usbverify()

	SUSB, _ := exec.Command("bash", "-c", "find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'").Output()
	USB = strings.Split(string(SUSB), "\n")

	for _, DEVICE := range USB {
		SDIRTDEV, _ := exec.Command("bash", "-c", fmt.Sprintf("readlink \"/dev/disk/by-id/%s\"",DEVICE)).Output()
		DIRTYDEVS = append(DIRTYDEVS, strings.Split(string(SDIRTDEV), "\n")[0])
	}

	DIRTYDEVS = lib.RemoveWhere(DIRTYDEVS,"")

	for _, DEV  := range DIRTYDEVS {
		SABSPARTS, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'", DEV)).Output()
		ABSOLUTEPARTS := strings.Replace(string(SABSPARTS), "\n", "", 1)
		if ABSOLUTEPARTS != "" {
			SPARTS, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'", DEV)).Output()
			PARTS = append(PARTS, strings.Split(string(SPARTS), "\n")[0])
			COUNT++
		} else {
			SBLOCK, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | sed 's/^\\.\\.\\/\\.\\.\\///'", DEV)).Output()
			BLOCK = append(BLOCK, strings.Split(string(SBLOCK), "\n")[0])
			FLAGS = append(FLAGS, COUNT)
		}
	}

	PARTS = lib.RemoveWhere(PARTS,"")
	BLOCK = lib.RemoveWhere(BLOCK,"")

	for _, PARTITIONS  := range PARTS {
		SMOUNTED, _ := exec.Command("bash", "-c", fmt.Sprintf("lsblk /dev/%s | sed -ne '/\\//p'", PARTITIONS)).Output()
		MOUNTED := strings.Replace(string(SMOUNTED), "\n", "", 1)
		if MOUNTED != "" {
			UNMOUNTCOUNT++
			MOUNTS = append(MOUNTS, PARTITIONS)
			} else {
			MOUNTCOUNT++
			UNMOUNTS = append(UNMOUNTS, PARTITIONS)
		}
	}

	MOUNTS = lib.RemoveWhere(MOUNTS,"")
	UNMOUNTS = lib.RemoveWhere(UNMOUNTS,"")

	if(selector == "mount") {
		if(UNMOUNTCOUNT == COUNT) {
			lib.Clear(); lib.Printer("error", 7, LANGUAGE)
			fmt.Println("")
			fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}

		COUNT = 0

		for _, PART  := range UNMOUNTS {
			DEVICE := fmt.Sprintf("/dev/%s", PART)
			TEMP := FLAGS[FLAGSCOUNT]
			if(COUNT == TEMP){
				FLAGSCOUNT++
			}
			ARGS = append(ARGS, DEVICE)
			COUNT++
		}

		ARGS = lib.RemoveWhere(ARGS,"")
		ARGS = append(ARGS, lib.Reader(16, LANGUAGE))

		option := 0
		selectionMenu := &survey.Select{
			Message: lib.Reader(6, LANGUAGE),
			Options: ARGS,
		}
		survey.AskOne(selectionMenu, &option)

		if(ARGS[option] == lib.Reader(16, LANGUAGE)) {
			lib.Clear(); menu()
		} else {
			lib.Clear(); mountAction(ARGS[option])
		}

	} else if(selector == "unmount") {
		if(MOUNTCOUNT == COUNT) {
			lib.Clear(); lib.Printer("error", 10, LANGUAGE)
			fmt.Println("")
			fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}

		COUNT = 0

		for _, PART  := range MOUNTS {
			DEVICE := fmt.Sprintf("/dev/%s", PART)
			TEMP := FLAGS[FLAGSCOUNT]
			if(COUNT == TEMP){
				FLAGSCOUNT++
			}
			ARGS = append(ARGS, DEVICE)
			COUNT++
		}

		ARGS = lib.RemoveWhere(ARGS,"")
		ARGS = append(ARGS, lib.Reader(16, LANGUAGE))

		option := 0
		selectionMenu := &survey.Select{
			Message: lib.Reader(9, LANGUAGE),
			Options: ARGS,
		}
		survey.AskOne(selectionMenu, &option)

		if(ARGS[option] == lib.Reader(16, LANGUAGE)) {
			lib.Clear(); menu()
		} else {
			lib.Clear(); unMountAction(ARGS[option])
		}
	} else if(selector == "off") {
		if(MOUNTCOUNT == COUNT) {
			lib.Clear(); lib.Printer("error", 10, LANGUAGE)
			fmt.Println("")
			fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}

		COUNT = 0

		for _, PART := range BLOCK {
			DEVICE := fmt.Sprintf("/dev/%s", PART)
			ARGSPOWEROFF = append(ARGSPOWEROFF, DEVICE)
			COUNT++
		}

		ARGSPOWEROFF = lib.RemoveWhere(ARGSPOWEROFF,"")
		ARGSPOWEROFF = append(ARGSPOWEROFF, lib.Reader(16, LANGUAGE))

		option := 0
		selectionMenu := &survey.Select{
			Message: lib.Reader(11, LANGUAGE),
			Options: ARGSPOWEROFF,
		}
		survey.AskOne(selectionMenu, &option)

		if(ARGS[option] == lib.Reader(16, LANGUAGE)) {
			lib.Clear(); menu()
		} else {
			lib.Clear(); powerOffAction(ARGSPOWEROFF[option])
		}
	}
}

func mountAction(part string) {
	lib.Clear()
	if(part == "") {
		return;
	}
	SMOUNTACTION, EMOUNTACTION := exec.Command("bash", "-c", fmt.Sprintf("udisksctl mount -b %s", part)).Output()
	if(EMOUNTACTION == nil) {
		dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title '%s' --msgbox '%s %s' 7 60",lib.Reader(8, LANGUAGE),lib.Reader(8, LANGUAGE), string(SMOUNTACTION)))
		dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
		_ = dialog.Run()
		lib.Clear(); menu()
	} else {
		reg1Bool, _ := regexp.MatchString("NotAuthorized*", string(SMOUNTACTION))
		reg2Bool, _ := regexp.MatchString("NotAuthorizedDismissed*", string(SMOUNTACTION))
		reg3Bool, _ := regexp.MatchString("AlreadyMounted*", string(SMOUNTACTION))
		if(reg1Bool) {
			lib.Clear(); lib.Printer("error", 8, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		} else if(reg2Bool) {
			lib.Clear(); lib.Printer("error", 8, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		} else if(reg3Bool) {
			lib.Clear(); lib.Printer("error", 9, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		}
	}
}

func unMountAction(part string) {
	lib.Clear()
	if(part == "") {
		return;
	}
	SMOUNTACTION, EMOUNTACTION := exec.Command("bash", "-c", fmt.Sprintf("udisksctl unmount -b %s", part)).Output()
	if(EMOUNTACTION == nil) {
		dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title '%s' --msgbox '%s %s' 7 60",lib.Reader(8, LANGUAGE),lib.Reader(8, LANGUAGE), string(SMOUNTACTION)))
		dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
		_ = dialog.Run()
		lib.Clear(); menu()
	} else {
		reg1Bool, _ := regexp.MatchString("NotAuthorized*", string(SMOUNTACTION))
		reg2Bool, _ := regexp.MatchString("NotAuthorizedDismissed*", string(SMOUNTACTION))
		reg3Bool, _ := regexp.MatchString("AlreadyMounted*", string(SMOUNTACTION))
		if(reg1Bool) {
			lib.Clear(); lib.Printer("error", 8, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		} else if(reg2Bool) {
			lib.Clear(); lib.Printer("error", 8, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		} else if(reg3Bool) {
			lib.Clear(); lib.Printer("error", 9, LANGUAGE)
			fmt.Println(); fmt.Println(lib.Reader(5, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
		}
	}
}

func powerOffAction(part string) {
	lib.Clear()
	if(part == "") {
		return;
	}

	SBLOCKTEMP, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | cut -d \"/\" -f3",part)).Output()
	BLOCKTEMP := strings.Replace(string(SBLOCKTEMP), "\n", "", 1)

	SPARTITIONS, _ := exec.Command("bash", "-c", fmt.Sprintf("find /dev -name \"%s[[:digit:]]\" | sort -n | sed 's/^\\/dev\\///' ",BLOCKTEMP)).Output()
	PARTITIONS := strings.Split(string(SPARTITIONS), "\n")

	PARTITIONS = lib.RemoveWhere(PARTITIONS, "")

	for _, PARTITION  := range PARTITIONS {
		_, EUNMOUNT := exec.Command("bash", "-c", fmt.Sprintf("udisksctl unmount -b /dev/%s &> /dev/null ",PARTITION)).Output()
		if(EUNMOUNT == nil){
			s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
			s.Start(); time.Sleep(time.Second); s.Stop()
		} else {
			if(LANGUAGE == 1) {
				dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'ERROR' --msgbox 'FAIL: Error unmounting /dev/%s please check or check if you have the right permissions' 7 60",PARTITION))
				dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
				_ = dialog.Run()
				lib.Clear(); menu()
				return
			} else {
				dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'ERROR' --msgbox 'ERROR: Hubo un error desmontando /dev/%s por favor revisar o mira si tienes permisos 7 60",PARTITION))
				dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
				_ = dialog.Run()
				lib.Clear(); menu()
				return
			}
		}
	}

	SMODEL, _ := exec.Command("bash", "-c", "cat /sys/class/block/%s/device/model",BLOCKTEMP).Output()
	MODEL := strings.Replace(string(SMODEL), "\n", "", 1)

	_, EPOWEROFF := exec.Command("bash", "-c", fmt.Sprintf("udisksctl power-off -b %s ",part)).Output()
	if(EPOWEROFF == nil) {
		if(LANGUAGE == 1) {
			dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'SUCCESS' --msgbox 'SUCCESS: Your device %s was succesfully power-off' 7 60",MODEL))
			dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
			_ = dialog.Run()
			lib.Clear(); menu()
			return
		} else {
			dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'LISTO' --msgbox 'LISTO: Tu dispositivo %s se ha apagado exitosamente' 7 60",MODEL))
			dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
			_ = dialog.Run()
			lib.Clear(); menu()
			return
		}
	} else {
		if(LANGUAGE == 1) {
			dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'FAIL' --msgbox 'FAIL:  Power-off is not available on this device, please check or check if you have permissions' 7 60"))
			dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
			_ = dialog.Run()
			lib.Clear(); menu()
			return
		} else {
			dialog := exec.Command("bash", "-c",fmt.Sprintf("whiptail --title 'ERROR: no está disponible el apagar este dispositivo, por favor revisar o mira si tienes permisos' 7 60"))
			dialog.Stdin = os.Stdin; dialog.Stdout = os.Stdout; dialog.Stderr = os.Stderr
			_ = dialog.Run()
			lib.Clear(); menu()
			return
		}
	}


}

func main() { core() }