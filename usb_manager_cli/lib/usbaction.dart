import 'dart:io' show stdin;

import 'package:usb_manager_cli/usb_manager_cli.dart';

void _err(final bool op) {
  clear();
  lang(op ? 8 : 9, PrintQuery.error);
  print(lang(17));
  stdin.readLineSync();
  clear();
}

void usbAction(
  final String part,
  final bool isMount,
  final void Function() call
) async {

  clear();
  final spinAction = spin();

  final [code, out] = await codeout(
    "udisksctl ${isMount ? 'mount' : 'unmount'} -b $part"
  );

  final notAuth =
    RegExp(r'NotAuthorized*').hasMatch(out) ||
      RegExp(r'NotAuthorizedDismissed*').hasMatch(out);

  spinAction.cancel();

  if(code == '0') {
    await dialog(
      lang(19),
      '${lang(19)}$out', '8', '80'
    );
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