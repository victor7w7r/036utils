package lib

func Reader(position int, languaje int) string {

	DICTIONARY_ENG := [3]string{
		"Please write your source directory",
		"Please write your destination directory to copy",
		"Press Enter to continue...",
	}

	DICTIONARY_ESP := [3]string{
		"Por favor escriba su directorio de origen",
		"Por favor escriba su directorio de destino",
		"Presione Enter para continuar...",
	}

	if languaje == 1 {
		return DICTIONARY_ENG[position]
	} else {
		return DICTIONARY_ESP[position]
	}
}
