import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Task;
import 'package:macos_ui/macos_ui.dart';

import 'package:efitoggler_gui/config/index.dart';
import 'package:efitoggler_gui/utils/commands.dart';
import 'package:efitoggler_gui/widgets/index.dart';

class TogglerController extends ChangeNotifier {

  String efipart = '';
  String efi = '';
  bool lang = locator.get<AppConfig>().isEng;
  bool loading = false;
  bool isEfi = false;

  final checkEfiPartCmd =
    r"diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\(d.*\).*/\1/p'";
  final checkEfiMountCmd =
    "EFIPART=\$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p') MOUNTROOT=\$(df -h | sed -ne \"/\$EFIPART/p\"); echo \$MOUNTROOT";

  Future<int> checkSudo(String pass) => codeproc('echo $pass | sudo -S cat /dev/null');

  Future<String> umountChain(String efipart, String pass) =>
    Task(() => sysout('echo $pass | sudo -S diskutil unmount $efipart'))
      .flatMap((_) => Task(() => sysout('echo $pass | sudo -S rm -rf /Volumes/EFI')))
      .run();

  Future<String> mountChain(String efipart, String pass) =>
    Task(() => sysout('echo $pass | sudo -S mkdir /Volumes/EFI'))
      .flatMap((_) => Task(() => sysout('echo $pass | sudo -S mount -t msdos /dev/$efipart /Volumes/EFI')))
      .flatMap((_) => Task(() => sysout('open /Volumes/EFI')))
      .run();

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void init() => sysout(checkEfiMountCmd).then((efiCheck) {
    isEfi = efiCheck != '';
    setLoading(false);
  });

  Future<void> toggleLang() async {
    lang = !lang;
    await locator.get<AppConfig>().prefs.setBool('lang', lang);
    notifyListeners();
  }

  void toggle(BuildContext context) {
    setLoading(true);
    showMacosSheet(
      context: context,
      builder: (_) => SudoDialog(lang, (res, pass) =>
        res ? checkSudo(pass).then((proc) => proc == 0
          ? sysout(checkEfiPartCmd).then((efiPart) {
            if(isEfi) {
              umountChain(efiPart, pass).then((_){
                isEfi = false;
                setLoading(false);
              });
              return;
            } else {
              mountChain(efiPart, pass).then((_){
                isEfi = true;
                setLoading(false);
              });
              return;
            }
          }) : errorDialog(context, lang, () => setLoading(false))
        ) : setLoading(false)
      )
    );
  }
}

final togglerController =
  ChangeNotifierProvider<TogglerController>((_) =>
    TogglerController()..init()
  );