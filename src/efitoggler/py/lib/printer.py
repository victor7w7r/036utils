def printer(type: str, position: int, language: int) -> None:

    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m';

    DICTIONARY_ENG=(
        "Your Operating System is not macOS, exiting",
        "All dependencies is ok!",
        "EFI Folder is mounted, unmounting",
        "EFI Folder is not mounted, mounting",
        "Done!",
        "Your Python versión is less than 3.5, exiting",
        "Sudo auth fails"
    )
    DICTIONARY_ESP=(
        "Tu sistema operativo no es macOS, saliendo",
        "¡Todo ok!",
        "La carpeta EFI esta montada, desmontando",
        "La carpeta EFI no esta montada, montando",
        "¡Listo!",
        "Tu versión de Python es menor que 3.5, saliendo",
        "Autenticación con sudo falló"
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