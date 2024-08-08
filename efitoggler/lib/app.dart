import 'package:efitoggler/efitoggler.dart';
import 'package:injectable/injectable.dart' show injectable;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

@injectable
class App {
  const App(this._io, this._lang, this._macosEfi);

  final InputOutput _io;
  final Lang _lang;
  final MacosEfi _macosEfi;

  Future<void> app() async {
    if (await _macosEfi.efiCheck() != '') {
      _lang.write(2, PrintQuery.normal);
      _macosEfi.checkEfiPart((final efipart) {
        _io
          ..syncCall('sudo diskutil unmount $efipart')
          ..syncCall('sudo rm -rf /Volumes/EFI');
      });
    } else {
      _lang.write(3, PrintQuery.normal);
      _macosEfi.checkEfiPart((final efipart) {
        _io
          ..syncCall('sudo mkdir /Volumes/EFI')
          ..syncCall('sudo mount -t msdos /dev/$efipart /Volumes/EFI')
          ..syncCall('open /Volumes/EFI');
      });
    }
  }
}
