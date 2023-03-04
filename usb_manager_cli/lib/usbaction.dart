import 'dart:io' show stdin;

import 'package:usb_manager_cli/index.dart';

void _err(bool op) {
  clear();
  lang(op ? 8 : 9, PrintQuery.error);
  print(lang(17));
  stdin.readLineSync();
  clear();
}

Future<void> usbAction(String part, bool isMount, void Function() call) async {

  clear();
  final spinAction = spin();

  final action = await syscodeout("udisksctl ${isMount ? 'mount' : 'unmount'} -b $part");
  final notAuth =
    RegExp(r'NotAuthorized*').hasMatch(action[1]) ||
      RegExp(r'NotAuthorizedDismissed*').hasMatch(action[1]);

  spinAction.cancel();

  if(action[0] == '0') {
    await dialog(lang(19), '${lang(19)}${action[1]}', '8', '80');
    clear();
    call();
  } else {
    if(notAuth) {
      _err(true);
      call();
    } else {
      _err(false);
      call();
    }
  }
}