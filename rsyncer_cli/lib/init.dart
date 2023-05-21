import 'dart:io' show Platform;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan, green;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:rsyncer_cli/rsyncer_cli.dart';

Future<void> init() async {

  clear();
  print(green('Bienvenido / Welcome'));
  print(cyan(
    'Please, choose your language / Por favor selecciona tu idioma'
  ));

  IO(Chooser<String>(
    ['English', 'Espanol'],
    message: 'Number/Numero: '
  ).chooseSync)
    .map((sel) => english = sel == 'English')
    .run();

  clear();
  cover();

  if(!Platform.isLinux) error(0);

  await success('rsync').then((val){
    if(!val) error(1);
  });

  lang(2, PrintQuery.normal);

}