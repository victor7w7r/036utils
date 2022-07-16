package main

import (
	"efitoggler/lib"
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
	lib.Clear(); language(); lib.Cover(); verify(); toggler()
}

var LANGUAGE = 0

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
	if platform != "darwin" {
		lib.Clear()
		lib.Printer("error", 0, LANGUAGE)
		fmt.Print("\n")
		os.Exit(1)
	}
	lib.Printer("print", 1, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()
}

func toggler() {

	sout1, err1 := exec.Command("bash", "-c",
		"diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p'").Output()
	if err1 != nil {fmt.Println(err1); os.Exit(1)}

	sout2, err2 := exec.Command("bash", "-c",
		"EFIPART=$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p') MOUNTROOT=$(df -h | sed -ne \"/$EFIPART/p\"); echo $MOUNTROOT").Output()
	if err2 != nil {fmt.Println(err2); os.Exit(1)}

	EFIPART, EFI := string(sout1), string(sout2)

	EFIPART = strings.TrimSuffix(EFIPART, "\n")
	EFI = strings.TrimSuffix(EFI, "\n")

	if EFI != "" {
		lib.Printer("print", 2, LANGUAGE)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			_ = outChck
			exec.Command("bash", "-c", fmt.Sprintf("sudo diskutil unmount %s",EFIPART)).Run()
			exec.Command("bash", "-c", "sudo rm -rf /Volumes/EFI").Run()
			lib.Clear()
			lib.Printer("print", 4, LANGUAGE)
		} else {
			lib.Clear()
			lib.Printer("print", 6, LANGUAGE)
			fmt.Println("")
			os.Exit(1)
		}
	} else {
		lib.Printer("print", 3, LANGUAGE)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			_ = outChck
			exec.Command("bash", "-c", "sudo mkdir /Volumes/EFI").Run()
			exec.Command("bash", "-c", fmt.Sprintf("sudo mount -t msdos /dev/%s /Volumes/EFI", EFIPART)).Run()
			exec.Command("bash", "-c", "open /Volumes/EFI").Run()
			lib.Clear()
			lib.Printer("print", 4, LANGUAGE)
		} else {
			lib.Clear()
			lib.Printer("print", 6, LANGUAGE)
			fmt.Println("")
			os.Exit(1)
		}
	}
}

func main() { core() }
