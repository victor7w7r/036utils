import 'dart:async' show unawaited;

import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Task;
import 'package:macos_ui/macos_ui.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'package:efitoggler_gui/core/prefs_module.dart';
import 'package:efitoggler_gui/core/system.dart';
import 'package:efitoggler_gui/widgets/widgets.dart';

Future<int> _checkSudo(final String pass) =>
    call('echo $pass | sudo -S cat /dev/null');

Future<String> _mountChain(final String efipart, final String pass) =>
    Task(() => sys('echo $pass | sudo -S mkdir /Volumes/EFI'))
        .flatMap(
          (final _) => Task(
            () => sys('echo $pass | '
                'sudo -S mount -t msdos /dev/$efipart /Volumes/EFI'),
          ),
        )
        .flatMap((final _) => Task(() => sys('open /Volumes/EFI')))
        .run();

Future<String> _umountChain(final String efipart, final String pass) =>
    Task(() => sys('echo $pass | sudo -S diskutil unmount $efipart'))
        .flatMap(
          (final _) => Task(
            () => sys('echo $pass | '
                'sudo -S rm -rf /Volumes/EFI'),
          ),
        )
        .run();

final class TogglerController extends ChangeNotifier {
  TogglerController(this._prefs, this._prefsMod)
      : _isLang = _prefsMod.isEng,
        _isLoading = false,
        _checkEfiMountCmd = 'diskutil list '
            "| sed -ne '/EFI/p' "
            r"| sed -ne 's/.*\(d.*\).*/\1/p'",
        _checkEfiPartCmd = r'EFIPART=$(diskutil list '
            "| sed -ne '/EFI/p' "
            r"| sed -ne 's/.*\(d.*\).*/\1/p') "
            r'MOUNTROOT=$(df -h | sed -ne "/$EFIPART/p"); '
            r'echo $MOUNTROOT',
        efipart = '',
        efi = '',
        isEfi = false;

  final SharedPreferences _prefs;
  // ignore: unused_field
  final PrefsModule _prefsMod;
  final String _checkEfiMountCmd;
  final String _checkEfiPartCmd;
  bool _isLoading;
  bool _isLang;

  String efipart;
  String efi;
  bool isEfi;

  void init() => unawaited(
        sys(_checkEfiPartCmd).then((final efiCheck) {
          isEfi = efiCheck != '';
          isLoading = false;
        }),
      );

  void toggle(final BuildContext context) {
    isLoading = true;
    unawaited(
      showMacosSheet<dynamic>(
        context: context,
        builder: (final _) => SudoDialog(
          isLang,
          (final res, final pass) => res
              ? _checkSudo(pass).then(
                  (final proc) => proc == 0
                      ? sys(_checkEfiMountCmd).then((final efiPart) {
                          if (isEfi) {
                            _umountChain(efiPart, pass).then((final _) {
                              isEfi = false;
                              isLoading = false;
                            });
                            return;
                          } else {
                            _mountChain(efiPart, pass).then((final _) {
                              isEfi = true;
                              isLoading = false;
                            });
                            return;
                          }
                        })
                      : errorDialog(context, isLang, () => isLoading = false),
                )
              : isLoading = false,
        ),
      ),
    );
  }

  bool get isLoading => _isLoading;

  set isLoading(final bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    unawaited(
      _prefs.setBool('lang', isLang).then((final _) => notifyListeners()),
    );
  }
}

final togglerController = ChangeNotifierProvider<TogglerController>(
  (final ref) =>
      TogglerController(ref.watch(sharedPrefs), ref.watch(prefsModule))..init(),
);
