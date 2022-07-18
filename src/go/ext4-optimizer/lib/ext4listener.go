package lib

import (
	"fmt"
	"os/exec"
	"strings"
)

func ext4listener(language int, menuable string, echoparts string) []string {

	EXTCOUNT, MOUNTCOUNT := 0,0
	ABSOLUTEPART, DIRTYDEVS := "", make([]string, 100)
	EXPARTS, PARTS := make([]string, 100),make([]string, 100)
	UMOUNTS := make([][]string, 100)

	SROOT, _ := exec.Command("bash", "-c", "df -h | sed -ne '/\\/$/p' | cut -d\" \" -f1").Output()
	SVERIFY, _ := exec.Command("bash", "-c", "find /dev/disk/by-id/ | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///").Output()

	ROOT := strings.Replace(string(SROOT), "\n", "", 1)
	VERIFY := strings.Split(string(SVERIFY), "\n")

	for _, DEVICE := range VERIFY {
		SDIRTDEV, _ := exec.Command("bash", "-c", fmt.Sprintf("readlink \"/dev/disk/by-id/%s\""), DEVICE).Output()
		DIRTYDEVS = append(DIRTYDEVS, strings.Split(string(SDIRTDEV), "\n")[0])
		
	}

	

	return make([]string, 2)
}
