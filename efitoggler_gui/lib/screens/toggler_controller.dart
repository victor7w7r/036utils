import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Task;
import 'package:macos_ui/macos_ui.dart';

import 'package:efitoggler_gui/widgets/widgets.dart';

Future<int> _checkSudo(
  final String pass
) => coderes(
  'echo $pass | sudo -S cat /dev/null'
);

Future<String> _mountChain(
  final String efipart,
  final String pass
) => Task(() => sys('echo $pass | sudo -S mkdir /Volumes/EFI'))
  .flatMap((_) => Task(() => sys('echo $pass | '
    'sudo -S mount -t msdos /dev/$efipart /Volumes/EFI')
  ))
  .flatMap((_) => Task(() => sys('open /Volumes/EFI')))
  .run();

Future<String> _umountChain(
  final String efipart,
  final String pass
) => Task(() => sys('echo $pass | sudo -S diskutil unmount $efipart'))
  .flatMap((_) => Task(() => sys('echo $pass | '
    'sudo -S rm -rf /Volumes/EFI'
  )))
  .run();

final class TogglerController
  extends ChangeNotifier {

  final String _checkEfiMountCmd;
  final String _checkEfiPartCmd;
  bool _isLoading;
  bool _isLang;

  String efipart;
  String efi;
  bool isEfi;

  TogglerController():
    _checkEfiMountCmd = 'diskutil list '
      "| sed -ne '/EFI/p' "
      r"| sed -ne 's/.*\(d.*\).*/\1/p'",
    _checkEfiPartCmd =  'EFIPART=\$(diskutil list '
      "| sed -ne '/EFI/p' "
      "| sed -ne 's/.*\\(d.*\\).*/\\1/p') "
      'MOUNTROOT=\$(df -h | sed -ne "/\$EFIPART/p");'
      'echo \$MOUNTROOT',
    efipart = '',
    efi = '',
    isEfi = false,
    _isLang = inject.get<SharedPrefsModule>().isEng,
    _isLoading = false;

  void init() => sys(_checkEfiMountCmd)
    .then((efiCheck) {
      isEfi = efiCheck != '';
      isLoading = false;
    });

  void toggle(final BuildContext context) {
    isLoading = true;
    showMacosSheet(
      context: context,
      builder: (_) => SudoDialog(isLang, (res, pass) =>
        res ? _checkSudo(pass).then((proc) => proc == 0
          ? sys(_checkEfiPartCmd).then((efiPart) {
            if(isEfi) {
              _umountChain(efiPart, pass).then((_){
                isEfi = false;
                isLoading = false;
              });
              return;
            } else {
              _mountChain(efiPart, pass).then((_){
                isEfi = true;
                isLoading = false;
              });
              return;
            }
          }) : errorDialog(
            context,
            isLang,
            () => isLoading = false
          )
        ) : isLoading = false
      )
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
    inject.get<SharedPrefsModule>()
      .prefs.setBool('lang', isLang)
      .then((_) => notifyListeners());
  }

}

final togglerController =
  ChangeNotifierProvider<TogglerController>((final _) =>
    TogglerController()..init()
  );
