import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:macos_ui/macos_ui.dart';
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:efitoggler_gui/inject/inject.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/screens/toggler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configInjection();
  runApp(const ProviderScope(
    child: InheritedConsumer(child: EfiToggler())
  ));
}

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