package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"rsyncer/lib"
	"runtime"
	"time"

	"github.com/AlecAivazis/survey/v2"
	"github.com/briandowns/spinner"
)

func core() {
	lib.Clear(); language(); lib.Cover(); verify()
}

var LANGUAGE int = 0
var SOURCE string = ""
var DEST string = ""

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
	if(!lib.Commandverify("rsync")) {
		lib.Clear(); lib.Printer("error", 2, LANGUAGE)
		fmt.Print("\n"); os.Exit(1)
	}
	lib.Printer("print",3, LANGUAGE)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear(); sourceaction();
}

func validator(typeData string, data string) {

	if typeData == "source" {
		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				SOURCE=data; lib.Clear(); destiaction()
				return
			} else {
				lib.Clear(); lib.Printer("error", 4, LANGUAGE, data)
				fmt.Println(""); fmt.Println(lib.Reader(2, LANGUAGE))
				fmt.Scanln(); lib.Clear(); sourceaction()
				return
			}
		} else {
			fmt.Print("\n"); os.Exit(0)
		}
	} else if typeData == "dest" {
		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				DEST=data; syncer(); return
			} else {
				lib.Clear(); lib.Printer("error", 4, LANGUAGE, data)
				fmt.Println(""); fmt.Println(lib.Reader(2, LANGUAGE))
				fmt.Scanln(); lib.Clear(); destiaction()
				return
			}
		} else {
			sourceaction(); return
		}
	} else {
		fmt.Print("\n"); os.Exit(0)
	}
}

func sourceaction() {
	data := ""
	prompt := &survey.Input{Message: lib.Reader(0, LANGUAGE),}
	survey.AskOne(prompt, &data)
	validator("source", data)
}

func destiaction() {
	data := ""
	prompt := &survey.Input{Message: lib.Reader(1, LANGUAGE),}
	survey.AskOne(prompt, &data)
	validator("dest", data)
}

func syncer() {
	SOURCEREADY := ""; DESTREADY :=""
	matchSource, _ := regexp.MatchString(".*\\/$", SOURCE)
	matchDest, _ := regexp.MatchString(".*\\/$", DEST)
	if(matchSource) {
		SOURCEREADY = SOURCE
	} else {
		SOURCEREADY = SOURCE + "/"
	}
	if(matchDest) {
		DESTREADY = DEST
	} else {
		DESTREADY = DEST + "/"
	}
	lib.Clear(); lib.Printer("print", 5, LANGUAGE); fmt.Println("")
	fmt.Printf("SOURCE:{%s} \n", SOURCEREADY)
	fmt.Printf("DESTINATION:{%s} \n", DESTREADY)
	fmt.Println("")
	syncApt := exec.Command("rsync", "-axHAWXS", "--numeric-ids", "--info=progress2", SOURCEREADY, DESTREADY)
	_, err := syncApt.Output();
	if err == nil {
		fmt.Print("\n =============== OK =============== \n")
		lib.Printer("print", 6, LANGUAGE); os.Exit(0)
	} else {
		lib.Clear(); lib.Printer("print", 7, LANGUAGE); fmt.Println("")
		fmt.Printf("SOURCE:{%s} \n" , SOURCEREADY)
		fmt.Printf("DESTINATION:{%s} \n", DESTREADY)
		fmt.Println("")
		syncAptTwo := exec.Command("sudo","rsync", "-axHAWXS", "--numeric-ids", "--info=progress2", SOURCEREADY, DESTREADY)
		_, err := syncAptTwo.Output();
		if err == nil {
			fmt.Print("\n =============== OK =============== \n")
			lib.Printer("print",6, LANGUAGE); os.Exit(0)
		} else {
			lib.Printer("print",8, LANGUAGE); os.Exit(1)
		}
	}
}

func main() { core() }