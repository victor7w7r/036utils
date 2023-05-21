import 'dart:io' show Process, ProcessResult;

import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(
  final String cmd
) => Task(() => Process.run(
  'bash',
  ['-c', cmd],
  runInShell: true
));

Future<bool> success(
  final String cmd
) => _exec(cmd)
  .map((res) => res.exitCode == 0)
  .run();

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

Future<List<String>> codeout(
  final String cmd
) => _exec(cmd)
  .map((res) => [
    res.exitCode.toString(),
    res.stdout.toString()
  ])
  .run();

Future<List<String>> syssplit(
  final String cmd
) => _exec(cmd)
  .map((res) => res.stdout.toString().split('\n'))
  .run();

Future<String> syswline(
  final String cmd
) => _exec(cmd)
  .map((res) => res.stdout.toString().split('\n')[0])
  .run();

Future<bool> checkUid() =>
  _exec('echo \$EUID')
    .map((res) => res.stdout.toString().trim() == '0')
    .run();