package main

import (
	"ext4-optimizer/lib"

	"github.com/AlecAivazis/survey/v2"
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


func main() { core() }