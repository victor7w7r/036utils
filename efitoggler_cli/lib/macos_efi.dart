import 'dart:async' show unawaited;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

void checkEfiPart(
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

Future<String> efiPart() => sys('diskutil list '
    "| sed -ne '/EFI/p' "
    r"| sed -ne 's/.*\(d.*\).*/\1/p' "
    "| sed -ne '1p'"
  );

Future<String> efiCheck() => sys(r'EFIPART=$(diskutil list '
    "| sed -ne '/EFI/p' "
    r"| sed -ne 's/.*\(d.*\).*/\1/p' "
    "| sed -ne '1p') "
    r'MOUNTROOT=$(df -h | sed -ne "/$EFIPART/p"); '
    r'echo $MOUNTROOT');
