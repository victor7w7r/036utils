String reader(int position, int language) {
  List<String> dictionaryEng = [
    "Please write your source directory",
    "Please write your destination directory to copy",
    "Press Enter to continue...",
  ];

	List<String> dictionaryEsp = [
    "Por favor escriba su directorio de origen",
    "Por favor escriba su directorio de destino",
    "Presione Enter para continuar...",
  ];

	if(language == 1) {
		return dictionaryEng[position];
	} else {
		return dictionaryEsp[position];
	}
}