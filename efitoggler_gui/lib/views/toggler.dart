import 'package:flutter/cupertino.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:niku/namespace.dart' as n;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:efitoggler_gui/config/index.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/views/toggler_controller.dart';
import 'package:efitoggler_gui/widgets/macos_menubar.dart';

class Toggler extends StatelessWidget {

  const Toggler({super.key});

  @override
  Widget build(context) {

    final ctl = context.watch(togglerController);
    final isDark = context.watch(isDarkProvider);

    return n.Stack([
      MacosMenubar(ctl.lang),
      MacosWindow(
        child: !ctl.loading ? n.Stack([
          n.Row([
            dict(0, ctl.lang).n,
            MacosSwitch(
              value: isDark,
              onChanged: (_) =>
                context.read(themeProvider.notifier).toggle()
            )
          ])
            ..n.top = 10
            ..n.right = 10,
          'EFI Toggler'.n
            ..freezed
            ..fontSize = 30
            ..n.topCenter
            ..mt = 80,
          n.Row([
            dict(2, ctl.lang).n,
            MacosSwitch(
              value: ctl.isEfi,
              onChanged: (_) => ctl.toggle(context)
            ),
            dict(1, ctl.lang).n,
          ])
            ..mainCenter
            ..n.center,
          n.Image.asset("assets/${isDark ? "brandwhite" : "brand"}.png")
            ..w = 300
            ..n.left = 20
            ..n.bottom = 10,
          n.Row([
            dict(4, ctl.lang).n,
            MacosSwitch(
              value: ctl.lang,
              onChanged: (_) => ctl.toggleLang()
            ),
            dict(3, ctl.lang).n,
          ])
            ..n.bottom = 15
            ..n.right = 20
        ]) : const ProgressCircle(value: null)
      )
    ]);
  }
}