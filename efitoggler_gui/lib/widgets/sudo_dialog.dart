import 'package:flutter/cupertino.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:niku/namespace.dart' as n;

import 'package:efitoggler_gui/config/dict.dart';

class SudoDialog extends StatelessWidget {

  SudoDialog(this.lang, this.onConfirm, {super.key});

  final void Function(bool, String) onConfirm;
  final bool lang;
  final ctl = TextEditingController();

  @override
  Widget build(context) => MacosSheet(
    insetPadding: const EdgeInsets.all(230),
    child: n.Stack([
      n.Column([
        dict(6, lang).n,
        const SizedBox(height: 10),
        MacosTextField(
          placeholder: dict(7, lang),
          controller: ctl,
          obscureText: true,
        ).niku..w = 300
      ])
        ..mb = 30
        ..mainCenter
        ..n.center,
      n.Row([
        PushButton(
          buttonSize: ButtonSize.large,
          onPressed: () {
            Navigator.pop(context);
            onConfirm(true, ctl.text);
          },
          child: Text(dict(8, lang)),
        ),
        const SizedBox(width: 10),
        PushButton(
          buttonSize: ButtonSize.large,
          onPressed: () {
            Navigator.pop(context);
            onConfirm(false, '');
          },
          child: Text(dict(9, lang)),
        )
      ])
        ..n.right = 20
        ..n.bottom = 20
    ])
  );
}