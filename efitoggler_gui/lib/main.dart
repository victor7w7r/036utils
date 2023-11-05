import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'package:efitoggler_gui/core/prefs_module.dart';
import 'package:efitoggler_gui/providers/theme_provider.dart';
import 'package:efitoggler_gui/screens/toggler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefs.overrideWithValue(await SharedPreferences.getInstance()),
      ],
      child: const EfiToggler(),
    ),
  );
}

class EfiToggler extends ConsumerWidget {
  const EfiToggler({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => MacosApp(
        title: 'EfiToggler',
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: ref.watch(themeProvider),
        debugShowCheckedModeBanner: false,
        home: const Toggler(),
      );
}
