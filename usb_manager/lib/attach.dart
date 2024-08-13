// coverage:ignore-file

import 'dart:io';

import 'package:cli_menu/cli_menu.dart' show Menu;
import 'package:injectable/injectable.dart' show injectable;

@injectable
class Attach {
  bool get isLinux => Platform.isLinux;

  String chooser(
    final List<String> opts,
  ) =>
      Menu(opts).choose().value;

  String readSync() => stdin.readLineSync() ?? '';
  void successExit() => exit(0);

  Future<ProcessResult> udisks2() => Process.run(
        'bash',
        ['-c', 'systemctl is-active udisks2'],
        runInShell: true,
      );
}
