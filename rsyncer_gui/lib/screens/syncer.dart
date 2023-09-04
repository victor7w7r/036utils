import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:niku/namespace.dart' as n;
import 'package:xterm/xterm.dart';

import 'package:rsyncer_gui/core/core.dart';
import 'package:rsyncer_gui/providers/theme_provider.dart';
import 'package:rsyncer_gui/screens/syncer_controller.dart';
import 'package:rsyncer_gui/widgets/header.dart';

final class Syncer extends ConsumerWidget {

  const Syncer({super.key});

  @override
  Widget build(
    final BuildContext context,
    final WidgetRef ref
  ) {

    final ctl = ref.watch(syncerController);
    final isDark = ref.watch(isDarkProvider);

    return AdwScaffold(
      actions: AdwActions().bitsdojo,
      start: header(ref, isDark),
      title: const Text('rsyncer'),
      body: !ctl.syncMode ? n.Stack([
        n.Wrap([
          n.Column([
            AdwButton.pill(
              onPressed: () => unawaited(dirPick()
                .then((final val) => ctl.sourceDir = val ?? '')),
              child: Text(dict(0, ctl.isLang))
            ),
            const SizedBox(height: 10),
            ctl.sourceDir.n
          ]),
          n.Column([
            AdwButton.pill(
              onPressed: () => unawaited(dirPick()
                .then((final val) => ctl.destDir = val ?? '')),
              child: Text(dict(1, ctl.isLang))
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
        if(ctl.destDir != '' && ctl.sourceDir != '') AdwButton.pill(
          onPressed: ctl.requestSync,
          child: const Text('Sync'),
        ).niku
          ..bottom = 30
          ..right = 30
      ]): n.Stack([
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
          if(ctl.isSyncing) AdwButton.pill(
            onPressed: ctl.cancel,
            child: Text(dict(2, ctl.isLang))
          ),
          const SizedBox(width: 10),
          AdwButton.pill(
            onPressed: ctl.exitOp,
            child: Text(dict(4, ctl.isLang))
          )
        ])
          ..n.bottom = 10
          ..n.right = 10
      ])
    );
  }
}
