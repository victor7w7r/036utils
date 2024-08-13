import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

enum Action { mount, unmount, off }

@injectable
class UsbListener {
  const UsbListener(
    this._attach,
    this._colorize,
    this._io,
    this._lang,
    this._powerOff,
    this._storage,
    this._tui,
    this._usbAction,
  );

  final Attach _attach;
  final Colorize _colorize;
  final InputOutput _io;
  final Lang _lang;
  final PowerOff _powerOff;
  final Storage _storage;
  final Tui _tui;
  final UsbAction _usbAction;

  void _err(final bool op) {
    _io.clear();
    _lang.write(op ? 7 : 8, PrintQuery.error);
    print(_lang.write(17));
    _attach.readSync();
    _io.clear();
  }

  Future<void> call(final Action action) async {
    final (parts, block, mounts, unmounts, args, argspoweroff, dirtyDevs) = (
      <String>[],
      <String>[],
      <String>[],
      <String>[],
      <String>[],
      <String>[],
      <String>[]
    );

    var (count, mountCount, unmountCount) = (0, 0, 0);

    _io.clear();

    final spinAction = _tui.spin();

    await _storage.checkUsbDevices().then(
          (final val) => onlyIf(val, () => _lang.error(6)),
        );

    for (final dev in await _storage.usbDevices()) {
      dirtyDevs.add(await _storage.dirtyDev(dev));
    }

    dirtyDevs.removeWhere((final dev) => dev == '');

    for (final dev in dirtyDevs) {
      if (await _storage.absoluteDev(dev) != '') {
        parts.add(await _storage.getAllBlockDev(dev));
        count++;
      } else {
        block.add(await _storage.getBlockDev(dev));
      }
    }

    for (final part in parts) {
      if (await _storage.mountUsbCheck(part) != '') {
        unmountCount++;
        mounts.add(part);
      } else {
        mountCount++;
        unmounts.add(part);
      }
    }

    if (action == Action.mount && unmountCount == count) {
      _err(true);

      return;
    } else if (action == Action.unmount && mountCount == count) {
      _err(false);

      return;
    }

    for (final part in action == Action.mount ? unmounts : mounts) {
      args.add('/dev/$part');
    }

    for (final part in block) {
      if (action == Action.off) argspoweroff.add('/dev/$part');
    }

    action == Action.off
        ? argspoweroff.add(_lang.write(25))
        : args.add(_lang.write(25));

    if (action == Action.mount) {
      _colorize.cyan(_lang.write(18));
    } else if (action == Action.unmount) {
      _colorize.cyan(_lang.write(20));
    } else {
      _colorize.cyan(_lang.write(21));
    }

    spinAction.cancel();

    final op = _attach.chooser(action == Action.off ? argspoweroff : args);

    if (op == _lang.write(25)) {
      _io.clear();

      return;
    } else {
      _io.clear();
      switch (action) {
        case Action.mount:
          await _usbAction(op, true);
        case Action.unmount:
          await _usbAction(op, false);
        case Action.off:
          await _powerOff(op);
      }
    }
  }
}
