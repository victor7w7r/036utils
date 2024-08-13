import 'dart:async' show unawaited;

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

@injectable
class App {
  const App(
    this._attach,
    this._colorize,
    this._io,
    this._lang,
    this._usbListener,
  );

  final Attach _attach;
  final Colorize _colorize;
  final InputOutput _io;
  final Lang _lang;
  final UsbListener _usbListener;

  Future<void> call([final bool isTesting = false]) async {
    _colorize.cyan(_lang.write(11));

    final op = _attach.chooser([
      _lang.write(13),
      _lang.write(14),
      _lang.write(15),
      _lang.write(16),
    ]);

    if (op == _lang.write(13)) {
      _io.clear();
      await _usbListener(Action.mount);
      if (isTesting) return;
      unawaited(call());
    } else if (op == _lang.write(14)) {
      _io.clear();
      await _usbListener(Action.unmount);
      if (isTesting) return;
      unawaited(call());
    } else if (op == _lang.write(15)) {
      _io.clear();
      await _usbListener(Action.off);
      if (isTesting) return;
      unawaited(call());
    } else if (op == _lang.write(16)) {
      _io.clear();
      _attach.successExit();
    }
  }
}
