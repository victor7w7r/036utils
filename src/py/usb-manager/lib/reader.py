def reader(position: int, language: int) -> str:

    DICTIONARY_ENG=(
        "Choose a Option",
        "Mount a partition of a device",
        "Unmount a partition of a device",
        "Unmount and secure turn-off a USB",
        "Exit to the shell",
        "Press Enter to continue...",
        "Mount a Partition",
        "Please Mount a partition",
        "SUCCESS: ",
        "Umount a Partition",
        "Please umount a partition",
        "Poweroff a Device",
        "Choose for poweroff a device \nCAUTION: All the partitions will be force unmounted",
        "Mount",
        "Unmount",
        "Power-off",
        "Exit"
	)

    DICTIONARY_ESP=(
        "Elija una opcion",
        "Montar una particion de un dispositivo",
        "Desmontar una particion de un dispositivo",
        "Desmontar todo y expulsar de manera segura un dispositivo",
        "Salir al shell",
        "Presione Enter para continuar...",
        "Montar una particion",
        "Por favor, monta una particion",
        "LISTO: ",
        "Desmontar una particion",
        "Por favor, desmonta una particion",
        "Apagar un dispositivo",
        "Elija uno para apagar \nCUIDADO: Todas las particiones del dispositivo se desmontaran",
        "Montar",
        "Desmontar",
        "Apagar",
        "Salir"
	)

    if language == 1: return DICTIONARY_ENG[position]
    else: return DICTIONARY_ESP[position]