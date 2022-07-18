import 'package:colorize/colorize.dart' show Colorize;

import 'dart:io' show stdout;

void printer(String typeQuery, int position, int language) {
  List<String> dictionaryEng = [
		"Your Operating System is not macOS, exiting",
		"All dependencies is ok!",
		"EFI Folder is mounted, unmounting",
		"EFI Folder is not mounted, mounting",
		"Done!",
		"Sudo auth fails",
  ];

  List<String> dictionaryEsp = [
    "Tu sistema operativo no es macOS, saliendo",
		"¡Todo ok!",
		"La carpeta EFI esta montada, desmontando",
		"La carpeta EFI no esta montada, montando",
		"¡Listo!",
		"Autenticación con sudo falló",
  ];

  final info = Colorize("[+] ").green();
  final warn = Colorize("[*] ").cyan();
  final error = Colorize("[*] ").red();

  switch(typeQuery) {
    case "print":
      print(language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]);
      break;
    case "info":
      stdout.write(info);
      print("INFO: ${
        language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
    case "warn":
      stdout.write(warn);
      print("WARNING: ${
        language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
    case "error":
      stdout.write(error);
      print("ERROR: ${
        language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
  }
}