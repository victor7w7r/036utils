import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ext4_optimizer_gui/config/sharedprefs_module.dart';
import 'package:ext4_optimizer_gui/inject/inject.dart';

final class ThemeNotifier extends Notifier<ThemeMode> {

  @override
  ThemeMode build() =>
    inject.get<SharedPrefsModule>().theme;

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    !isDark
      ? state = ThemeMode.dark
      : state = ThemeMode.light;
    await inject.get<SharedPrefsModule>()
      .prefs.setBool('dark', !isDark);
  }

}

final themeProvider =
  NotifierProvider<ThemeNotifier, ThemeMode>(
    ThemeNotifier.new
  );

final isDarkProvider = Provider<bool>((ref) =>
  ref.watch(themeProvider) == ThemeMode.dark
);
