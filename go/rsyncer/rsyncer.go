package main

import (
	"036utils/lib"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"runtime"
	"time"

	"github.com/AlecAivazis/survey/v2"
	"github.com/briandowns/spinner"
	"github.com/fatih/color"
)

func core() {
	lib.Clear(); language(); lib.Cover(); verify()
}

var LANGUAGE int = 0
var SOURCE string = ""
var DEST string = ""

func printer(typeQuery string, position int, additional ...string) {

	DICTIONARY_ENG := [10]string{
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The rsync binary is not available in this system, please install",
		"The dialog binary is not available in this system, please install",
		"All dependencies is ok!",
		fmt.Sprintf("The directory %s doesn't exist", additional),
		"=============== START RSYNC =============== \n" ,
		"Done!\n",
		"You don't have permissions to write the destination or read the source",
		"=============== FAIL =============== \n",
	}

	DICTIONARY_ESP := [10]string{
		"Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
		"EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
		"¡Todo ok!",
		fmt.Sprintf("El directorio %s no existe", additional),
		"=============== EMPEZAR RSYNC =============== \n" ,
		"Listo!\n",
		"No tienes permisos para escribir el directorio de destino o para leer el origen",
		"=============== FALLA =============== \n",
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

func reader(position int) string {

	DICTIONARY_ENG:= [3]string {
		"Please write your source directory",
		"Please write your destination directory to copy",
		"Press Enter to continue...",
	}

	DICTIONARY_ESP:= [3]string {
		"Por favor escriba su directorio de origen",
		"Por favor escriba su directorio de destino",
		"Presione Enter para continuar...",
	}

	if(LANGUAGE == 1) {
		return DICTIONARY_ENG[position]
	} else {
		return DICTIONARY_ESP[position]
	}
}

func commandverify(cmd string) bool {
	check := exec.Command("bash", "-c", fmt.Sprintf("type %s",cmd))
	_, err := check.Output();

	if(err == nil) {
		return true
	} else {
		return false
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
	if platform != "linux" {
		lib.Clear(); printer("error", 0)
		fmt.Print("\n"); os.Exit(1)
	}
	if(!commandverify("rsync")) {
		lib.Clear(); printer("error", 2)
		fmt.Print("\n"); os.Exit(1)
	}
	if(!commandverify("dialog")) {
		lib.Clear(); printer("error", 3)
		fmt.Print("\n"); os.Exit(1)
	}
	printer("print",4)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	lib.Clear(); sourceaction();
}

func validator(typeData string, data string) {

	if typeData == "source" {

		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				SOURCE=data;  destiaction();
				return
			} else {
				lib.Clear(); printer("error", 5, data)
				fmt.Println(reader(2)); fmt.Scanln()
				sourceaction(); return
			}
		} else {
			fmt.Print("\n"); os.Exit(0)
		}

	} else if typeData == "dest" {
		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				DEST=data;  syncer();
				return
			} else {
				lib.Clear(); printer("error", 6, data)
				fmt.Println(reader(2)); fmt.Scanln()
				sourceaction(); return
			}
		} else {
			lib.Clear(); printer("error", 5, data)
			fmt.Println(reader(2)); fmt.Scanln()
			sourceaction(); return
		}
	} else {
		fmt.Print("\n"); os.Exit(0)
	}

}

func sourceaction() {
	data := ""
	prompt := &survey.Input{Message: reader(0),}
	survey.AskOne(prompt, &data)
	validator("source", data)
}

func destiaction() {
	data := ""
	prompt := &survey.Input{Message: reader(1),}
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
	lib.Clear(); printer("print", 6)

	fmt.Printf("SOURCE:{%s}", SOURCEREADY)
	fmt.Printf("DESTINATION:{%s}", DESTREADY)
	syncApt := exec.Command("rsync", "-axHAWXS", "--numeric-ids", "--info=progress2", SOURCEREADY)
	_, err := syncApt.Output();
	if err != nil {
		fmt.Print("\n =============== OK =============== \n")
		printer("print",7); os.Exit(0)
	} else {
		lib.Clear(); printer("print", 9)
		fmt.Printf("SOURCE:{%s}", SOURCEREADY)
		fmt.Printf("DESTINATION:{%s}", DESTREADY)
		syncAptTwo := exec.Command("sudo","rsync", "-axHAWXS", "--numeric-ids", "--info=progress2", SOURCEREADY)
		_, err := syncAptTwo.Output();
		if err != nil {
			fmt.Print("\n =============== OK =============== \n")
			printer("print",7); os.Exit(0)
		} else {
			printer("print",10); os.Exit(1)
		}
	}
}

func main() { core() }