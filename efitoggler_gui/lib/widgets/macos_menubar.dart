import 'dart:io' show exit;

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:efitoggler_gui/core/dict.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/screens/toggler_controller.dart';

final class MacosMenubar extends ConsumerWidget {

  const MacosMenubar(
    this.lang, {super.key}
  );

  final bool lang;

  @override
  Widget build(
    final BuildContext context,
    final WidgetRef ref
  ) => PlatformMenuBar(menus: [
    PlatformMenu(
      label: 'App',
      menus: [
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: dict(10, lang),
              onSelected: ref.read(themeProvider.notifier)
                .toggle,
            ),
            PlatformMenuItem(
              label: dict(11, lang),
              onSelected: () => ref
                .read(togglerController.notifier)
                .isLang = !ref
                  .read(togglerController.notifier).isLang
            )
          ]
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: dict(12, lang),
              onSelected: () => exit(0),
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyQ,
                meta: true
              )
            )
          ]
        )
      ]
    )
  ]);
}
