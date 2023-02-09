import 'package:flutter/cupertino.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:niku/namespace.dart' as n;

import 'package:efitoggler_gui/config/index.dart';

Future<dynamic> errorDialog(
  BuildContext context,
  bool lang,
  VoidCallback onClose
) => showMacosAlertDialog(
  context: context,
  builder: (_) => MacosAlertDialog(
    appIcon: n.Icon(CupertinoIcons.stop_circle),
    title: Text(
      'Error',
      style: MacosTheme.of(context).typography.headline
    ),
    message: Text(
      dict(5, lang),
      textAlign: TextAlign.center,
      style: MacosTheme.of(context).typography.headline
    ),
    primaryButton: PushButton(
      buttonSize: ButtonSize.large,
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context);
        onClose();
      }
    )
  )
);