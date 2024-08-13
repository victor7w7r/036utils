import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class Sync {
  const Sync(this._attach, this._io, this._lang);

  final Attach _attach;
  final InputOutput _io;
  final Lang _lang;

  String _matchSlash(final String sel) =>
      RegExp(r'.*\/$').hasMatch(sel) ? sel : '$sel/';

  Future<int> _syncCmd(
    final bool sudo,
    final String source,
    final String dest,
  ) =>
      _io.coderes('${sudo ? 'sudo' : ''} rsync -axHAWXS '
          '--numeric-ids --info=progress2 $source $dest');

  Future<void> call(
    final String sourceParam,
    final String destParam,
  ) async {
    final source = _matchSlash(sourceParam);
    final dest = _matchSlash(destParam);

    _io.clear();

    _lang.write(4, PrintQuery.normal);
    print('SOURCE:{$source}');
    print('DESTINATION:{$dest} \n');

    if (await _syncCmd(false, source, dest) == 0) {
      _lang.okLine();
    } else {
      _io.clear();
      _lang.write(6, PrintQuery.normal);
      print('SOURCE:{$source}');
      print('DESTINATION:{$dest} \n');
      if (await _syncCmd(true, source, dest) == 0) {
        // coverage:ignore-start
        _lang.okLine();
        // coverage:ignore-end
      } else {
        _lang.write(7, PrintQuery.normal);
        _attach.errorExit();
      }
    }
  }
}
