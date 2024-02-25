import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

final class PrefsModule {
  PrefsModule(this._prefs)
      : _darkKey = 'dark',
        _langKey = 'lang',
        theme = ThemeMode.light,
        isEng = true;

  final String _darkKey;
  final String _langKey;
  final SharedPreferences _prefs;
  ThemeMode theme;
  bool isEng;

  void init() => chain(
        () => _prefs.getBool(_darkKey).letWithElseCall(
              (final darkValue) =>
                  theme = darkValue ? ThemeMode.dark : ThemeMode.light,
              () => unawaited(_prefs.setBool(_darkKey, true)),
            ),
        () => _prefs.getBool(_langKey).letWithElseCall(
              (final langValue) => isEng = langValue,
              () => unawaited(_prefs.setBool(_langKey, true)),
            ),
      );
}

final sharedPrefs =
    Provider<SharedPreferences>((final _) => throw UnimplementedError());

final prefsModule =
    Provider((final ref) => PrefsModule(ref.watch(sharedPrefs))..init());
