import 'dart:async' show unawaited;

import 'package:dcli/dcli.dart' show StringAsProcess;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler_cli/efitoggler_cli.dart';

void _checkEfiPart(
  final void Function(String) call,
) =>
    unawaited(
      coderes('sudo cat < /dev/null').then((final checkSu) {
        final spinAction = spin();
        checkSu == 0
            ? efiPart().then((final efipart) {
                call(efipart);
                spinAction.cancel();
                ok(4);
              })
            : error(5);
      }),
    );

void main() async {
  init();

  if (await efiCheck() != '') {
    lang(2, PrintQuery.normal);
    _checkEfiPart((final efipart) {
      'sudo diskutil unmount $efipart'.run;
      'sudo rm -rf /Volumes/EFI'.run;
    });
  } else {
    lang(3, PrintQuery.normal);
    _checkEfiPart((final efipart) {
      'sudo mkdir /Volumes/EFI'.run;
      'sudo mount -t msdos /dev/$efipart /Volumes/EFI'.run;
      'open /Volumes/EFI'.run;
    });
  }
}
