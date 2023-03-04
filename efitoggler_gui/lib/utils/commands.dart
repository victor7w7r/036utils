import 'dart:io' show Process;

import 'package:fpdart/fpdart.dart' show Task;

Future<String> sysout(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => (cmd.stdout.toString()).trim())
    .run();

Future<int> codeproc(String cmd) =>
  Task(() async => Process.run('bash', ['-c', cmd], runInShell: true))
    .map((cmd) => cmd.exitCode)
    .run();