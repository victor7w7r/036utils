package main

import (
	"036utils/lib"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strings"
	"time"

	"github.com/AlecAivazis/survey/v2"
	"github.com/briandowns/spinner"
	"github.com/fatih/color"
)

func core() {
	lib.Clear(); language(); lib.Cover(); verify(); toggler()
}

var LANGUAGE = 0

func printer(typeQuery string, position int) {

	DICTIONARY_ENG := [7]string{
		"Your Operating System is not macOS, exiting",
		"All dependencies is ok!",
		"EFI Folder is mounted, unmounting",
		"EFI Folder is not mounted, mounting",
		"Done!",
		"Sudo auth fails",
	}

	DICTIONARY_ESP := [7]string{
		"Tu sistema operativo no es macOS, saliendo",
		"¡Todo ok!",
		"La carpeta EFI esta montada, desmontando",
		"La carpeta EFI no esta montada, montando",
		"¡Listo!",
		"Autenticación con sudo falló",
	}

	green := color.New(color.FgGreen)
	cyan := color.New(color.FgCyan)
	red := color.New(color.FgRed)

	if LANGUAGE == 1 {
		switch {
		case typeQuery == "print":
			fmt.Println(DICTIONARY_ENG[position])
		case typeQuery == "info":
			green.Print("[+] ")
			fmt.Printf("INFO: %s", DICTIONARY_ENG[position])
		case typeQuery == "warn":
			cyan.Print("[*] ")
			fmt.Printf("WARNING: %s", DICTIONARY_ENG[position])
		case typeQuery == "error":
			red.Print("[!] ")
			fmt.Printf("ERROR: %s", DICTIONARY_ENG[position])
		}
	} else {
		switch {
		case typeQuery == "print":
			fmt.Println(DICTIONARY_ESP[position])
		case typeQuery == "info":
			green.Print("[+] ")
			fmt.Printf("INFO: %s", DICTIONARY_ESP[position])
		case typeQuery == "warn":
			cyan.Print("[*] ")
			fmt.Printf("WARNING: %s", DICTIONARY_ESP[position])
		case typeQuery == "error":
			red.Print("[!] ")
			fmt.Printf("ERROR: %s", DICTIONARY_ESP[position])
		}
	}
}

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
		printer("error", 0)
		fmt.Print("\n")
		os.Exit(1)
	}
	printer("print", 1)
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
		printer("print", 2)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			_ = outChck
			exec.Command("bash", "-c", fmt.Sprintf("sudo diskutil unmount %s",EFIPART)).Run()
			exec.Command("bash", "-c", "sudo rm -rf /Volumes/EFI").Run()
			lib.Clear()
			printer("print", 4)
		} else {
			lib.Clear()
			printer("print", 6)
			fmt.Println("")
			os.Exit(1)
		}
	} else {
		printer("print", 3)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			_ = outChck
			exec.Command("bash", "-c", "sudo mkdir /Volumes/EFI").Run()
			exec.Command("bash", "-c", fmt.Sprintf("sudo mount -t msdos /dev/%s /Volumes/EFI", EFIPART)).Run()
			exec.Command("bash", "-c", "open /Volumes/EFI").Run()
			lib.Clear()
			printer("print", 4)
		} else {
			lib.Clear()
			printer("print", 6)
			fmt.Println("")
			os.Exit(1)
		}
	}
}

func main() { core() }
