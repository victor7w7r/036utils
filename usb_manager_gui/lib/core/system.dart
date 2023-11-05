import 'dart:io';

import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(final String cmd) =>
    Task(() async => Process.run('bash', ['-c', cmd], runInShell: true));

Future<bool> checkUid() => _exec(r'echo $EUID')
    .map((final res) => res.stdout.toString().trim() == '0')
    .run();

Future<int> coderes(final String cmd) =>
    _exec(cmd).map((final res) => res.exitCode).run();

Future<List<String>> codeout(final String cmd) => _exec(cmd)
    .map((final res) => [res.exitCode.toString(), res.stdout.toString()])
    .run();

Future<bool> success(final String cmd) =>
    _exec('type $cmd').map((final res) => res.exitCode == 0).run();

Future<String> sys(final String cmd) =>
    _exec(cmd).map((final res) => res.stdout.toString().trim()).run();

Future<List<String>> syssplit(final String cmd) =>
    _exec(cmd).map((final res) => res.stdout.toString().split('\n')).run();

Future<String> syswline(final String cmd) =>
    _exec(cmd).map((final res) => res.stdout.toString().split('\n')[0]).run();
