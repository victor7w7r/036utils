import 'dart:io' show Platform;

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/lang.dart';

@injectable
class Init {
  const Init(this._initLang, this._io, this._lang);

  final InitLang _initLang;
  final InputOutput _io;
  final Lang _lang;

  void call() {
    _io.clear();
    _initLang();
    _lang.assignLang();
    _io.clear();
    cover();

    if (!Platform.isMacOS) _lang.error(0);

    _lang.write(1, PrintQuery.normal);
  }
}
