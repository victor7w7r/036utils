import 'dart:io';

import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(final String cmd) =>
    Task(() async => Process.run('bash', ['-c', cmd], runInShell: true));

Future<bool> success(final String cmd) =>
    _exec('type $cmd').map((final res) => res.exitCode == 0).run();

Future<String> sys(final String cmd) =>
    _exec(cmd).map((final res) => res.stdout.toString().trim()).run();
