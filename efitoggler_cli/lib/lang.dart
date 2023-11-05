import 'package:zerothreesix_dart/zerothreesix_dart.dart'
    show setDictEng, setDictEsp;

void initLang() {
  setDictEsp([
    'Tu sistema operativo no es macOS, saliendo',
    '¡Todo ok!',
    'La carpeta EFI esta montada, desmontando',
    'La carpeta EFI no esta montada, montando',
    '¡Listo!',
    'Autenticación con sudo falló',
  ]);
  setDictEng([
    'Your Operating System is not macOS, exiting',
    'All dependencies is ok!',
    'EFI Folder is mounted, unmounting',
    'EFI Folder is not mounted, mounting',
    'Done!',
    'Sudo auth fails',
  ]);
}
