import 'dart:io' show stdin;

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

@injectable
class UsbAction {
  const UsbAction(this._io, this._lang, this._tui);

  final InputOutput _io;
  final Lang _lang;
  final Tui _tui;

  void _err(final bool op) {
    _io.clear();
    _lang.write(op ? 8 : 9, PrintQuery.error);
    print(_lang.write(17));
    stdin.readLineSync();
    _io.clear();
  }

  Future<void> call(final String part, final bool isMount) async {
    _io.clear();
    final spinAction = _tui.spin();

    final [code, out] = await _io
        .codeout("udisksctl ${isMount ? 'mount' : 'unmount'} -b $part");

    final notAuth = RegExp('NotAuthorized*').hasMatch(out) ||
        RegExp('NotAuthorizedDismissed*').hasMatch(out);

    spinAction.cancel();

    if (code == '0') {
      await _tui.dialog(_lang.write(19), '${_lang.write(19)}$out', '8', '80');
      _io.clear();
    } else {
      _err(notAuth);
    }
  }
}
