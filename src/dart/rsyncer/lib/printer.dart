import 'dart:io' show stdout;

import 'package:colorize/colorize.dart' show Colorize;

void printer(String typeQuery, int position, int language, [String additional=""]) {
  List<String> dictionaryEng = [
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The rsync binary is not available in this system, please install",
		"The dialog binary is not available in this system, please install",
		"All dependencies is ok!",
    "The directory $additional doesn't exist"
		"=============== START RSYNC =============== \n" ,
		"Done!\n",
		"You don't have permissions to write the destination or read the source",
		"=============== FAIL =============== \n",
  ];

  List<String> dictionaryEsp = [
    "Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
		"EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
		"¡Todo ok!",
		"El directorio $additional no existe",
		"=============== EMPEZAR RSYNC =============== \n" ,
		"Listo!\n",
		"No tienes permisos para escribir el directorio de destino o para leer el origen",
		"=============== FALLA =============== \n",
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
