import 'dart:async' show Timer;
import 'dart:io' show Process, stdout;

import 'package:fpdart/fpdart.dart' show Task;
import 'package:dcli/dcli.dart' show Terminal;

void clear() => Terminal().clearScreen();

Future<String> sysout(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => (cmd.stdout.toString()).trim())
    .run();

Future<int> codeproc(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => cmd.exitCode)
    .run();

Timer spin() {
  int cursor = 0;
  return Timer.periodic(Duration(milliseconds: 100), (t) {
    stdout.write('\r${['|', '/', '-', '\\'][cursor]}');
    cursor++;
    if(cursor == 4) cursor = 0;
  });
}
