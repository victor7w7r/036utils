import 'dart:async' show unawaited;

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

@injectable
class MacosEfi {
  const MacosEfi(this._io, this._lang, this._tui);

  final InputOutput _io;
  final Lang _lang;
  final Tui _tui;

  void checkEfiPart(
    final void Function(String) call,
  ) =>
      unawaited(
        _io.coderes('sudo cat < /dev/null').then((final checkSu) {
          final spinAction = _tui.spin();
          checkSu == 0
              ? efiPart().then((final efipart) {
                  call(efipart);
                  spinAction.cancel();
                  _lang.ok(4);
                })
              : _lang.error(5);
        }),
      );

  Future<String> efiCheck() => _io.sys(r'EFIPART=$(diskutil list '
      "| sed -ne '/EFI/p' "
      r"| sed -ne 's/.*\(d.*\).*/\1/p' "
      "| sed -ne '1p') "
      r'MOUNTROOT=$(df -h | sed -ne "/$EFIPART/p"); '
      r'echo $MOUNTROOT');

  Future<String> efiPart() => _io.sys('diskutil list '
      "| sed -ne '/EFI/p' "
      r"| sed -ne 's/.*\(d.*\).*/\1/p' "
      "| sed -ne '1p'");
}
