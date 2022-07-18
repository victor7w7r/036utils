def reader(position: int, language: int) -> str:

    DICTIONARY_ENG=(
		"Please write your source directory",
		"Please write your destination directory to copy",
		"Press Enter to continue...",
	)

    DICTIONARY_ESP=(
		"Por favor escriba su directorio de origen",
		"Por favor escriba su directorio de destino",
		"Presione Enter para continuar..."
	)

    if language == 1 : return DICTIONARY_ENG[position]
    else: return DICTIONARY_ESP[position]