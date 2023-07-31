import 'package:flutter/material.dart';

import 'package:libadwaita/libadwaita.dart' show AdwHeaderButton;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/views/manage_controller.dart';

List<Widget> header(
  final BuildContext context,
  final bool isDark
) => [
  AdwHeaderButton(
    icon: Icon(
      isDark
        ? Icons.nightlight_round
        : Icons.light_mode_rounded,
      size: 15,
    ),
    onPressed: context.read(themeProvider.notifier).toggle,
  ),
  AdwHeaderButton(
    icon: const Icon(Icons.book, size: 15),
    onPressed: () => context
      .read(manageController.notifier)
      .isLang = !context
        .read(manageController.notifier).isLang
  )
];
