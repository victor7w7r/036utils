package lib

import (
	"fmt"

	"github.com/fatih/color"
)

func Printer(typeQuery string, position int, languaje int) {

	DICTIONARY_ENG := [15]string{
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The udisks command line tool (udisksctl) doesn't exist, please install udisks2",
		"The whiptail binary is not available in this system, please install",
		"The udisks2 service is not running, please enable the service",
		"All dependencies is ok!",
		"There's no USB drives connected in this PC, or the devices are shutdown",
		"All the partitions are mounted in your system",
		"Your attempt to get authorization is not valid (Invalid Password)",
		"This partition is already mounted",
		"There's not partitions mounted in your system",
		"Your partition is unmounted",
		"You need to be root, execute with sudo",
	}

	DICTIONARY_ESP := [15]string{
		"Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El \"udisks command line tool (udisksctl)\" no existe, por favor instale udisks2",
		"El ejecutable de whiptail, no se encuentra en el sistema, por favor instalalo",
		"El servicio udisks2 no esta ejecutandose, por favor ejecutalo",
		"Todo ok!",
		"No hay dispositivos USB conectados en esta PC, o los mismos estan apagados",
		"Todas las particiones estan montadas en el sistema",
		"Tu intento de autorizacion como superusuario no fue exitoso (Contrasena Incorrecta)",
		"Esta particion esta montada actualmente",
		"No hay particiones montadas en el sistema",
		"Esta particion no esta montada",
		"Necesitas ser superusuario, ejecuta con sudo",
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