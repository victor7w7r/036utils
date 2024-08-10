import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/efitoggler.dart';

@injectable
class App {
  const App(this._io, this._lang, this._macosEfi);

  final InputOutput _io;
  final Lang _lang;
  final MacosEfi _macosEfi;

  Future<void> call() async {
    if (await _macosEfi.efiCheck() != '') {
      _lang.write(2, PrintQuery.normal);
      _io
        ..syncCall('sudo diskutil unmount ${await _macosEfi.checkEfiPart()}')
        ..syncCall('sudo rm -rf /Volumes/EFI');
      _lang.ok(4);
    } else {
      _lang.write(3, PrintQuery.normal);
      _io
        ..syncCall('sudo mkdir /Volumes/EFI')
        ..syncCall(
          'sudo mount -t msdos /dev/${await _macosEfi.checkEfiPart()} /Volumes/EFI',
        )
        ..syncCall('open /Volumes/EFI');
      _lang.ok(4);
    }
  }
}
