import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;

import 'package:rsyncer_cli/app.dart';

enum PrintQuery { normal, inline, warn, error }

String lang(int index, [PrintQuery? typeQuery, List<String>? custom]) {

  final app = locator.get<App>();

  final dictEsp = [
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

  final dictEng = [
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

  if(typeQuery == null) {
    return app.english ? dictEng[index] : dictEsp[index];
  } else {
    switch(typeQuery) {
      case PrintQuery.normal:
        print(app.english ? dictEng[index] : dictEsp[index]);
        return '';
      case PrintQuery.inline:
        Console.write(app.english ? dictEng[index] : dictEsp[index]);
        return '';
      case PrintQuery.warn:
        Console.write(cyan('[*] '));
        print('WARNING: ${app.english ? dictEng[index] : dictEsp[index]}');
        return '';
      case PrintQuery.error:
        Console.write(red('[*] '));
        print('ERROR: ${app.english ? dictEng[index] : dictEsp[index]}');
        return '';
    }
  }
}