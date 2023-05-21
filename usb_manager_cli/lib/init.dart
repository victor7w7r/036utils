import 'dart:io' show Platform, Process;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan, green;
import 'package:fpdart/fpdart.dart' show IO, Task;

import 'package:usb_manager_cli/usb_manager_cli.dart';

Future<bool> _usbCheck() =>
  Task(() => sys("find /dev/disk/by-id/ -name 'usb*' "
    "| sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'"
  ))
  .map((res) => res == '')
  .run();

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

  final spinAction = spin();

  if(!Platform.isLinux) error(0);

  await checkUid().then((val){
    if(!val) error(1);
  });

  await success('udisksctl').then((val){
    if(!val) error(2);
  });

  await success('whiptail').then((val){
    if(!val) error(3);
  });

  await Task(() => Process.run(
    'bash',
    ['-c', 'systemctl is-active udisks2'],
    runInShell: true)
  )
    .map((srvu) => (srvu.stdout as String).trim())
    .run()
    .then((srv){
      if(srv == 'inactive') error(4);
    });

  await _usbCheck().then((val){
    print(val);
    if(val) error(6);
  });

  spinAction.cancel();

  lang(5, PrintQuery.normal);

}