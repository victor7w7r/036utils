import 'dart:io' show Platform, Process;

import 'package:fpdart/fpdart.dart' show Task;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager_cli/usb_manager_cli.dart';

Future<void> init() async {
  clear();
  setLang();
  initLang();
  clear();
  cover();

  final spinAction = spin();

  onlyIf(!Platform.isLinux, () => error(0));

  await checkUid().then(
    (final val) => onlyIf(!val, () => error(1)),
  );

  await success('udisksctl').then(
    (final val) => onlyIf(!val, () => error(2)),
  );

  await success('whiptail').then(
    (final val) => onlyIf(!val, () => error(3)),
  );

  await Task(
    () => Process.run(
      'bash',
      ['-c', 'systemctl is-active udisks2'],
      runInShell: true,
    ),
  ).map((final srvu) => (srvu.stdout as String).trim()).run().then(
        (final srv) => onlyIf(srv == 'inactive', () => error(4)),
      );

  await checkUsbDevices().then(
    (final val) => onlyIf(val, () => error(6)),
  );

  spinAction.cancel();

  lang(5, PrintQuery.normal);
}
