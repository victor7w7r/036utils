import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart' show PostConstruct, injectable;
import 'package:fpdart/fpdart.dart' show FpdartOnNullable;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

@injectable
final class SharedPrefsModule {

  var isEng = true;
  late final SharedPreferences prefs;
  ThemeMode theme = ThemeMode.light;

  @PostConstruct(preResolve: true)
  Future<void> init() async {

    prefs = await SharedPreferences.getInstance();

    prefs.getBool('dark').toOption().fold(
      () => prefs.setBool('dark', true)
        .then((_) => theme = ThemeMode.dark),
      (dark) => theme = dark
        ? ThemeMode.dark
        : ThemeMode.light
    );

    prefs.getBool('lang').toOption().fold(
      () => prefs.setBool('lang', true)
        .then((_) => isEng = true),
      (lang) => isEng = lang
    );
  }
}