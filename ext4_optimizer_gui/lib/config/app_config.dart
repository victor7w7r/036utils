import 'package:bitsdojo_window/bitsdojo_window.dart' show appWindow, doWhenWindowReady;
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show FpdartOnNullable, Task;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

@singleton
class AppConfig {

  late final SharedPreferences prefs;
  ThemeMode theme = ThemeMode.light;
  bool isEng = true;
  String tempPath = "";

  @FactoryMethod(preResolve: true)
  static Future<AppConfig> init() async {

    WidgetsFlutterBinding.ensureInitialized();

    final config = AppConfig()
      ..prefs = await SharedPreferences.getInstance()
      ..tempPath = await const Task(getTemporaryDirectory)
        .map((dir) => dir.path)
        .run();

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

    doWhenWindowReady(() => appWindow
      ..minSize = const Size(640, 360)
      ..size = const Size(1280, 720)
      ..alignment = Alignment.center
      ..title = "rsyncer_gui"
      ..show()
    );

    return config;
  }
}