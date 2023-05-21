import 'package:flutter/material.dart';

import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:niku/namespace.dart' as n;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;
import 'package:xterm/xterm.dart';

import 'package:ext4_optimizer_gui/config/config.dart';
import 'package:ext4_optimizer_gui/providers/theme_provider.dart';
import 'package:ext4_optimizer_gui/views/optimize_controller.dart';
import 'package:ext4_optimizer_gui/widgets/header.dart';

final class Optimize extends StatelessWidget {

  const Optimize({super.key});

  @override
  Widget build(context) {

    final ctl = context.watch(optimizeController);
    final isDark = context.watch(isDarkProvider);

    return AdwScaffold(
      actions: AdwActions().bitsdojo,
      start: header(context, isDark),
      title: const Text('ext4_optimizer'),
      body: !ctl.opMode ? n.Stack([
        dict(5, ctl.isLang).n
          ..n.topCenter
          ..fontSize = 20
          ..mt = 30,
        Container(
          width: 300,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
              ? Colors.white
              : Colors.black
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: n.ListView.children(
            ctl.parts.map((el) => n.ListTile()
              ..title = el.n
              ..onTap = () => ctl.requestOptimize(el)
            ).toList()
          )
        ).niku
          ..center
          ..ml = 50,
        n.Image.asset(
          "assets/${isDark ? "brandwhite" : "brand"}.png"
        )
          ..w = 300
          ..mb = 10
          ..n.bottomCenter,
      ]) : n.Stack([
        if(ctl.ready) dict(11, ctl.isLang).n
          ..n.topCenter
          ..fontSize = 20
          ..mt = 20,
        if(ctl.isLoading) const CircularProgressIndicator(
          color: Colors.white
        ).niku
          ..center,
        TerminalView(
          ctl.terminal,
          controller: ctl.terminalCtrl,
          theme: TerminalThemes.whiteOnBlack,
          autofocus: true,
          backgroundOpacity: isDark ? 0.2 : 0.7,
        ).niku
          ..w = context.mWidth - 100
          ..h = context.mHeight - 200
          ..center,
        n.Row([
          if(ctl.isOptimize) AdwButton.pill(
            onPressed: ctl.cancel,
            child: Text(dict(8, ctl.isLang))
          ),
          const SizedBox(width: 10),
          AdwButton.pill(
            onPressed: ctl.exitOp,
            child: Text(dict(9, ctl.isLang))
          )
        ])
          ..n.bottom = 10
          ..n.right = 10
      ])
    );
  }
}