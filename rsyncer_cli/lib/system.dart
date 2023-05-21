import 'dart:io' show Process, ProcessStartMode;

import 'package:fpdart/fpdart.dart' show Task;
import 'package:dcli/dcli.dart' show Terminal, waitForEx;

void clear() =>
  Terminal().clearScreen();

Future<bool> success(
  final String cmd
) => Task(() =>
  Process.run(
    'bash',
    ['-c', 'type $cmd']
  ))
    .map((res) => res.exitCode == 0)
    .run();

Future<int> coderes(
  final String cmd
) => Task(() async => waitForEx(
  Process.start(
    'bash',
    ['-c', cmd],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio
  )))
    .flatMap((res) => Task(() => res.exitCode))
    .run();