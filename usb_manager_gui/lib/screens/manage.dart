import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:niku/namespace.dart' as n;
import 'package:niku/niku.dart' show Niku;

import 'package:usb_manager_gui/core/dict.dart';
import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/screens/manage_controller.dart';
import 'package:usb_manager_gui/widgets/header.dart';

final class Manage extends ConsumerWidget {
  const Manage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ctl = ref.watch(manageController);
    final isDark = ref.watch(isDarkProvider);

    return AdwScaffold(
      actions: AdwActions().bitsdojo,
      start: header(ref, isDark),
      title: const Text('usb_manager'),
      body: n.Stack([
        n.IconButton(Icons.refresh)
          ..n.top = 15
          ..n.right = 20
          ..onPressed = ctl.update,
        n.Row([
          n.Row([
            Radio(
              value: 1,
              groupValue: ctl.radioGroup,
              onChanged:
                  ctl.isEnabledRadio ? (final _) => ctl.mountChange() : null,
            ),
            dict(14, ctl.isLang).n,
          ]),
          const SizedBox(width: 15),
          n.Row([
            Radio(
              value: 2,
              groupValue: ctl.radioGroup,
              onChanged:
                  ctl.isEnabledRadio ? (final _) => ctl.unmountChange() : null,
            ),
            dict(15, ctl.isLang).n,
          ]),
          const SizedBox(width: 15),
          n.Row([
            Radio(
              value: 3,
              groupValue: ctl.radioGroup,
              onChanged:
                  ctl.isEnabledRadio ? (final _) => ctl.poweroffChange() : null,
            ),
            dict(16, ctl.isLang).n,
          ]),
        ])
          ..mainCenter
          ..mt = 60,
        ctl.isLoading
            ? (Niku(
                CircularProgressIndicator(
                  color: isDark ? Colors.white : Colors.black,
                ),
              )..center)
            : Niku(
                Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Builder(
                    builder: (final ctx) {
                      if (ctl.noMountParts && ctl.radioGroup == 1) {
                        return dict(4, ctl.isLang).n
                          ..n.center
                          ..textAlign = TextAlign.center;
                      } else if (ctl.noUmountParts && ctl.radioGroup == 2) {
                        return dict(5, ctl.isLang).n
                          ..n.center
                          ..textAlign = TextAlign.center;
                      } else {
                        return n.ListView.children(
                          ctl.items
                              .map(
                                (final el) => n.ListTile()
                                  ..title = el.n
                                  ..onTap =
                                      () => ctl.requestManage(context, el),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                ),
              )
          ..center
          ..ml = 15,
        n.Image.asset("assets/${isDark ? "brandwhite" : "brand"}.png")
          ..w = 300
          ..mb = 10
          ..n.bottomCenter,
      ]),
    );
  }
}
