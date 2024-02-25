import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:bitsdojo_window/bitsdojo_window.dart'
    show appWindow, doWhenWindowReady;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'package:rsyncer_gui/core/prefs_module.dart';
import 'package:rsyncer_gui/providers/theme_provider.dart';
import 'package:rsyncer_gui/screens/syncer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  doWhenWindowReady(
    () => appWindow
      ..minSize = const Size(640, 360)
      ..size = const Size(1280, 720)
      ..alignment = Alignment.center
      ..title = 'rsyncer_gui'
      ..show(),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefs.overrideWithValue(await SharedPreferences.getInstance()),
      ],
      child: const Rsyncer(),
    ),
  );
}

final class Rsyncer extends ConsumerWidget {
  const Rsyncer({super.key});

  @override
  Widget build(
    final BuildContext context,
    final WidgetRef ref,
  ) =>
      MaterialApp(
        theme: AdwaitaThemeData.light(),
        darkTheme: AdwaitaThemeData.dark(),
        debugShowCheckedModeBanner: false,
        themeMode: ref.watch(themeProvider),
        home: const Syncer(),
      );
}
