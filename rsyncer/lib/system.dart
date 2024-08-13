import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class System {
  const System(this._attach, this._io, this._lang);

  final Attach _attach;
  final InputOutput _io;
  final Lang _lang;

  bool directoryCheck(final String data) =>
      Either.tryCatch(() => _attach.existsDir(data), (final _, final __) {
        _io.clear();
        _lang.write(11, PrintQuery.error);
        _attach.successExit();
      }).getOrElse((final _) => false);
}
