import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:efitoggler_gui/config/index.dart';

class ThemeNotifier extends Notifier<ThemeMode> {

  @override
  ThemeMode build() => locator.get<AppConfig>().theme;

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    !isDark ? state = ThemeMode.dark : state = ThemeMode.light;
    await locator.get<AppConfig>().prefs.setBool('dark', !isDark);
  }

}

final themeProvider =
  NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

final isDarkProvider = Provider<bool>((ref) =>
  ref.watch(themeProvider) == ThemeMode.dark
);