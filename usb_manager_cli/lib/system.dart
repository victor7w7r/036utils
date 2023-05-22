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

Task<Process> _sysExec(
  final String cmd
) => Task(() async => waitForEx(
  Process.start(
    'bash',
    ['-c', cmd],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio
  )));

Future<bool> success(
  final String cmd
) => _exec('type $cmd')
  .map((res) => res.exitCode == 0)
  .run();

Future<int> coderes(
  final String cmd
) => _sysExec(cmd)
  .flatMap((res) => Task(() => res.exitCode))
  .run();

Future<List<String>> codeout(
  final String cmd
) => _exec(cmd)
  .map((res) => [
    res.exitCode.toString(),
    res.stdout.toString()
  ])
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

Future<int> dialog(
  final String title,
  final String body,
  final String height,
  final String width
) async {
  final dialogBox = waitForEx(Process.start(
    'bash',
    ['-c',"whiptail --title '$title' --msgbox "
      "'$body' '$height' '$width'"
    ],
    mode: ProcessStartMode.inheritStdio
  ));
  try {
    await dialogBox.stdout.pipe(stdout);
    await stdin.pipe(dialogBox.stdin);
    return dialogBox.exitCode;
  } on StateError catch(_) {
    return dialogBox.exitCode;
  }
}

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