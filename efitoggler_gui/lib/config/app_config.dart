import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:fpdart/fpdart.dart' show FpdartOnNullable;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

@singleton
class AppConfig {

  late final SharedPreferences prefs;
  ThemeMode theme = ThemeMode.light;
  bool isEng = true;

  @FactoryMethod(preResolve: true)
  static Future<AppConfig> init() async {

    WidgetsFlutterBinding.ensureInitialized();

    final config = AppConfig()
      ..prefs = await SharedPreferences.getInstance();

    config.prefs.getBool('dark').toOption().fold(
      () => config.prefs.setBool('dark', true)
        .then((_) => config.theme = ThemeMode.dark),
      (dark) => config.theme = dark
        ? ThemeMode.dark
        : ThemeMode.light
    );

    config.prefs.getBool('lang').toOption().fold(
      () => config.prefs.setBool('lang', true)
        .then((_) => config.isEng = true),
      (lang) => config.isEng = lang
    );

    return config;
  }
}