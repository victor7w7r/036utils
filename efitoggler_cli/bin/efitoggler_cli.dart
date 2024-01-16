import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler_cli/efitoggler_cli.dart';


void main() async {
  init();

  if (await efiCheck() != '') {
    lang(2, PrintQuery.normal);
    checkEfiPart((final efipart) {
      syncCall('sudo diskutil unmount $efipart');
      syncCall('sudo rm -rf /Volumes/EFI');
    });
  } else {
    lang(3, PrintQuery.normal);
    checkEfiPart((final efipart) {
      syncCall('sudo mkdir /Volumes/EFI');
      syncCall('sudo mount -t msdos /dev/$efipart /Volumes/EFI');
      syncCall('open /Volumes/EFI');
    });
  }
}
