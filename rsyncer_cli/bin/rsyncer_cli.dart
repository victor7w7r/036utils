import 'dart:io' show exit, stdin;

import 'package:console/console.dart' show readInput;
import 'package:dcli/dcli.dart' show exists;

import 'package:rsyncer_cli/index.dart';

String _source = '';
String _dest = '';

Future<int> _syncCmd(String source, String dest) =>
  codeproc('rsync -axHAWXS --numeric-ids --info=progress2 $source $dest');

Future<int> _sudoSyncCmd(String source, String dest) =>
  codeproc('sudo rsync -axHAWXS --numeric-ids --info=progress2 $source $dest');

void _sourceaction() =>
  readInput(lang(8)).then((val) => _validator('source', val));

void _destiaction() =>
  readInput(lang(9)).then((val) => _validator('dest', val));

void _interrupt(bool op, String data) {
  clear();
  lang(3, PrintQuery.error, [data]);
  lang(10, PrintQuery.normal);
  stdin.readLineSync();
  clear();
  op ? _sourceaction() : _destiaction();
}

void _ok(){
  print('\n =============== OK =============== \n');
  lang(5, PrintQuery.normal);
  exit(0);
}

void _validator(String typeData, String data) {
  if(typeData == 'source') {
    if((data.isNotEmpty)) {
      if(exists(data)) {
        _source = data;
        clear();
        _destiaction();
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
      _sourceaction();
      return;
    }
  } else {
    clear();
    exit(0);
  }
}

Future<void> _syncer() async {

  String sourceReady = '';
  String destReady = '';

  RegExp(r'.*\/$').hasMatch(_source)
    ? sourceReady = _source
    : sourceReady = '$_source/';

  RegExp(r'.*\/$').hasMatch(_dest)
    ? destReady = _dest
    : destReady = '$_dest/';

  clear();

  lang(4, PrintQuery.normal);
  print('SOURCE:{$sourceReady}');
	print('DESTINATION:{$destReady} \n');

  if(await _syncCmd(sourceReady, destReady) == 0) {
    _ok();
  } else {
    clear();
    lang(6, PrintQuery.normal);
    print('SOURCE:{$sourceReady}');
    print('DESTINATION:{$destReady} \n');
    if(await _sudoSyncCmd(sourceReady, destReady) == 0) {
      _ok();
    } else {
      lang(7, PrintQuery.normal);
      exit(1);
    }
  }
}

Future<void> main() async {
  setup();
  await locator.get<App>().init();
  _sourceaction();
}
