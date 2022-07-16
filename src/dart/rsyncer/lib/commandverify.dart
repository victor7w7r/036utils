import 'dart:io' show Process;

Future<bool> commandverify(String command) async {
    final check = await Process.run("bash", ["-c", "type $command"]);
    if(check.exitCode == 0) {
      return true;
    } else {
      return false;
    }
}