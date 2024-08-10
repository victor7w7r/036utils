import 'dart:io' show Platform, exit;

import 'package:injectable/injectable.dart' show injectable;

@injectable
class Attach {
  bool get isLinux => Platform.isLinux;

  void errorExit() => exit(1);
  void successExit() => exit(0);
}
