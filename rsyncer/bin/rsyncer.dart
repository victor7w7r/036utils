import 'dart:async' show unawaited;
import 'dart:io';

import 'package:console/console.dart' show readInput;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

var _source = '';
var _dest = '';

bool _directoryCheck(final String data) {
  try {
    return Directory(data).existsSync();
  } on FileSystemException catch (_) {
    clear();
    lang(11, PrintQuery.error);
    exit(0);
  }
}

void _action(final bool isSource) => unawaited(
      readInput(lang(isSource ? 8 : 9))
          .then((final val) => _validator(isSource ? 'source' : 'dest', val)),
    );

void _interrupt(final bool isOp, final String data) {
  clear();
  lang(3, PrintQuery.error, data);
  lang(10, PrintQuery.normal);
  stdin.readLineSync();
  clear();
  _action(isOp);
}

void _validator(
  final String typeData,
  final String data,
) {
  if (typeData == 'source') {
    if (data.isNotEmpty) {
      if (_directoryCheck(data)) {
        _source = data;
        clear();
        _action(false);
        return;
      } else {
        _interrupt(true, data);
        return;
      }
    } else {
      clear();
      exit(0);
    }
  } else if (typeData == 'dest') {
    if (data.isNotEmpty) {
      if (_directoryCheck(data)) {
        _dest = data;
        clear();
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
    clear();
    exit(0);
  }
}

String _match(final String sel) =>
    RegExp(r'.*\/$').hasMatch(sel) ? sel : '$sel/';

Future<int> _syncCmd(
  final bool sudo,
  final String source,
  final String dest,
) =>
    coderes('${sudo ? 'sudo' : ''} rsync -axHAWXS '
        '--numeric-ids --info=progress2 $source $dest');

Future<void> _syncer() async {
  final source = _match(_source);
  final dest = _match(_dest);

  clear();

  lang(4, PrintQuery.normal);
  print('SOURCE:{$source}');
  print('DESTINATION:{$dest} \n');

  if (await _syncCmd(false, source, dest) == 0) {
    okLine();
  } else {
    clear();
    lang(6, PrintQuery.normal);
    print('SOURCE:{$source}');
    print('DESTINATION:{$dest} \n');
    if (await _syncCmd(true, source, dest) == 0) {
      okLine();
    } else {
      lang(7, PrintQuery.normal);
      exit(1);
    }
  }
}

void main() async {
  await init();
  clear();
  _action(true);
}
