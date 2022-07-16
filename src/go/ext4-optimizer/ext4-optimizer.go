package main

import (
	"ext4-optimizer/lib"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strings"
	"time"

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

func verify() {
	platform := runtime.GOOS
	if platform != "linux" {
		lib.Clear(); lib.Printer("error", 0, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}
	if !lib.Commandverify("e4defrag") {
		lib.Clear(); lib.Printer("error", 2, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}
	if !lib.Commandverify("fsck.ext4") {
		lib.Clear(); lib.Printer("error", 3, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}

	lib.Printer("print", 4, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear()
}

func ext4listener(menuable string, echoparts string) []string {

	COUNT, EXTCOUNT, MOUNTCOUNT := 0,0,0
	ABSOLUTEPART, DIRTYDEVS := "", make([]string, 100)
	EXPARTS, PARTS := make([]string, 100),make([]string, 100)
	UMOUNTS := make([][]string, 100)

	SROOT, _ := exec.Command("bash", "-c", "df -h | sed -ne '/\\/$/p' | cut -d\" \" -f1").Output()
	SVERIFY, _ := exec.Command("bash", "-c", "find /dev/disk/by-id/ | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///").Output()

	ROOT := strings.Split(string(SROOT), "\n")
	VERIFY := strings.Split(string(SVERIFY), "\n")

	for _, DEVICE := range VERIFY {
		DIRTYDEVS
	}

	return make([]string, 2)
}


func main() { core() }