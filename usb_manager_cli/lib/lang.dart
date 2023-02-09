import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;

import 'package:usb_manager_cli/app.dart';

enum PrintQuery { normal, inline, warn, error }

String dialogLang(int index, [String? ins]) {

  final app = locator.get<App>();

  final dictEsp = [
    "LISTO",
    "ERROR: Hubo un error desmontando /dev/${ins ?? ''} por favor revisar o mira si tienes permisos",
    "LISTO: Tu dispositivo ${ins ?? ''} se ha apagado exitosamente",
    "ERROR: no está disponible el apagar este dispositivo, por favor revisar o mira si tienes permisos"
  ];

  final dictEng = [
    "SUCCESS",
    "FAIL: Error unmounting /dev/${ins ?? ''} please check or check if you have the right permissions",
    "SUCCESS: Your device ${ins ?? ''} was succesfully power-off",
    "FAIL: Power-off is not available on this device, please check or check if you have permissions"
  ];

  return app.english ? dictEng[index] : dictEsp[index];

}

String lang(int index, [PrintQuery? typeQuery]) {

  final app = locator.get<App>();

  const dictEsp = [
    "Este sistema no es GNU/Linux, saliendo",
    "Necesitas ser superusuario, por favor ejecuta con sudo",
    "El \"udisks command line tool (udisksctl)\" no existe, por favor instale udisks2",
    "El ejecutable de whiptail, no se encuentra en el sistema, por favor instalalo",
    "El servicio udisks2 no esta ejecutandose, por favor ejecutalo",
    "Todo ok!",
    "No hay dispositivos USB conectados en esta PC, o los mismos estan apagados",
    "Todas las particiones estan montadas en el sistema",
    "No hay particiones montadas en el sistema",
    "Esta particion esta montada actualmente",
    "Esta particion no esta montada",
    "Elija una opcion \n",
    "Número: ",
    "Montar una particion de un dispositivo",
    "Desmontar una particion de un dispositivo",
    "Desmontar todo y expulsar de manera segura un dispositivo",
    "Salir al shell",
    "Presione Enter para continuar...",
    "Por favor, monta una particion \n",
    "LISTO: ",
    "Por favor, desmonta una particion \n",
    "Por favor, elija uno para apagar, desmontando todo \n",
    "Montar",
    "Desmontar",
    "Apagar",
    "Salir"
  ];

  const dictEng = [
    "Your Operating System is not GNU/Linux, exiting",
    "You need to be root, please execute with sudo",
    "The udisks command line tool (udisksctl) doesn't exist, please install udisks2",
    "The whiptail binary is not available in this system, please install",
    "The udisks2 service is not running, please enable the service",
    "All dependencies is ok!",
    "There's no USB drives connected in this PC, or the devices are shutdown",
    "All the partitions are mounted in your system",
    "There's not partitions mounted in your system",
    "This partition is already mounted",
    "Your partition is unmounted",
    "Choose a Option \n",
    "Number: ",
    "Mount a partition of a device",
    "Unmount a partition of a device",
    "Unmount and secure turn-off a USB",
    "Exit to the shell",
    "Press Enter to continue...",
    "Please mount a partition \n",
    "SUCCESS: ",
    "Please umount a partition \n",
    "Please, choose for poweroff a device, unmounting all",
    "Mount",
    "Unmount",
    "Power-off",
    "Exit"
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