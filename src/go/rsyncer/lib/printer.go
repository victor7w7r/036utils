package lib

import (
	"fmt"

	"github.com/fatih/color"
)

func Printer(typeQuery string, position int, languaje int, additional ...string) {

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

	if languaje == 1 {
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