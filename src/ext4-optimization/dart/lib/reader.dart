String reader(int position, int language) {
  List<String> dictionaryEng = [
		"Choose a Option",
		"Optimize a ext4 partition",
		"Exit to the shell",
		"Please select a partition" ,
		"Press Enter to continue...",
		"Optimize",
		"Exit"
  ];

	List<String> dictionaryEsp = [
    "Seleccione una opcion",
		"Optimizar una particion de tipo ext4",
		"Salir al shell",
		"Por favor selecciona una partition",
		"Presione Enter para continuar...",
		"Optimizar",
		"Salir"
  ];

	if(language == 1) {
		return dictionaryEng[position];
	} else {
		return dictionaryEsp[position];
	}
}