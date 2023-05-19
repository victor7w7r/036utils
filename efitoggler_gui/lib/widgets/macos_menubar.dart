import 'dart:io' show exit;

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:efitoggler_gui/config/dict.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/screens/toggler_controller.dart';

final class MacosMenubar extends StatelessWidget {

  final bool lang;

  const MacosMenubar(
    this.lang, {super.key}
  );

  @override
  Widget build(context) => PlatformMenuBar(menus: [
    PlatformMenu(
      label: 'App',
      menus: [
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: dict(10, lang),
              onSelected: context.read(themeProvider.notifier)
                .toggle,
            ),
            PlatformMenuItem(
              label: dict(11, lang),
              onSelected: () => context
                .read(togglerController.notifier)
                .isLang = !context
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