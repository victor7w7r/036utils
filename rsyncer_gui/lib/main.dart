import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:bitsdojo_window/bitsdojo_window.dart' show appWindow, doWhenWindowReady;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:rsyncer_gui/inject/inject.dart';
import 'package:rsyncer_gui/providers/theme_provider.dart';
import 'package:rsyncer_gui/views/syncer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configInjection();

  doWhenWindowReady(() => appWindow
    ..minSize = const Size(640, 360)
    ..size = const Size(1280, 720)
    ..alignment = Alignment.center
    ..title = 'rsyncer_gui'
    ..show()
  );

  runApp(const ProviderScope(
    child: InheritedConsumer(child: Rsyncer())
  ));

}

final class Rsyncer extends StatelessWidget {

  const Rsyncer({super.key});

  @override
  Widget build(context) => MaterialApp(
    theme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
    debugShowCheckedModeBanner: false,
    themeMode: context.watch(themeProvider),
    home: const Syncer()
  );
}
