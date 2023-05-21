import 'dart:io' show Platform;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan, green;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:ext4_optimizer_cli/ext4_optimizer_cli.dart';

Future<List<String>> init(
  final List<String> args
) async {

  clear();

  if(args.isEmpty) {

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
  }

  clear();
  cover();

  if(args.isEmpty) {

    final spinAction = spin();

    if(!Platform.isLinux) error(0);

    await checkUid().then((val){
      if(!val) error(1);
    });

    await success('e4defrag').then((val){
      if(!val) error(2);
    });

    await success('fsck.ext4').then((val){
      if(!val) error(3);
    });

    lang(4, PrintQuery.normal);
    final parts = await ext4listener(false);
    spinAction.cancel();

    return parts;
  } else {
    english = true;
    return [];
  }

}