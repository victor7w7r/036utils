import 'package:console/console.dart' show Console;
import 'package:dcli/dcli.dart' show cyan, red;

import 'package:efitoggler_cli/app.dart';

enum PrintQuery { normal, inline, warn, error }

String lang(int index, [PrintQuery? typeQuery]) {

  final app = locator.get<App>();

  const dictEsp = [
    "Tu sistema operativo no es macOS, saliendo",
		"¡Todo ok!",
		"La carpeta EFI esta montada, desmontando",
		"La carpeta EFI no esta montada, montando",
		"¡Listo!",
		"Autenticación con sudo falló"
  ];

  const dictEng = [
    "Your Operating System is not macOS, exiting",
		"All dependencies is ok!",
		"EFI Folder is mounted, unmounting",
		"EFI Folder is not mounted, mounting",
		"Done!",
		"Sudo auth fails"
  ];

  if(typeQuery == null) {
    return app.english ? dictEng[index] : dictEsp[index];
  } else {
    switch(typeQuery) {
      case PrintQuery.normal:
        print(app.english ? dictEng[index] : dictEsp[index]);
        return "";
      case PrintQuery.inline:
        Console.write(app.english ? dictEng[index] : dictEsp[index]);
        return "";
      case PrintQuery.warn:
        Console.write(cyan("[*] "));
        print("WARNING: ${app.english ? dictEng[index] : dictEsp[index]}");
        return "";
      case PrintQuery.error:
        Console.write(red("[*] "));
        print("ERROR: ${app.english ? dictEng[index] : dictEsp[index]}");
        return "";
    }
  }
}