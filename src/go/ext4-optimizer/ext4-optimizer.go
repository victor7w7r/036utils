package main

import (
	"ext4-optimizer/lib"
	"fmt"
	"os"
	"os/exec"
	"runtime"
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

	lib.Ext4listener(LANGUAGE,lib.OptExtParams{})

	lib.Printer("print", 4, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear(); menu()
}

func menu() {
	option := 0
	promptMenu := &survey.Select{
		Message: lib.Reader(0, LANGUAGE),
		Options: []string{lib.Reader(1, LANGUAGE), lib.Reader(2, LANGUAGE)},
	}
	survey.AskOne(promptMenu, &option)

	if option == 0 {
		lib.Clear(); defragmenu()
	} else {
		lib.Clear(); os.Exit(0)
	}
}

func defragmenu() {

	option := 0
	optionable := lib.Ext4listener(LANGUAGE, lib.OptExtParams{Menuable: "menu", Echoparts: "print"})
	optionable = append(optionable, lib.Reader(6, LANGUAGE))

	promptDefrag := &survey.Select{
		Message: lib.Reader(0, LANGUAGE),
		Options: optionable,
	}
	survey.AskOne(promptDefrag, &option)

	if optionable[option] == lib.Reader(6, LANGUAGE) {
		lib.Clear(); menu()
	} else {
		defragaction(optionable[option])
	}
}

func defragaction(part string) {
	lib.Clear()

	if part == "" { return }
	lib.Printer("print", 7, LANGUAGE)
	fmt.Print("\n")

	_, ERRSUDO := exec.Command("bash", "-c", "sudo cat < /dev/null").Output()
	if(ERRSUDO == nil) {

		ORRREP,ERRREP  := exec.Command("bash", "-c", fmt.Sprintf("sudo fsck.ext4 -y -f -v %s", part)).Output()
		fmt.Printf(string(ORRREP))
		if(ERRREP == nil) {
			lib.Printer("print", 9, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear()
		} else {
			lib.Printer("print", 8, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}

		lib.Printer("print", 10, LANGUAGE)

		OPREP,EPREP  := exec.Command("bash", "-c", fmt.Sprintf("sudo fsck.ext4 -y -f -v -D %s", part)).Output()
		fmt.Printf(string(OPREP))
		if(EPREP == nil) {
			lib.Printer("print", 9, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear()
		} else {
			lib.Printer("print", 8, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}

		exec.Command("bash", "-c", "mkdir /tmp/optimize 2> /dev/null")
		exec.Command("bash", "-c", fmt.Sprintf("sudo mount %s /tmp/optimize",part))

		lib.Printer("print", 11, LANGUAGE)

		DEFPR,_ := exec.Command("bash", "-c", fmt.Sprintf("sudo e4defrag -v %s ",part)).Output()
		fmt.Printf(string(DEFPR))
		fmt.Println("")
		exec.Command("bash", "-c", fmt.Sprintf("sudo umount %s ",part))
		lib.Printer("print", 9, LANGUAGE)
		fmt.Println(lib.Reader(4, LANGUAGE))
		fmt.Scanln(); lib.Clear()

		lib.Printer("print", 12, LANGUAGE)

		ORRREPFINAL,ERRREPFINAL  := exec.Command("bash", "-c", fmt.Sprintf("sudo fsck.ext4 -y -f -v %s", part)).Output()
		fmt.Printf(string(ORRREPFINAL))
		if(ERRREPFINAL == nil) {
			lib.Printer("print", 9, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		} else {
			lib.Printer("print", 8, LANGUAGE)
			fmt.Println(lib.Reader(4, LANGUAGE))
			fmt.Scanln(); lib.Clear(); menu()
			return
		}
	} else {
		lib.Printer("print", 8, LANGUAGE)
		fmt.Println(lib.Reader(4, LANGUAGE))
		fmt.Scanln(); lib.Clear(); menu()
		return
	}
}

func main() { core() }