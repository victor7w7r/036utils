package lib

import (
	"fmt"

	"github.com/fatih/color"
)

func Printer(typeQuery string, position int, languaje int) {

	DICTIONARY_ENG := [15]string{
        "Your Operating System is not GNU/Linux, exiting",
        "In this system the binary sudo doesn't exist.",
        "e4defrag binary is not present in this system, please install",
        "fsck.ext4 is not present in this system, please install",
        "The dialog binary is not available in this system, please install",
        "All dependencies is ok!",
        "There's not ext4 partitions available, only works with USB devices",
        "All the ext4 partitions are mounted in your system, please unmount the desired partition to optimize",
        "=============== VERIFY FILESYSTEM ERRORS =============== \n",
        "=============== FAILURE =============== \n",
        "=============== OK =============== \n",
        "=============== OPTIMIZE FILESYSTEM =============== \n",
        "=============== DEFRAG FILESYSTEM, PLEASE WAIT =============== \n",
        "=============== LAST VERIFY FILESYSTEM =============== \n",
        "You need to be root, execute with sudo",
	}

	DICTIONARY_ESP := [15]string{
		"Este sistema no es GNU/Linux, saliendo",
        "En este sistema no existe el binario de superusuario.",
        "El ejecutable e4defrag no está presente en tu sistema, por favor instalalo",
        "fsck.ext4 no está presente en tu sistema, por favor instalalo",
        "dialog no está presente en tu sistema, por favor instalalo",
        "Todo ok!",
        "No hay particiones ext4 disponibles en el sistema, solo funciona con dispositivos USB",
        "Todas las particiones ext4 estan montadas en el sistema, por favor desmontar la particion deseada para optimizar",
        "=============== VERIFICAR ERRORES EN EL SISTEMA DE ARCHIVOS =============== \n",
        "=============== FALLA =============== \n",
        "=============== LISTO =============== \n",
        "=============== OPTIMIZAR EL SISTEMA DE ARCHIVOS =============== \n",
        "=============== DESFRAGMENTAR EL SISTEMA DE ARCHIVOS, ESPERE POR FAVOR =============== \n",
        "=============== VERIFICAR POR ULTIMA VEZ EL SISTEMA DE ARCHIVOS =============== \n",
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