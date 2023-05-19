import 'dart:async' show Timer;
import 'dart:io' show Process, ProcessResult, stdout;

import 'package:dcli/dcli.dart' show Terminal;
import 'package:fpdart/fpdart.dart' show Task;

Task<ProcessResult> _exec(
  final String cmd
) => Task(() => Process.run(
  'bash',
  ['-c', cmd],
  runInShell: true
));

void clear() =>
  Terminal().clearScreen();

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

Timer spin() {
  int cursor = 0;
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