import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:niku/namespace.dart' as n;

import 'package:efitoggler_gui/core/dict.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/screens/toggler_controller.dart';
import 'package:efitoggler_gui/widgets/macos_menubar.dart';

final class Toggler extends ConsumerWidget {
  const Toggler({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ctl = ref.watch(togglerController);
    final isDark = ref.watch(isDarkProvider);

    return n.Stack([
      MacosMenubar(ctl.isLang),
      MacosWindow(
        child: !ctl.isLoading
            ? n.Stack([
                n.Row([
                  dict(0, ctl.isLang).n..mr = 10,
                  MacosSwitch(
                    value: isDark,
                    onChanged: (final _) async =>
                        ref.read(themeProvider.notifier).toggle(),
                  ),
                ])
                  ..n.top = 10
                  ..n.right = 10,
                'EFI Toggler'.n
                  ..freezed
                  ..fontSize = 30
                  ..n.topCenter
                  ..mt = 80,
                n.Row([
                  dict(2, ctl.isLang).n..mr = 10,
                  MacosSwitch(
                    value: ctl.isEfi,
                    onChanged: (final _) => ctl.toggle(context),
                  ),
                  dict(1, ctl.isLang).n..ml = 10,
                ])
                  ..mainCenter
                  ..n.center,
                n.Image.asset("assets/${isDark ? "brandwhite" : "brand"}.png")
                  ..w = 300
                  ..n.left = 20
                  ..n.bottom = 10,
                n.Row([
                  dict(4, ctl.isLang).n..mr = 10,
                  MacosSwitch(
                    value: ctl.isLang,
                    onChanged: (final _) => ctl.isLang = !ctl.isLang,
                  ),
                  dict(3, ctl.isLang).n..ml = 10,
                ])
                  ..n.bottom = 15
                  ..n.right = 20,
              ])
            : const ProgressCircle(),
      ),
    ]);
  }
}
