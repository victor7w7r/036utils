import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:nester/nester.dart' show Nester;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:rsyncer_gui/config/index.dart';
import 'package:rsyncer_gui/providers/theme_provider.dart';
import 'package:rsyncer_gui/views/syncer.dart';

void main() => setup().then((_) => runApp(
  Nester.list([
    (next) => ProviderScope(child: next),
    (next) => InheritedConsumer(child: next),
    (_) => const Rsyncer()
  ])
));

class Rsyncer extends StatelessWidget {

  const Rsyncer({super.key});

  @override
  Widget build(context) => MaterialApp(
    theme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
    debugShowCheckedModeBanner: false,
    themeMode: context.watch(themeProvider),
    home: const Syncer(),
  );
}