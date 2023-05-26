import 'dart:io' show exit;

import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:usb_manager_cli/usb_manager_cli.dart';

enum PrintQuery {
  normal, inline,
  warn, error
}

var english = false;

const _dictEsp = [
  'Este sistema no es GNU/Linux, saliendo',
  'Necesitas ser superusuario, por favor ejecuta con sudo',
  'El \'udisks command line tool (udisksctl)\''
  ' no existe, por favor instale udisks2',
  'El ejecutable de whiptail, no se encuentra en el sistema, por favor instalalo',
  'El servicio udisks2 no esta ejecutandose, por favor ejecutalo',
  'Todo ok!',
  'No hay dispositivos USB conectados en esta PC, o los mismos estan apagados',
  'Todas las particiones estan montadas en el sistema',
  'No hay particiones montadas en el sistema',
  'Esta particion esta montada actualmente',
  'Esta particion no esta montada',
  'Elija una opcion \n',
  'Número: ',
  'Montar una particion de un dispositivo',
  'Desmontar una particion de un dispositivo',
  'Desmontar todo y expulsar de manera segura un dispositivo',
  'Salir al shell',
  'Presione Enter para continuar...',
  'Por favor, monta una particion \n',
  'LISTO: ',
  'Por favor, desmonta una particion \n',
  'Por favor, elija uno para apagar, desmontando todo \n',
  'Montar',
  'Desmontar',
  'Apagar',
  'Salir'
];

const _dictEng = [
  'Your Operating System is not GNU/Linux, exiting',
  'You need to be root, please execute with sudo',
  'The udisks command line tool (udisksctl '
  "doesn't exist, please install udisks2",
  'The whiptail binary is not available in this system, please install',
  'The udisks2 service is not running, please enable the service',
  'All dependencies is ok!',
  "There's no USB drives connected in this PC, or the devices are shutdown",
  'All the partitions are mounted in your system',
  "There's not partitions mounted in your system",
  'This partition is already mounted',
  'Your partition is unmounted',
  'Choose a Option \n',
  'Number: ',
  'Mount a partition of a device',
  'Unmount a partition of a device',
  'Unmount and secure turn-off a USB',
  'Exit to the shell',
  'Press Enter to continue...',
  'Please mount a partition \n',
  'SUCCESS: ',
  'Please umount a partition \n',
  'Please, choose for poweroff a device, unmounting all',
  'Mount',
  'Unmount',
  'Power-off',
  'Exit'
];

String dialogLang(
  final int index,
  [final String? ins]
) {

  final dictDialogEsp = [
    'LISTO',
    "ERROR: Hubo un error desmontando /dev/${ins ?? ''} "
      'por favor revisar o mira si tienes permisos',
    "LISTO: Tu dispositivo ${ins ?? ''} se ha apagado exitosamente",
    'ERROR: no está disponible el apagar este dispositivo, '
      'por favor revisar o mira si tienes permisos'
  ];

  final dictDialogEng = [
    'SUCCESS',
    "FAIL: Error unmounting /dev/${ins ?? ''} "
      'please check or check if you have the right permissions',
    "SUCCESS: Your device ${ins ?? ''} was succesfully power-off",
    'FAIL: Power-off is not available on this device, '
      'please check or check if you have permissions'
  ];

  return english
    ? dictDialogEng[index]
    : dictDialogEsp[index];

}

String lang(
  final int index,
  [final PrintQuery? typeQuery]
) => IO(() =>
  english ? _dictEng[index] : _dictEsp[index]
).map((sel) => typeQuery != null
  ? IO(() => switch(typeQuery) {
      PrintQuery.normal =>
        print(sel),
      PrintQuery.inline =>
        Console.write(sel),
      PrintQuery.warn =>
        print('${cyan('[*] ')} WARNING: $sel'),
      PrintQuery.error =>
        print('${red('[*] ')} ERROR: $sel')
    })
    .map((_) => '').run()
  : sel
).run();

void error(final int index) {
  clear();
  lang(index, PrintQuery.error);
  print('\n');
  exit(1);
}