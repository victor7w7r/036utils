import 'package:flutter/material.dart';

import 'package:libadwaita/libadwaita.dart' show AdwHeaderButton;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:ext4_optimizer_gui/providers/theme_provider.dart';
import 'package:ext4_optimizer_gui/views/optimize_controller.dart';

List<Widget> header(BuildContext context, bool isDark) => [
  AdwHeaderButton(
    icon: Icon(
      isDark ? Icons.nightlight_round : Icons.light_mode_rounded,
      size: 15,
    ),
    onPressed: context.read(themeProvider.notifier).toggle,
  ),
  AdwHeaderButton(
    icon: const Icon(Icons.book, size: 15),
    onPressed: context.read(optimizeController.notifier).toggleLang,
  )
];