import 'dart:async' show unawaited;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rsyncer_gui/core/prefs_module.dart';

final class ThemeNotifier
  extends Notifier<ThemeMode> {

  @override
  ThemeMode build() =>
    ref.read(prefsModule).theme;

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    !isDark
      ? state = ThemeMode.dark
      : state = ThemeMode.light;
    unawaited(ref.read(sharedPrefs)
      .setBool('dark', !isDark));
  }

}

final themeProvider =
  NotifierProvider<ThemeNotifier, ThemeMode>(
    ThemeNotifier.new
  );

final isDarkProvider = Provider<bool>((final ref) =>
  ref.watch(themeProvider) == ThemeMode.dark
);
