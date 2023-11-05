import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:libadwaita/libadwaita.dart' show AdwHeaderButton;

import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/screens/manage_controller.dart';

List<Widget> header(final WidgetRef ref, final bool isDark) => [
      AdwHeaderButton(
        icon: Icon(
          isDark ? Icons.nightlight_round : Icons.light_mode_rounded,
          size: 15,
        ),
        onPressed: ref.read(themeProvider.notifier).toggle,
      ),
      AdwHeaderButton(
        icon: const Icon(Icons.book, size: 15),
        onPressed: () => ref.read(manageController.notifier).isLang =
            !ref.read(manageController.notifier).isLang,
      ),
    ];
