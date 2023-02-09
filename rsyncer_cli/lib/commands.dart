import 'dart:io' show Process, ProcessStartMode;

import 'package:fpdart/fpdart.dart' show Task;
import 'package:dcli/dcli.dart' show Terminal, waitForEx;

void clear() => Terminal().clearScreen();

Future<bool> verifycmd(String cmd) =>
  Task(() async => Process.run("bash", ["-c", "type $cmd"]))
    .map((chk) => chk.exitCode == 0)
    .run();

Future<int> codeproc(String cmd) =>
  Task(() async => waitForEx(Process.start(
    'bash', ["-c", cmd],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio
  )))
    .flatMap((cmd) => Task(() => cmd.exitCode))
    .run();