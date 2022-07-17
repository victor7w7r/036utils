import 'dart:io' show stdout;

import 'package:colorize/colorize.dart' show Colorize;

void printer(String typeQuery, int position, int language) {
  List<String> dictionaryEng = [
		"Your Operating System is not GNU/Linux, exiting",
    "In this system the binary sudo doesn't exist.",
    "e4defrag binary is not present in this system, please install",
    "fsck.ext4 is not present in this system, please install",
    "All dependencies is ok!",
    "There's not ext4 partitions available, only works with USB devices",
    "All the ext4 partitions are mounted in your system, please unmount the desired partition to optimize",
    "=============== VERIFY FILESYSTEM ERRORS =============== \n",
    "=============== FAILURE =============== \n",
    "=============== OK =============== \n",
    "=============== OPTIMIZE FILESYSTEM =============== \n",
    "=============== DEFRAG FILESYSTEM, PLEASE WAIT =============== \n",
    "=============== LAST VERIFY FILESYSTEM =============== \n",
    "You need to be root, execute with sudo"
  ];

  List<String> dictionaryEsp = [
    "Este sistema no es GNU/Linux, saliendo",
    "En este sistema no existe el binario de superusuario.",
    "El ejecutable e4defrag no está presente en tu sistema, por favor instalalo",
    "fsck.ext4 no está presente en tu sistema, por favor instalalo",
    "Todo ok!",
    "No hay particiones ext4 disponibles en el sistema, solo funciona con dispositivos USB",
    "Todas las particiones ext4 estan montadas en el sistema, por favor desmontar la particion deseada para optimizar",
    "=============== VERIFICAR ERRORES EN EL SISTEMA DE ARCHIVOS =============== \n",
    "=============== FALLA =============== \n",
    "=============== LISTO =============== \n",
    "=============== OPTIMIZAR EL SISTEMA DE ARCHIVOS =============== \n",
    "=============== DESFRAGMENTAR EL SISTEMA DE ARCHIVOS, ESPERE POR FAVOR =============== \n",
    "=============== VERIFICAR POR ULTIMA VEZ EL SISTEMA DE ARCHIVOS =============== \n",
    "Necesitas ser superusuario, ejecuta con sudo"
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
