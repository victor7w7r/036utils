package lib

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type OptExtParams struct {
	menuable, echoparts string
}

func Ext4listener(language int, opt OptExtParams) []string {

	EXTCOUNT, MOUNTCOUNT := 0, 0
	ABSOLUTEPARTS, DIRTYDEVS := "", make([]string, 20)
	EXTPARTS, PARTS := make([]string, 40),make([]string, 40)
	UMOUNTS := make([]string, 20)

	SROOT, _ := exec.Command("bash", "-c", "df -h | sed -ne '/\\/$/p' | cut -d\" \" -f1").Output()
	ROOT := strings.Replace(string(SROOT), "\n", "", 1)

	SVERIFY, _ := exec.Command("bash", "-c", "find /dev/disk/by-id/ | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'").Output()
	VERIFY := strings.Split(string(SVERIFY), "\n")

	for _, DEVICE := range VERIFY {
		SDIRTDEV, _ := exec.Command("bash", "-c", fmt.Sprintf("readlink \"/dev/disk/by-id/%s\"",DEVICE)).Output()
		DIRTYDEVS = append(DIRTYDEVS, strings.Split(string(SDIRTDEV), "\n")[0])
	}

	DIRTYDEVS = RemoveWhere(DIRTYDEVS,"")

	for _, DEV  := range DIRTYDEVS {
		SABSPARTS, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'", DEV)).Output()
		ABSOLUTEPARTS = strings.Replace(string(SABSPARTS), "\n", "", 1)
		if ABSOLUTEPARTS != "" {
			if ABSOLUTEPARTS != ROOT {
				SPARTS, _ := exec.Command("bash", "-c", fmt.Sprintf("echo %s | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'", DEV)).Output()
				PARTS = append(PARTS, strings.Split(string(SPARTS), "\n")[0])
			}
		}
	}

	PARTS = RemoveWhere(PARTS,"")

	for _, PART := range PARTS {
		STYPE, _ := exec.Command("bash", "-c", fmt.Sprintf("lsblk -f /dev/%s | sed -ne '2p' | cut -d ' ' -f2", PART)).Output()
		TYPE := strings.Replace(string(STYPE), "\n", "", 1)
		if TYPE == "ext4" {
			EXTCOUNT++
			EXTPARTS = append(EXTPARTS, PART)
		}
	}

	EXTPARTS = RemoveWhere(EXTPARTS,"")

	if EXTCOUNT == 0 {
		Clear(); Printer("error", 5, language)
		if opt.menuable == "menu" {
			fmt.Println(Reader(4, language))
			fmt.Scanln()
		} else {
			os.Exit(1)
		}
	}

	for _, PARTITIONSDEF := range EXTPARTS {
		SMOUNTED, _ := exec.Command("bash", "-c", fmt.Sprintf("lsblk /dev/%s | sed -ne '/\\//p'", PARTITIONSDEF)).Output()
		MOUNTED := strings.Replace(string(SMOUNTED), "\n", "", 1)
		if MOUNTED != "" {
			MOUNTCOUNT++
		} else {
			UMOUNTS = append(UMOUNTS, fmt.Sprintf("/dev/%s", PARTITIONSDEF))
		}
	}

	if MOUNTCOUNT == EXTCOUNT {
		Clear(); Printer("error", 6, language)
		if opt.menuable == "menu" {
			fmt.Println(Reader(4, language))
			fmt.Scanln()
		} else {
			os.Exit(1)
		}
	}

	return UMOUNTS
}
