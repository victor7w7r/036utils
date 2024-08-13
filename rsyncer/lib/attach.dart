// coverage:ignore-file

import 'dart:io';

import 'package:console/console.dart' show readInput;
import 'package:injectable/injectable.dart' show injectable;

@injectable
class Attach {
  bool get isLinux => Platform.isLinux;

  void errorExit() => exit(1);
  bool existsDir(final String data) => Directory(data).existsSync();
  Future<String> readMessage(final String msg) => readInput(msg);
  String readSync() => stdin.readLineSync() ?? '';
  void successExit() => exit(0);
}
