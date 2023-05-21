import 'dart:io' show exit;

import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;
import 'package:fpdart/fpdart.dart' show IO;

import 'package:efitoggler_cli/system.dart';

enum PrintQuery {
  normal, inline,
  warn, error
}

var english = false;

const _dictEsp = <String>[
  'Tu sistema operativo no es macOS, saliendo',
  '¡Todo ok!',
  'La carpeta EFI esta montada, desmontando',
  'La carpeta EFI no esta montada, montando',
  '¡Listo!',
  'Autenticación con sudo falló'
];

const _dictEng = <String>[
  'Your Operating System is not macOS, exiting',
  'All dependencies is ok!',
  'EFI Folder is mounted, unmounting',
  'EFI Folder is not mounted, mounting',
  'Done!',
  'Sudo auth fails'
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

void ok(final int index) {
  clear();
  lang(index, PrintQuery.normal);
  exit(0);
}