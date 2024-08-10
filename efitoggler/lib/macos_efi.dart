import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

@injectable
class MacosEfi {
  const MacosEfi(this._io, this._lang, this._tui);

  final InputOutput _io;
  final Lang _lang;
  final Tui _tui;

  Future<String> _efiPart() => _io.sys('diskutil list '
      "| sed -ne '/EFI/p' "
      r"| sed -ne 's/.*\(d.*\).*/\1/p' "
      "| sed -ne '1p'");

  Future<String> checkEfiPart() async {
    final spinAction = _tui.spin();

    if (await _io.coderes('sudo cat < /dev/null') == 0) {
      final part = await _efiPart();
      spinAction.cancel();

      return part;
    } else {
      _lang.error(5);

      return '';
    }
  }

  Future<String> efiCheck() => _io.sys(r'EFIPART=$(diskutil list '
      "| sed -ne '/EFI/p' "
      r"| sed -ne 's/.*\(d.*\).*/\1/p' "
      "| sed -ne '1p') "
      r'MOUNTROOT=$(df -h | sed -ne "/$EFIPART/p"); '
      r'echo $MOUNTROOT');
}
