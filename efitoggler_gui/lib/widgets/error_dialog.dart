import 'package:flutter/cupertino.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:niku/namespace.dart' as n;

import 'package:efitoggler_gui/core/dict.dart';

Future<dynamic> errorDialog(
  final BuildContext context,
  final bool isLang,
  final VoidCallback onClose,
) =>
    showMacosAlertDialog(
      context: context,
      builder: (final _) => MacosAlertDialog(
        appIcon: n.Icon(CupertinoIcons.stop_circle),
        title: Text(
          'Error',
          style: MacosTheme.of(context).typography.headline,
        ),
        message: Text(
          dict(5, isLang),
          textAlign: TextAlign.center,
          style: MacosTheme.of(context).typography.headline,
        ),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            onClose();
          },
        ),
      ),
    );
