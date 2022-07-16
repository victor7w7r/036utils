def printer(type: str, position: int, language: int, additional: str = "") -> None:

    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m'

    DICTIONARY_ENG=(
        "Your Operating System is not GNU/Linux, exiting",
        "In this system the binary sudo doesn't exist.",
        "The rsync binary is not available in this system, please install",
        "The dialog binary is not available in this system, please install",
        "All dependencies is ok!",
        f"The directory {additional} doesn't exist",
        "=============== START RSYNC =============== \n" ,
        "Done!\n",
        "Your Python versión is less than 3.5, exiting",
        "You don't have permissions to write the destination or read the source",
        "=============== FAIL =============== \n"
    )

    DICTIONARY_ESP=(
        "Este sistema no es GNU/Linux, saliendo",
        "En este sistema no existe el binario de superusuario.",
        "El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
        "EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
        "¡Todo ok!",
        f"El directorio {additional} no existe",
        "=============== EMPEZAR RSYNC =============== \n" ,
        "Listo!\n",
        "Tu versión de Python es menor que 3.5, saliendo",
        "No tienes permisos para escribir el directorio de destino o para leer el origen",
        "=============== FALLA =============== \n"
    )

    if language == 1 :
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