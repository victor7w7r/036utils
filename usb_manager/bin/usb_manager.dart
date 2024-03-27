import 'dart:async' show unawaited;
import 'dart:io' show exit;

import 'package:cli_menu/cli_menu.dart' show Menu;
import 'package:fpdart/fpdart.dart' show IO;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

void _menu() {
  cyan(lang(11));
  IO(
    Menu([lang(13), lang(14), lang(15), lang(16)]).choose,
  ).map((final op) {
    if (op.value == lang(13)) {
      clear();
      unawaited(usblistener(Action.mount, _menu));
    } else if (op.value == lang(14)) {
      clear();
      unawaited(usblistener(Action.unmount, _menu));
    } else if (op.value == lang(15)) {
      clear();
      unawaited(usblistener(Action.off, _menu));
    } else if (op.value == lang(16)) {
      clear();
      exit(0);
    }
  }).run();
}

void main() async {
  await init();
  clear();
  _menu();
}
