import 'dart:io' show Process, ProcessResult;

import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(final String cmd) =>
    Task(() async => Process.run('bash', ['-c', cmd], runInShell: true));

Future<int> call(final String cmd) =>
    _exec(cmd).map((final res) => res.exitCode).run();

Future<String> sys(final String cmd) =>
    _exec(cmd).map((final res) => res.stdout.toString().trim()).run();
