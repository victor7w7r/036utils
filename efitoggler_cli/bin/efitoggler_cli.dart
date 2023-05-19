import 'package:dcli/dcli.dart';

import 'package:efitoggler_cli/efitoggler_cli.dart';

Future<String> _efiPart() => sys(
  'diskutil list '
  "| sed -ne '/EFI/p' "
  r"| sed -ne 's/.*\(d.*\).*/\1/p'"
);

Future<String> _efiCheck() => sys(
  'EFIPART=\$(diskutil list '
  "| sed -ne '/EFI/p' "
  "| sed -ne 's/.*\\(d.*\\).*/\\1/p') "
  'MOUNTROOT=\$(df -h | sed -ne "/\$EFIPART/p");'
  'echo \$MOUNTROOT'
);

void _checkEfiPart(
  final void Function(String) call
) => coderes('sudo cat < /dev/null').then((checkSu) {
  final spinAction = spin();
  checkSu == 0 ? _efiPart().then((efipart){
    call(efipart);
    spinAction.cancel();
    ok(4);
  }) : error(5);
});

void main() async {

  init();

  if(await _efiCheck() != '') {
    lang(2, PrintQuery.normal);
    _checkEfiPart((efipart){
      'sudo diskutil unmount $efipart'.run;
      'sudo rm -rf /Volumes/EFI'.run;
    });
  } else {
    lang(3, PrintQuery.normal);
    _checkEfiPart((efipart){
      'sudo mkdir /Volumes/EFI'.run;
      'sudo mount -t msdos /dev/$efipart /Volumes/EFI'.run;
      'open /Volumes/EFI'.run;
    });
  }
}