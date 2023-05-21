import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:bitsdojo_window/bitsdojo_window.dart' show appWindow, doWhenWindowReady;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:ext4_optimizer_gui/inject/inject.dart';
import 'package:ext4_optimizer_gui/providers/theme_provider.dart';
import 'package:ext4_optimizer_gui/views/optimize.dart';

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
    child: InheritedConsumer(child: ExtOptimizer())
  ));

}

class ExtOptimizer extends StatelessWidget {

  const ExtOptimizer({super.key});

  @override
  Widget build(context) => MaterialApp(
    theme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
    debugShowCheckedModeBanner: false,
    themeMode: context.watch(themeProvider),
    home: const Optimize()
  );
}