import 'package:flutter/material.dart';

import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:niku/namespace.dart' as n;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;
import 'package:xterm/xterm.dart';

import 'package:rsyncer_gui/config/index.dart';
import 'package:rsyncer_gui/providers/theme_provider.dart';
import 'package:rsyncer_gui/views/syncer_controller.dart';
import 'package:rsyncer_gui/utils/index.dart';
import 'package:rsyncer_gui/widgets/header.dart';

class Syncer extends StatelessWidget {

  const Syncer({super.key});

  @override
  Widget build(context) {

    final ctl = context.watch(syncerController);
    final isDark = context.watch(isDarkProvider);

    return AdwScaffold(
      actions: AdwActions().bitsdojo,
      start: header(context, isDark),
      title: const Text('rsyncer'),
      body: !ctl.syncMode ? n.Stack([
        n.Wrap([
          n.Column([
            AdwButton.pill(
              onPressed: () => dirPick().then((val) => ctl.changeSourceDir(val ?? "")),
              child: Text(dict(0, ctl.lang)),
            ),
            const SizedBox(height: 10),
            ctl.sourceDir.n
          ]),
          n.Column([
            AdwButton.pill(
              onPressed: () => dirPick().then((val) => ctl.changeDestDir(val ?? "")),
              child: Text(dict(1, ctl.lang)),
            ),
            const SizedBox(height: 10),
            ctl.destDir.n,
          ]),
        ])
          ..direction = Axis.horizontal
          ..spacing = 300
          ..n.center,
        n.Image.asset("assets/${isDark ? "brandwhite" : "brand"}.png")
          ..w = 300
          ..mt = 50
          ..n.topCenter,
        if(ctl.destDir != "" && ctl.sourceDir != "") AdwButton.pill(
          onPressed: ctl.requestSync,
          child: const Text('Sync'),
        ).niku
          ..bottom = 30
          ..right = 30
      ]): n.Stack([
        TerminalView(
          ctl.terminal,
          controller: ctl.terminalController,
          theme: TerminalThemes.whiteOnBlack,
          autofocus: true,
          backgroundOpacity: isDark ? 0.2 : 0.7,
        ).niku
          ..w = context.mediaQuerySize.width - 100
          ..h = context.mediaQuerySize.height - 200
          ..center,
        n.Row([
          if(ctl.isSyncing) AdwButton.pill(
            onPressed: ctl.cancel,
            child: Text(dict(2, ctl.lang))
          ),
          const SizedBox(width: 10),
          AdwButton.pill(
            onPressed: ctl.exitOp,
            child: Text(dict(4, ctl.lang))
          )
        ])
          ..n.bottom = 10
          ..n.right = 10
      ])
    );
  }
}