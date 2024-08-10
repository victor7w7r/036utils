import 'dart:async' show unawaited;
import 'dart:io';

import 'package:console/console.dart' show readInput;
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class App {
  App(
    this._attach,
    this._sys,
    this._io,
    this._lang,
  )   : _dest = '',
        _source = '';

  final Attach _attach;
  final InputOutput _io;
  final Lang _lang;
  final System _sys;
  String _dest;
  String _source;

  void _action(final bool isSource) => unawaited(
        readInput(_lang.write(isSource ? 8 : 9))
            .then((final val) => _validator(isSource ? 'source' : 'dest', val)),
      );

  void _interrupt(final bool isOp, final String data) {
    _io.clear();
    _lang
      ..write(3, PrintQuery.error, data)
      ..write(10, PrintQuery.normal);
    stdin.readLineSync();
    _io.clear();
    _action(isOp);
  }

  Future<void> _syncer() async {
    final source = _sys.matchSlash(_source);
    final dest = _sys.matchSlash(_dest);

    _io.clear();

    _lang.write(4, PrintQuery.normal);
    print('SOURCE:{$source}');
    print('DESTINATION:{$dest} \n');

    if (await _sys.syncCmd(false, source, dest) == 0) {
      _lang.okLine();
    } else {
      _io.clear();
      _lang.write(6, PrintQuery.normal);
      print('SOURCE:{$source}');
      print('DESTINATION:{$dest} \n');
      if (await _sys.syncCmd(true, source, dest) == 0) {
        _lang.okLine();
      } else {
        _lang.write(7, PrintQuery.normal);
        _attach.errorExit();
      }
    }
  }

  void _validator(
    final String typeData,
    final String data,
  ) {
    if (typeData == 'source') {
      if (data.isNotEmpty) {
        if (_sys.directoryCheck(data)) {
          _source = data;
          _io.clear();
          _action(false);

          return;
        } else {
          _interrupt(true, data);

          return;
        }
      } else {
        _io.clear();
        _attach.successExit();
      }
    } else if (typeData == 'dest') {
      if (data.isNotEmpty) {
        if (_sys.directoryCheck(data)) {
          _dest = data;
          _io.clear();
          unawaited(_syncer());
        } else {
          _interrupt(false, data);

          return;
        }
      } else {
        _action(true);

        return;
      }
    } else {
      _io.clear();
      _attach.successExit();
    }
  }

  void call() => _action(true);
}
