package main

import (
	"ext4-optimizer/lib"
	"fmt"
	"os"
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

	lib.Clear()
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

	optionable := lib.Ext4listener(LANGUAGE, lib.OptExtParams{menuable: "menu", echoparts: "print"})

}

func main() { core() }