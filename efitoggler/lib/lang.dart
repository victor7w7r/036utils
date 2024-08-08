import 'package:injectable/injectable.dart' show injectable;

import 'package:zerothreesix_dart/zerothreesix_dart.dart' show Lang;

@injectable
class InitLang {
  const InitLang(this._lang);

  final Lang _lang;

  void init() {
    _lang.dictEng.addAll([
      'Your Operating System is not macOS, exiting',
      'All dependencies is ok!',
      'EFI Folder is mounted, unmounting',
      'EFI Folder is not mounted, mounting',
      'Done!',
      'Sudo auth fails',
    ]);

    _lang.dictEsp.addAll([
      'Tu sistema operativo no es macOS, saliendo',
      '¡Todo ok!',
      'La carpeta EFI esta montada, desmontando',
      'La carpeta EFI no esta montada, montando',
      '¡Listo!',
      'Autenticación con sudo falló',
    ]);
  }
}
