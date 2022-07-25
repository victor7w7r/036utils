package main

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"time"
	"usb-manager/lib"

	"github.com/AlecAivazis/survey/v2"
	"github.com/briandowns/spinner"
)

func core() {
	lib.Clear(); language(); lib.Cover()
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
		fmt.Println("");	 os.Exit(1)
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



	lib.Printer("print", 4, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear(); menu()
}

func menu() {

}