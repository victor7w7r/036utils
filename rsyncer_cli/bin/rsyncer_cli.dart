import 'dart:io' show exit, stdin;

import 'package:console/console.dart' show readInput;
import 'package:dcli/dcli.dart' show exists;

import 'package:rsyncer_cli/rsyncer_cli.dart';

var _source = '';
var _dest = '';

void _action(
  final bool isSource
) => readInput(lang(isSource ? 8 : 9))
  .then((val) => _validator(
    isSource ? 'source' : 'dest', val
  ));

void _interrupt(
  final bool isOp,
  final String data
) {
  clear();
  lang(3, PrintQuery.error, [data]);
  lang(10, PrintQuery.normal);
  stdin.readLineSync();
  clear();
  _action(isOp);
}

void _validator(
  final String typeData,
  final String data
) {
  if(typeData == 'source') {
    if((data.isNotEmpty)) {
      if(exists(data)) {
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
  } else if(typeData == 'dest') {
    if(data.isNotEmpty) {
      if(exists(data)) {
        _dest = data;
        clear();
        _syncer();
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

String _match(
  final String sel
) => RegExp(r'.*\/$')
  .hasMatch(sel) ? sel : '$sel/';

Future<int> _syncCmd(
  final bool sudo,
  final String source,
  final String dest
) => coderes(
  '${sudo ? 'sudo' : ''} rsync -axHAWXS '
  '--numeric-ids --info=progress2 $source $dest'
);

void _syncer() async {

  final source = _match(_source);
  final dest = _match(_dest);

  clear();

  lang(4, PrintQuery.normal);
  print('SOURCE:{$source}');
	print('DESTINATION:{$dest} \n');

  if(await _syncCmd(false, source, dest) == 0) {
    ok();
  } else {
    clear();
    lang(6, PrintQuery.normal);
    print('SOURCE:{$source}');
    print('DESTINATION:{$dest} \n');
    if(await _syncCmd(true, source, dest) == 0) {
      ok();
    } else {
      lang(7, PrintQuery.normal);
      exit(1);
    }
  }
}

void main() async {
  await init();
  _action(true);
}
