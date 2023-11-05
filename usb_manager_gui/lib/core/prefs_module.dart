import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

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

  void init() {
    final darkValue = _prefs.getBool(_darkKey);
    final langValue = _prefs.getBool(_langKey);

    darkValue == null
        ? unawaited(_prefs.setBool(_darkKey, false))
        : theme = darkValue ? ThemeMode.dark : ThemeMode.light;

    langValue == null
        ? unawaited(_prefs.setBool(_langKey, true))
        : isEng = langValue;
  }
}

final sharedPrefs =
    Provider<SharedPreferences>((final _) => throw UnimplementedError());

final prefsModule =
    Provider((final ref) => PrefsModule(ref.watch(sharedPrefs))..init());
