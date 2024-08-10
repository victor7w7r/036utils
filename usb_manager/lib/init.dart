import 'dart:io' show Platform, Process;

import 'package:fpdart/fpdart.dart' show Task;
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

@injectable
class Init {
  const Init(
    this._initLang,
    this._io,
    this._lang,
    this._storage,
    this._tui,
  );

  final InitLang _initLang;
  final InputOutput _io;
  final Lang _lang;
  final Storage _storage;
  final Tui _tui;

  Future<void> call() async {
    _io.clear();
    _initLang();
    _lang.assignLang();
    _io.clear();
    cover();

    final spinAction = _tui.spin();

    onlyIf(!Platform.isLinux, () => _lang.error(0));

    await _io.checkUid().then(
          (final val) => onlyIf(!val, () => _lang.error(1)),
        );

    await _io.success('udisksctl').then(
          (final val) => onlyIf(!val, () => _lang.error(2)),
        );

    await _io.success('whiptail').then(
          (final val) => onlyIf(!val, () => _lang.error(3)),
        );

    await Task(
      () => Process.run(
        'bash',
        ['-c', 'systemctl is-active udisks2'],
        runInShell: true,
      ),
    ).map((final srvu) => (srvu.stdout as String).trim()).run().then(
          (final srv) => onlyIf(srv == 'inactive', () => _lang.error(4)),
        );

    await _storage.checkUsbDevices().then(
          (final val) => onlyIf(val, () => _lang.error(6)),
        );

    spinAction.cancel();

    _lang.write(5, PrintQuery.normal);

    _io.clear();
  }
}
