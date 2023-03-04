import 'dart:io' show exit;

import 'package:dcli/dcli.dart';

import 'package:efitoggler_cli/index.dart';

Future<String> _efiPart() =>
  sysout(r"diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\(d.*\).*/\1/p'");

Future<String> _efiCheck() =>
  sysout("EFIPART=\$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p') MOUNTROOT=\$(df -h | sed -ne \"/\$EFIPART/p\"); echo \$MOUNTROOT");

void _ok() {
  clear();
  lang(4, PrintQuery.normal);
  exit(0);
}

void _err() {
  clear();
  lang(5, PrintQuery.error);
  exit(1);
}

Future<void> main() async {

  setup();
  await locator.get<App>().init();

  if(await _efiCheck() != '') {
    lang(2, PrintQuery.normal);
    codeproc('sudo cat < /dev/null').then((checkSu) {
      final spinAction = spin();
      checkSu == 0 ? _efiPart().then((efipart){
        'sudo diskutil unmount $efipart'.run;
        'sudo rm -rf /Volumes/EFI'.run;
        spinAction.cancel();
        _ok();
      }) : _err();
    });
  } else {
    lang(3, PrintQuery.normal);
    codeproc('sudo cat < /dev/null').then((checkSu) {
      final spinAction = spin();
      checkSu == 0 ? _efiPart().then((efipart){
        'sudo mkdir /Volumes/EFI'.run;
        'sudo mount -t msdos /dev/$efipart /Volumes/EFI'.run;
        'open /Volumes/EFI'.run;
          spinAction.cancel();
        _ok();
      }) : _err();
    });
  }
}