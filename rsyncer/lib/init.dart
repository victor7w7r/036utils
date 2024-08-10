import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class Init {
  const Init(
    this._attach,
    this._initLang,
    this._io,
    this._lang,
  );

  final Attach _attach;
  final InitLang _initLang;
  final InputOutput _io;
  final Lang _lang;

  Future<void> call() async {
    _io.clear();
    _initLang();
    _lang.assignLang();
    _io.clear();
    cover();

    if (!_attach.isLinux) _lang.error(0);

    await _io.success('rsync').then(
          (final val) => onlyIf(!val, () => _lang.error(1)),
        );

    _lang.write(2, PrintQuery.normal);
    _io.clear();
  }
}
