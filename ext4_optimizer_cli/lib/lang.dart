import 'dart:io' show exit;

import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:ext4_optimizer_cli/system.dart';

enum PrintQuery {
  normal, inline,
  warn, error
}

var english = false;

const _dictEsp = [
  'Este sistema no es GNU/Linux, saliendo',
  'Necesitas ser superusuario, por favor ejecuta con sudo',
  'El ejecutable e4defrag no está presente en tu sistema, por favor instalalo',
  'fsck.ext4 no está presente en tu sistema, por favor instalalo',
  'Todo ok!',
  'No hay particiones ext4 disponibles en el sistema, solo funciona con dispositivos USB',
  'Todas las particiones ext4 estan montadas en el sistema, '
    'por favor desmontar la particion deseada para optimizar',
  '=============== VERIFICAR ERRORES EN EL SISTEMA DE ARCHIVOS =============== \n',
  '=============== FALLA =============== \n',
  '=============== LISTO =============== \n',
  '=============== OPTIMIZAR EL SISTEMA DE ARCHIVOS =============== \n',
  '=============== DESFRAGMENTAR EL SISTEMA DE ARCHIVOS, ESPERE POR FAVOR =============== \n',
  '=============== VERIFICAR POR ULTIMA VEZ EL SISTEMA DE ARCHIVOS =============== \n',
  'Numero: ',
  'Por favor selecciona una partition',
  'Optimizar',
  'Salir al shell',
  'Presione Enter para continuar...',
];

const _dictEng = [
  'Your Operating System is not GNU/Linux, exiting',
  'You need to be root, please execute with sudo',
  'e4defrag binary is not present in this system, please install',
  'fsck.ext4 is not present in this system, please install',
  'All dependencies is ok!',
  "There's not ext4 partitions available, only works with USB devices",
  'All the ext4 partitions are mounted in your system, please unmount '
    'the desired partition to optimize',
  '=============== VERIFY FILESYSTEM ERRORS =============== \n',
  '=============== FAILURE =============== \n',
  '=============== OK =============== \n',
  '=============== OPTIMIZE FILESYSTEM =============== \n',
  '=============== DEFRAG FILESYSTEM, PLEASE WAIT =============== \n',
  '=============== LAST VERIFY FILESYSTEM =============== \n',
  'Number: ',
  'Please select a partition' ,
  'Optimize',
  'Exit to the shell',
  'Press Enter to continue...',
];

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