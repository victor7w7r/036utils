package lib

import (
	"fmt"

	"github.com/fatih/color"
)

func Printer(typeQuery string, position int, language int) {

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

	if language == 1 {
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
