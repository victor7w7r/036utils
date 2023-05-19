import 'dart:io' show Process, ProcessResult;

import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(
  final String cmd
) => Task(() => Process.run(
  'bash',
  ['-c', cmd],
  runInShell: true
));

Future<String> sys(
  final String cmd
) => _exec(cmd)
  .map((res) => res.stdout.toString().trim())
  .run();

Future<int> coderes(
  final String cmd
) => _exec(cmd)
  .map((res) => res.exitCode)
  .run();