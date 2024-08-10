import 'dart:io';

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class System {
  const System(this._attach, this._io, this._lang);

  final Attach _attach;
  final InputOutput _io;
  final Lang _lang;

  bool directoryCheck(final String data) {
    try {
      return Directory(data).existsSync();
    } on FileSystemException catch (_) {
      _io.clear();
      _lang.write(11, PrintQuery.error);
      _attach.successExit();

      return false;
    }
  }

  String matchSlash(final String sel) =>
      RegExp(r'.*\/$').hasMatch(sel) ? sel : '$sel/';

  Future<int> syncCmd(
    final bool sudo,
    final String source,
    final String dest,
  ) =>
      _io.coderes('${sudo ? 'sudo' : ''} rsync -axHAWXS '
          '--numeric-ids --info=progress2 $source $dest');
}
