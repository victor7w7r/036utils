import 'dart:io' show Platform;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan, green;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:efitoggler_cli/cover.dart';
import 'package:efitoggler_cli/lang.dart';
import 'package:efitoggler_cli/system.dart';

void init() {

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

  if(!Platform.isMacOS) error(0);

  lang(1, PrintQuery.normal);

}
