import 'package:flutter/material.dart';

import 'package:adwaita/adwaita.dart' show AdwaitaThemeData;
import 'package:bitsdojo_window/bitsdojo_window.dart' show appWindow, doWhenWindowReady;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:riverpod_context/riverpod_context.dart' show InheritedConsumer, RiverpodContext;

import 'package:usb_manager_gui/inject/inject.dart';
import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/views/manage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configInjection();

  doWhenWindowReady(() => appWindow
    ..minSize = const Size(640, 360)
    ..size = const Size(1280, 720)
    ..alignment = Alignment.center
    ..title = 'usb_manager_gui'
    ..show()
  );

  runApp(const ProviderScope(
    child: InheritedConsumer(child: UsbManager())
  ));

}

final class UsbManager extends StatelessWidget {

  const UsbManager({super.key});

  @override
  Widget build(context) => MaterialApp(
    theme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
    debugShowCheckedModeBanner: false,
    themeMode: context.watch(themeProvider),
    home: const Manage()
  );
}
