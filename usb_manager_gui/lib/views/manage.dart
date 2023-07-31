import 'package:flutter/material.dart';

import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:niku/namespace.dart' as n;
import 'package:niku/niku.dart' show Niku;
import 'package:riverpod_context/riverpod_context.dart' show RiverpodContext;

import 'package:usb_manager_gui/config/dict.dart';
import 'package:usb_manager_gui/providers/theme_provider.dart';
import 'package:usb_manager_gui/views/manage_controller.dart';
import 'package:usb_manager_gui/widgets/header.dart';

final class Manage extends StatelessWidget {

  const Manage({super.key});

  @override
  Widget build(context) {

    final ctl = context.watch(manageController);
    final isDark = context.watch(isDarkProvider);

    return AdwScaffold(
      actions: AdwActions().bitsdojo,
      start: header(context, isDark),
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
              onChanged: ctl.isEnabledRadio
                ? (_) => ctl.mountChange()
                : null
            ),
            dict(14, ctl.isLang).n
          ]),
          const SizedBox(width: 15),
          n.Row([
            Radio(
              value: 2,
              groupValue: ctl.radioGroup,
              onChanged: ctl.isEnabledRadio
                ? (_) => ctl.unmountChange()
                : null
            ),
            dict(15, ctl.isLang).n
          ]),
          const SizedBox(width: 15),
          n.Row([
            Radio(
              value: 3,
              groupValue: ctl.radioGroup,
              onChanged: ctl.isEnabledRadio
                ? (_) => ctl.poweroffChange()
                : null
            ),
            dict(16, ctl.isLang).n
          ]),
        ])
          ..mainCenter
          ..mt = 60,
        ctl.isLoading ? (
          Niku(CircularProgressIndicator(
            color: isDark
              ? Colors.white
              : Colors.black
            ))
            ..center
        ) : Niku(Container(
          width: 300,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
                ? Colors.white
                : Colors.black
              ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Builder(builder: (ctx) {
            if(ctl.noMountParts && ctl.radioGroup == 1) {
              return dict(4, ctl.isLang).n
              ..n.center
              ..textAlign = TextAlign.center;
            } else if(ctl.noUmountParts && ctl.radioGroup == 2) {
              return dict(5, ctl.isLang).n
              ..n.center
              ..textAlign = TextAlign.center;
            } else {
              return n.ListView.children(
              ctl.items.map((el) => n.ListTile()
                ..title = el.n
                ..onTap = () => ctl.requestManage(context, el)
              ).toList());
            }
          }),
        ))
          ..center
          ..ml = 15,
        n.Image.asset(
          "assets/${isDark ? "brandwhite" : "brand"}.png"
        )
          ..w = 300
          ..mb = 10
          ..n.bottomCenter,
      ])
    );
  }
}
