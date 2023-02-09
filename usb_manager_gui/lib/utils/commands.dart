import 'dart:io' show Process;

import 'package:fpdart/fpdart.dart' show Task;

Future<bool> verifycmd(String cmd) =>
  Task(() async => Process.run("bash", ["-c", "type $cmd"]))
    .map((chk) => chk.exitCode == 0)
    .run();

Future<String> sysout(String cmd) =>
  Task(() async => Process.run("bash", ["-c", cmd], runInShell: true))
    .map((cmd) => (cmd.stdout.toString()).trim())
    .run();

Future<int> codeproc(String cmd) =>
  Task(() async => Process.run("bash", ["-c", cmd], runInShell: true))
    .map((cmd) => cmd.exitCode)
    .run();

Future<List<String>> syssplit(String cmd) =>
  Task(() async => Process.run("bash", ["-c", cmd], runInShell: true))
    .map((cmd) => cmd.stdout.toString().split("\n"))
    .run();

Future<String> sysoutwline(String cmd) =>
  Task(() async => Process.run("bash", ["-c", cmd], runInShell: true))
    .map((cmd) => cmd.stdout.toString().split("\n")[0])
    .run();

Future<List<String>> syscodeout(String cmd) =>
  Task(() async => Process.run("bash", ["-c", cmd], runInShell: true))
    .map((cmd) => [cmd.exitCode.toString(), cmd.stdout.toString()])
    .run();

Future<bool> checkUid() =>
  Task(() async => Process.run("bash", ["-c", "echo \$EUID"]))
    .map((cmd) => cmd.stdout.toString().trim() == "0")
    .run();