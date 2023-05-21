import 'dart:io' show exit;

import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:rsyncer_cli/system.dart';

enum PrintQuery {
  normal, inline,
  warn, error
}

var english = false;

String lang(
  final int index, [
    final PrintQuery? typeQuery,
    final List<String>? custom
  ]) {

  final dictEsp = <String>[
    'Este sistema no es GNU/Linux, saliendo',
		'El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo',
		'¡Todo ok!',
		"El directorio ${custom != null ? custom[0] : ''} no existe",
		'=============== EMPEZAR RSYNC =============== \n' ,
		'Listo!\n',
		'No tienes permisos para escribir el directorio de destino o para leer el origen \n',
		'=============== FALLA =============== \n',
    'Por favor escriba su directorio de origen: ',
    'Por favor escriba su directorio de destino: ',
    'Presione Enter para continuar...'
  ];

  final dictEng = <String>[
    'Your Operating System is not GNU/Linux, exiting',
		'The rsync binary is not available in this system, please install',
		'All dependencies is ok!',
    "The directory ${custom != null ? custom[0] : ''} doesn't exist"
		'=============== START RSYNC =============== \n' ,
		'Done!\n',
		"You don't have permissions to write the destination or read the source \n",
		'=============== FAIL =============== \n',
    'Please write your source directory: ',
    'Please write your destination directory to copy: ',
    'Press Enter to continue...'
  ];

  return IO(() =>
    english ? dictEng[index] : dictEsp[index]
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
}

void error(final int index) {
  clear();
  lang(index, PrintQuery.error);
  print('\n');
  exit(1);
}

void ok(){
  print('\n =============== OK =============== \n');
  lang(5, PrintQuery.normal);
  exit(0);
}