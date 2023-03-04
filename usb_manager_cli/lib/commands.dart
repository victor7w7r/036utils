import 'dart:async' show Timer;
import 'dart:io';

import 'package:dcli/dcli.dart' show Terminal, waitForEx;
import 'package:fpdart/fpdart.dart' show Task;

void clear() => Terminal().clearScreen();

Future<bool> verifycmd(String cmd) =>
  Task(() async => Process.run('bash', ['-c', 'type $cmd']))
    .map((chk) => chk.exitCode == 0)
    .run();

Future<int> codeproc(String cmd) =>
  Task(() async => waitForEx(Process.start(
    'bash', ['-c', cmd],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio
  )))
    .flatMap((cmd) => Task(() => cmd.exitCode))
    .run();

Future<String> sysout(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => cmd.stdout.toString().trim())
    .run();

Future<List<String>> syssplit(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => cmd.stdout.toString().split('\n'))
    .run();

Future<String> sysoutwline(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => cmd.stdout.toString().split('\n')[0])
    .run();

Future<List<String>> syscodeout(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => [cmd.exitCode.toString(), cmd.stdout.toString()])
    .run();

Future<bool> checkUid() =>
  Task(() async => Process.run('bash', ['-c', 'echo \$EUID']))
    .map((cmd) => cmd.stdout.toString().trim() == '0')
    .run();

Future<int> dialog(
  String title,
  String body,
  String height,
  String width
) async {
  final dialogBox = waitForEx(Process.start(
    'bash',
    ['-c',"whiptail --title '$title' --msgbox '$body' '$height' '$width'"],
    mode: ProcessStartMode.inheritStdio
  ));
  try {
    await dialogBox.stdout.pipe(stdout);
    await stdin.pipe(dialogBox.stdin);
    return dialogBox.exitCode;
  } on StateError catch(_) {
    return dialogBox.exitCode;
  }
}

Timer spin() {
  int cursor = 0;
  return Timer.periodic(Duration(milliseconds: 100), (t) {
    stdout.write('\r${['|', '/', '-', '\\'][cursor]}');
    cursor++;
    if(cursor == 4) cursor = 0;
  });
}