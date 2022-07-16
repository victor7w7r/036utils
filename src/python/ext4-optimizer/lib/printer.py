def printer(type: str, position: int, language: int) -> None:

    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m'

    DICTIONARY_ENG=(
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
        "Your Python versión is less than 3.5, exiting",
        "You need to be root, execute with sudo"
    )

    DICTIONARY_ESP=(
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