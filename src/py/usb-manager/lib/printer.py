def printer(type: str, position: int, language: int) -> None:

    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m'

    DICTIONARY_ENG=(
        "Your Operating System is not GNU/Linux, exiting",
        "In this system the binary sudo doesn't exist.",
        "The udisks command line tool (udisksctl) doesn't exist, please install udisks2",
        "The dialog binary is not available in this system, please install",
        "The udisks2 service is not running, please enable the service",
        "All dependencies is ok!",
        "There's no USB drives connected in this PC, or the devices are shutdown",
        "All the partitions are mounted in your system",
        "Your attempt to get authorization is not valid (Invalid Password)",
        "This partition is already mounted",
        "There's not partitions mounted in your system",
        "Your partition is unmounted",
        "Your Python versión is less than 3.5, exiting",
        "You need to be root, execute with sudo"
	)

    DICTIONARY_ESP=(
        "Este sistema no es GNU/Linux, saliendo",
        "En este sistema no existe el binario de superusuario.",
        "El \"udisks command line tool (udisksctl)\" no existe, por favor instale udisks2",
        "El ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
        "El servicio udisks2 no esta ejecutandose, por favor ejecutalo",
        "Todo ok!",
        "No hay dispositivos USB conectados en esta PC, o los mismos estan apagados",
        "Todas las particiones estan montadas en el sistema",
        "Tu intento de autorizacion como superusuario no fue exitoso (Contrasena Incorrecta)",
        "Esta particion esta montada actualmente",
        "No hay particiones montadas en el sistema",
        "Esta particion no esta montada",
        "Tu versión de Python es menor que 3.5, saliendo",
        "Necesitas ser superusuario, ejecuta con sudo"
	)

    if language == 1:
        if type == "print": print(f"{DICTIONARY_ENG[position]}")
        elif type == "info": print(f"[{GREEN}+{ENDC}] INFO: {DICTIONARY_ENG[position]}")
        elif type == "warn": print(f"[{WARNING}*{ENDC}] WARNING: {DICTIONARY_ENG[position]}")
        elif type == "error": print(f"[{FAIL}!{ENDC}] ERROR: {DICTIONARY_ENG[position]}")
        else: print(f"[?] UNKNOWN: {DICTIONARY_ENG[position]}")
    else:
        if type == "print": print(f"{DICTIONARY_ESP[position]}")
        elif type == "info": print(f"[{GREEN}+{ENDC}] INFO: {DICTIONARY_ESP[position]}")
        elif type == "warn": print(f"[{WARNING}*{ENDC}] WARNING: {DICTIONARY_ESP[position]}")
        elif type == "error": print(f"[{FAIL}!{ENDC}] ERROR: {DICTIONARY_ESP[position]}")
        else: print(f"[?] UNKNOWN: {DICTIONARY_ESP[position]}")