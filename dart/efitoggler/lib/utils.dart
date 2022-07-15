import 'dart:async' show Timer;
import 'dart:io';

void clear() {
  print(Process.runSync("clear", [], runInShell: true).stdout);
}

void spin(Function ready) {
  const charSet = ['|', '/', '-', '\\'];
  int cursor = 0;
  Timer.periodic(Duration(milliseconds: 100), (timer) {
    stdout.write('\r${charSet[cursor]}');
    cursor++;
    if(cursor == 4) cursor = 0;
    if(timer.tick == 16) {
      timer.cancel();
      ready();
    }
  });
}