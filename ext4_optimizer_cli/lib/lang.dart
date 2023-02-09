import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;

import 'package:ext4_optimizer_cli/app.dart';

enum PrintQuery { normal, inline, warn, error }

String lang(int index, [PrintQuery? typeQuery]) {

  final app = locator.get<App>();

  const dictEsp = [
    "Este sistema no es GNU/Linux, saliendo",
    "Necesitas ser superusuario, por favor ejecuta con sudo",
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
    "Numero: ",
		"Por favor selecciona una partition",
		"Optimizar",
		"Salir al shell",
		"Presione Enter para continuar...",
  ];

  const dictEng = [
    "Your Operating System is not GNU/Linux, exiting",
    "You need to be root, please execute with sudo",
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
    "Number: ",
		"Please select a partition" ,
		"Optimize",
		"Exit to the shell",
		"Press Enter to continue...",
  ];

  if(typeQuery == null) {
    return app.english ? dictEng[index] : dictEsp[index];
  } else {
    switch(typeQuery) {
      case PrintQuery.normal:
        print(app.english ? dictEng[index] : dictEsp[index]);
        return "";
      case PrintQuery.inline:
        Console.write(app.english ? dictEng[index] : dictEsp[index]);
        return "";
      case PrintQuery.warn:
        Console.write(cyan("[*] "));
        print("WARNING: ${app.english ? dictEng[index] : dictEsp[index]}");
        return "";
      case PrintQuery.error:
        Console.write(red("[*] "));
        print("ERROR: ${app.english ? dictEng[index] : dictEsp[index]}");
        return "";
    }
  }
}