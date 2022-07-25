package lib

func Reader(position int, languaje int) string {

	DICTIONARY_ENG := [7]string{
		"Choose a Option",
		"Optimize a ext4 partition",
		"Exit to the shell",
		"Please select a partition" ,
		"Press Enter to continue...",
		"Optimize",
		"Exit",
	}

	DICTIONARY_ESP := [7]string{
		"Seleccione una opcion",
		"Optimizar una particion de tipo ext4",
		"Salir al shell",
		"Por favor selecciona una partition",
		"Presione Enter para continuar...",
		"Optimizar",
		"Salir",
	}

	if languaje == 1 {
		return DICTIONARY_ENG[position]
	} else {
		return DICTIONARY_ESP[position]
	}
}
