import 'dart:io' show Platform;

import 'package:injectable/injectable.dart' show injectable;

@injectable
class Attach {
  bool get isLinux => Platform.isLinux;
}
