import 'dart:async' show unawaited;

import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

@injectable
class App {
  App(
    this._attach,
    this._io,
    this._lang,
    this._sync,
    this._sys,
  )   : _dest = '',
        _source = '';

  final Attach _attach;
  final InputOutput _io;
  final Lang _lang;
  final Sync _sync;
  final System _sys;
  String _dest;
  String _source;

  Future<void> _action(
    final bool isSource, [
    final bool isTesting = false,
  ]) =>
      _attach.readMessage(_lang.write(isSource ? 8 : 9)).then(
            (final val) => _validator(
              isSource ? 'source' : 'dest',
              val,
              isTesting,
            ),
          );

  void _interrupt(
    final bool isOp,
    final String data, [
    final bool isTesting = false,
  ]) {
    _io.clear();
    _lang
      ..write(3, PrintQuery.error, data)
      ..write(10, PrintQuery.normal);
    _attach.readSync();
    _io.clear();
    if (isTesting) return;
    unawaited(_action(isOp));
  }

  void _validator(
    final String typeData,
    final String data, [
    final bool isTesting = false,
  ]) {
    if (typeData == 'source') {
      if (data.isNotEmpty) {
        if (_sys.directoryCheck(data)) {
          _source = data;
          _io.clear();
          if (isTesting) return;
          unawaited(_action(false));

          return;
        } else {
          _interrupt(true, data, isTesting);

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
          unawaited(_sync(_source, _dest));
        } else {
          _interrupt(false, data, isTesting);

          return;
        }
      } else {
        if (isTesting) return;

        unawaited(_action(true));

        return;
      }
    } else {
      // coverage:ignore-start
      _io.clear();
      _attach.successExit();
      // coverage:ignore-end
    }
  }

  Future<void> call([
    final bool isTesting = false,
  ]) =>
      _action(true, isTesting);

  Future<void> callDest() => _action(false, true);
}
