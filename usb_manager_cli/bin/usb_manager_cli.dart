import 'dart:async' show unawaited;
import 'dart:io' show exit;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan;
import 'package:fpdart/fpdart.dart' show IO;
import 'package:usb_manager_cli/usb_manager_cli.dart';

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

void _menu() {
  print(cyan(lang(11)));
  IO(
    Chooser<String>(
      [lang(13), lang(14), lang(15), lang(16)],
      message: lang(12),
    ).chooseSync,
  ).map((final sel) {
    if (sel == lang(13)) {
      clear();
      unawaited(usblistener(Action.mount, _menu));
    } else if (sel == lang(14)) {
      clear();
      unawaited(usblistener(Action.unmount, _menu));
    } else if (sel == lang(15)) {
      clear();
      unawaited(usblistener(Action.off, _menu));
    } else if (sel == lang(16)) {
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
