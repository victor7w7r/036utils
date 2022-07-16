import 'dart:io' show Platform, Process, exit;

import 'package:interact/interact.dart';

import 'package:efitoggler/index.dart';

void core() {
  clear(); language(); cover(); verify();
}

int _language = 0;

void language() {
  print("Bienvenido / Welcome");
  final languages = ['English', 'Espanol'];
  final selection = Select(
    prompt: 'Please, choose your language / Por favor selecciona tu idioma',
    options: languages
  ).interact();

  selection == 0 ? _language = 1 : _language = 2;
}

void verify() {
  if(!Platform.isMacOS) {
    clear(); printer("error", 0, _language);
    print("\n"); exit(1);
  }
  printer("print", 1, _language);
  spin(() {
    print(""); toggler();
  });
}

Future<void> toggler() async {

  final result1 = await Process.run("bash",[
    "-c", "diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p'"
  ]);

  if(result1.exitCode != 0) exit(1);

  final result2 = await Process.run("bash",[
    "-c","EFIPART=\$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p') MOUNTROOT=\$(df -h | sed -ne \"/\$EFIPART/p\"); echo \$MOUNTROOT"
  ]);

  if(result2.exitCode != 0) exit(1);

  final efipart = (result1.stdout as String).trim();
  final efi = (result2.stdout as String).trim();

  if(efi != "") {
    printer("print", 2, _language);

  final checkDev = await Process.run("bash", ["-c", "sudo cat < /dev/null"]);    if(checkDev.exitCode == 0) {
      await Process.run("bash", ["-c", "sudo diskutil unmount $efipart"]);
      await Process.run("bash", ["-c", "sudo rm -rf /Volumes/EFI"]);
      clear(); printer("print", 4, _language);
    } else {
      clear(); printer("error", 5, _language); exit(1);
    }
  } else {
    printer("print", 3, _language);
    final checkDev = await Process.run("bash", ["-c", "sudo cat < /dev/null"]);
    if(checkDev.exitCode == 0) {
      await Process.run("bash", ["-c", "sudo mkdir /Volumes/EFI"]);
      await Process.run("bash", ["-c", "sudo mount -t msdos /dev/$efipart /Volumes/EFI"]);
      await Process.run("bash", ["-c", "open /Volumes/EFI"]);
      clear(); printer("print", 4, _language);
    } else {
      clear(); printer("error", 5, _language); exit(1);
    }
  }
}

void main() { core(); }