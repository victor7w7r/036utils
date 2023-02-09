import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:nester/nester.dart' show Nester;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:usb_manager_gui/config/index.dart';
import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/views/manage.dart';

void main() => setup().then((_) => runApp(
  Nester.list([
    (next) => ProviderScope(child: next),
    (next) => InheritedConsumer(child: next),
    (_) => const UsbManager()
  ])
));

class UsbManager extends StatelessWidget {

  const UsbManager({super.key});

  @override
  Widget build(context) => MaterialApp(
    theme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
    debugShowCheckedModeBanner: false,
    themeMode: context.watch(themeProvider),
    home: const Manage(),
  );
}