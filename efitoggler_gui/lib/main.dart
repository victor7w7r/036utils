import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:macos_ui/macos_ui.dart';
import 'package:nester/nester.dart' show Nester;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:efitoggler_gui/config/locator.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/views/toggler.dart';

void main() => setup().then((_) => runApp(
  Nester.list([
    (next) => ProviderScope(child: next),
    (next) => InheritedConsumer(child: next),
    (_) => const EfiToggler()
  ])
));

class EfiToggler extends StatelessWidget {

  const EfiToggler({super.key});

  @override
  Widget build(context) => MacosApp(
    title: 'EfiToggler',
    theme: MacosThemeData.light(),
    darkTheme: MacosThemeData.dark(),
    themeMode: context.watch(themeProvider),
    debugShowCheckedModeBanner: false,
    home: const Toggler(),
  );
}