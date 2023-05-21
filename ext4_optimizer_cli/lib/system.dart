import 'dart:async' show Timer;
import 'dart:io';

import 'package:dcli/dcli.dart' show Terminal, waitForEx;
import 'package:fpdart/fpdart.dart' show Task;

void clear() =>
  Terminal().clearScreen();

Task<ProcessResult> _exec(
  final String cmd
) => Task(() => Process.run(
  'bash',
  ['-c', cmd],
  runInShell: true
));

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

Timer spin() {
  var cursor = 0;
  return Timer.periodic(
    Duration(milliseconds: 100),
    (t) {
      stdout.write(
        "\r${['|', '/', '-', '\\'][cursor]}"
      );
      cursor++;
      if(cursor == 4) cursor = 0;
    }
  );
}