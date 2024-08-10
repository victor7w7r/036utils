import 'package:fpdart/fpdart.dart' show Task;
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

@injectable
class PowerOff {
  const PowerOff(
    this._io,
    this._lang,
    this._storage,
    this._tui,
  );

  final InputOutput _io;
  final Lang _lang;
  final Storage _storage;
  final Tui _tui;

  Future<T> _block<T>(
    final String part,
    final Future<T> Function(String) query,
  ) =>
      Task(() => _io.sys("echo $part | cut -d '/' -f3"))
          .flatMap((final block) => Task(() => query(block)))
          .run();

  Future<String> _modelQuery(final String part) => _block(
        part,
        (final block) => _io.sys('cat /sys/class/block/$block/device/model'),
      );

  Future<List<String>> _partsQuery(final String part) => _block(
        part,
        (final block) => _io.syssplit('find /dev -name "$block[[:digit:]]" '
            r"| sort -n | sed 's/^\/dev\///'"),
      );

  Future<void> call(final String part) async {
    final mounts = <String>[];

    _io.clear();
    final spinAction = _tui.spin();

    final partitionsQuery = await _partsQuery(part);

    partitionsQuery.removeWhere((final item) => item == '');

    for (final parts in partitionsQuery) {
      if (await _storage.mountUsbCheck(parts) != '') mounts.add(parts);
    }

    if (mounts.isNotEmpty) {
      for (final partition in mounts) {
        if (await _io.coderes(
              'udisksctl unmount -b /dev/$partition &> /dev/null',
            ) ==
            0) {
          print('');
        } else {
          spinAction.cancel();
          await _tui.dialog('ERROR', _lang.dialogLang(1, partition), '8', '80');
          _io.clear();

          return;
        }
      }
    }

    final model = await _modelQuery(part);

    spinAction.cancel();
    if (await _io.coderes('udisksctl power-off -b $part') == 0) {
      await _tui.dialog(
        _lang.dialogLang(0),
        _lang.dialogLang(2, model),
        '8',
        '80',
      );
      _io.clear();

      return;
    } else {
      await _tui.dialog('ERROR', _lang.dialogLang(3, model), '8', '80');
      _io.clear();

      return;
    }
  }
}
