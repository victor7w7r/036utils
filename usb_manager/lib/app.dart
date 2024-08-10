import 'dart:async' show unawaited;
import 'dart:io' show exit;

import 'package:cli_menu/cli_menu.dart' show Menu;
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

@injectable
class App {
  const App(
    this._colorize,
    this._io,
    this._lang,
    this._usbListener,
  );

  final Colorize _colorize;
  final InputOutput _io;
  final Lang _lang;
  final UsbListener _usbListener;

  Future<void> call() async {
    _colorize.cyan(_lang.write(11));
    final op = Menu([
      _lang.write(13),
      _lang.write(14),
      _lang.write(15),
      _lang.write(16),
    ]).choose();
    if (op.value == _lang.write(13)) {
      _io.clear();
      await _usbListener(Action.mount);
      unawaited(call());
    } else if (op.value == _lang.write(14)) {
      _io.clear();
      await _usbListener(Action.unmount);
      unawaited(call());
    } else if (op.value == _lang.write(15)) {
      _io.clear();
      await _usbListener(Action.off);
      unawaited(call());
    } else if (op.value == _lang.write(16)) {
      _io.clear();
      exit(0);
    }
  }
}
