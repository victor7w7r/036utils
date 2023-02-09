import 'dart:io' show exit;

import 'package:efitoggler_gui/views/toggler_controller.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/config/dict.dart';

class MacosMenubar extends StatelessWidget {

  const MacosMenubar(this.lang, {super.key});

  final bool lang;

  @override
  Widget build(context) => PlatformMenuBar(menus: [
    PlatformMenu(
      label: 'App',
      menus: [
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: dict(10, lang),
              onSelected: context.read(themeProvider.notifier).toggle,
            ),
            PlatformMenuItem(
              label: dict(11, lang),
              onSelected: context.read(togglerController.notifier).toggleLang
            )
          ]
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: dict(12, lang),
              onSelected: () => exit(0),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyQ,
                meta: true
              )
            )
          ]
        )
      ]
    )
  ]);
}