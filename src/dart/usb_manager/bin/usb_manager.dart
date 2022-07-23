import 'dart:io' show Platform, exit, stdin;

import 'package:process_run/shell_run.dart';

import 'package:interact/interact.dart';

import 'package:usb_manager/index.dart';

int _language = 0;

void core() async {
  clear(); language(); cover(); verify();
}

void language() {
  print("Bienvenido / Welcome");
  final languages = ['English', 'Espanol'];
  final selection = Select(
    prompt: 'Please, choose your language / Por favor selecciona tu idioma',
    options: languages
  ).interact();

  selection == 0 ? _language = 1 : _language = 2;
}

void usbverify() async {

  final shell = Shell(throwOnError: false, verbose: false);
  final verifyUsbProcess = await shell.run("bash -c \"find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'\"");
  final verifyUsb = (verifyUsbProcess[0].stdout as String).trim();

  if(verifyUsb == "") {
    clear();
    printer("error", 6, _language);
    exit(1);
  }
}

void verify() async {
  if(!Platform.isLinux) {
    clear(); printer("error", 0, _language);
    exit(1);
  }
  final commandVef1 = await commandverify("whiptail");
  if(!commandVef1) {
    clear(); printer("error", 3, _language);
      exit(1);
  }
  final commandVef2 = await commandverify("udisksctl");
  if(!commandVef2) {
    clear(); printer("error", 2, _language);
      exit(1);
  }

  final shell = Shell(throwOnError: false, verbose: false);
  final serviceProcess = await shell.run("bash -c \"systemctl is-active udisks2\"");
  final service = (serviceProcess[0].stdout as String).trim();

  if(service == "inactive"){
    clear(); printer("error", 4, _language);
    exit(1);
  }

  usbverify();
  printer("print", 5, _language);

  spin(() {
    clear();
    menu();
  });
}

void menu() {
  final selection = Select(
    prompt: reader(0, _language),
    options: [
      reader(1, _language), reader(2, _language),
      reader(3, _language), reader(4, _language)
    ]
  ).interact();
  clear();
  switch (selection) {
    case 0:
      clear(); usblistener("mount");
      break;
    case 1:
      clear(); usblistener("unmount");
      break;
    case 2:
      clear(); usblistener("off");
      break;
    case 3:
      clear(); exit(0);
    default:
      clear(); exit(0);
  }
}

void usblistener(String selector) async {

  clear(); usbverify();

  final shell = Shell(throwOnError: false, verbose: false);

  int count = 0; List<String> parts = []; List<String> block = [];
  List<int> flags = []; List<String> mounts = []; List<String> usb = [];
  List<String> unmounts = []; List<String> args = []; List<String> argspoweroff = [];
  int mountCount = 0; int unmountCount = 0;
  int flagsCount = 0; List<String> dirtyDevs = [];

  final usbProcess = await shell.run("bash -c \"find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'\"");
  usb = (usbProcess[0].stdout as String).split("\n");

  for (final device in usb) {
    final dirtDevProcess = await shell.runExecutableArguments("bash",["-c",'readlink "/dev/disk/by-id/$device"']);
    dirtyDevs.add((dirtDevProcess.stdout as String).split("\n")[0]);
  }

  dirtyDevs.removeWhere((e) => e == '');

  for (final dev in dirtyDevs) {
    final absPartsProcess = await shell.run("bash -c \"echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'\"");
    String absoluteParts = (absPartsProcess[0].stdout as String).trim();
    if(absoluteParts != "") {
      final partsProcess = await shell.run("bash -c \"echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'\"");
      parts.add((partsProcess[0].stdout as String).split('\n')[0]);
      count++;
    } else {
      final blockProcess = await shell.run("bash -c \"echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///'\"");
      block.add((blockProcess[0].stdout as String).split('\n')[0]);
      flags.add(count);
    }
  }

  for(final partitions in parts){
    final mountedProcess = await shell.run("bash -c \"lsblk /dev/$partitions | sed -ne '/\\//p'\"");
    String mounted = (mountedProcess[0].stdout as String).trim();
    if(mounted != "") {
      unmountCount++;
      mounts.add(partitions);
    } else {
      mountCount++;
      unmounts.add(partitions);
    }
  }

  if(selector == "mount") {
    if(unmountCount == count) {
      clear(); printer("error", 7, _language);
      print(reader(5, _language));
      stdin.readLineSync(); clear(); menu();
      return;
    }

    count = 0;

    for(final part in unmounts) {
      final device = "/dev/$part";
      final temp = flags[flagsCount];
      if(count == temp) flagsCount++;
      args.add(device); count++;
    }

    args.add(reader(16, _language));

    final selection = Select(
      prompt: reader(6, _language),
      options: args
    ).interact();
    clear();

    if(args[selection] == reader(16, _language)) {
      clear(); menu();
    } else {
      clear(); mountAction(args[selection]);
    }

  } else if (selector == "unmount") {

    if(mountCount == count) {
      clear(); printer("error", 10, _language);
      print(reader(5, _language));
      stdin.readLineSync(); clear(); menu();
      return;
    }

    count = 0;

    for(final part in mounts) {
      final device = "/dev/$part";
      final temp = flags[flagsCount];
      if(count == temp) flagsCount++;
      args.add(device); count++;
    }

    args.add(reader(16, _language));

    final selection = Select(
      prompt: reader(9, _language),
      options: args
    ).interact();
    clear();

    if(args[selection] == reader(16, _language)) {
      clear(); menu();
    } else {
      clear(); unMountAction(args[selection]);
    }

  } else if(selector == "off") {

    if(mountCount == count) {
      clear(); printer("error", 10, _language);
      print(reader(5, _language));
      stdin.readLineSync(); clear(); menu();
      return;
    }

    count = 0;

    for(final part in block) {
      final device = "/dev/$part";
      argspoweroff.add(device);
      count++;
    }

    argspoweroff.add(reader(16, _language));

    final selection = Select(
      prompt: reader(11, _language),
      options: argspoweroff
    ).interact();
    clear();

    if(argspoweroff[selection] == reader(16, _language)) {
      clear(); menu();
    } else {
      clear(); powerOffAction(argspoweroff[selection]);
    }
  }
}

void mountAction(String part) async {

  final shell = Shell(throwOnError: false, verbose: false);

  clear();
  if(part == "") return;

  final mountActionProcess = await shell.run("bash -c \"udisksctl mount -b $part\"");
  if(mountActionProcess[0].exitCode == 0) {
    print(mountActionProcess[0].stdout);
    await dialog(reader(8, _language), '${reader(8, _language)}${mountActionProcess[0].stdout}', '7', '60');
    clear();
    menu();
  } else {
    final reg1 = RegExp(r'NotAuthorized*');
    final reg2 = RegExp(r'NotAuthorizedDismissed*');
    final reg3 = RegExp(r'AlreadyMounted*');
    if(reg1.hasMatch(mountActionProcess[0].stdout)) {
      clear();
      printer("error", 8, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    } else if(reg2.hasMatch(mountActionProcess[0].stdout)) {
      clear();
      printer("error", 8, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    } else if(reg3.hasMatch(mountActionProcess[0].stdout)) {
      clear();
      printer("error", 9, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    }
  }
}

void unMountAction(String part) async {

  final shell = Shell(throwOnError: false, verbose: false);

  clear();
  if(part == "") return;

  final unMountActionProcess = await shell.run("bash -c \"udisksctl unmount -b $part \"");
  if(unMountActionProcess[0].exitCode == 0) {
    await dialog(reader(8, _language), '${reader(8, _language)}${unMountActionProcess[0].stdout}', '7', '60');
    clear();
    menu();
  } else {
    final reg1 = RegExp(r'NotAuthorized*');
    final reg2 = RegExp(r'NotAuthorizedDismissed*');
    final reg3 = RegExp(r'AlreadyMounted*');
    if(reg1.hasMatch(unMountActionProcess[0].stdout)) {
      clear();
      printer("error", 8, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    } else if(reg2.hasMatch(unMountActionProcess[0].stdout)) {
      clear();
      printer("error", 8, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    } else if(reg3.hasMatch(unMountActionProcess[0].stdout)) {
      clear();
      printer("error", 9, _language);
      print(reader(5, _language));
      stdin.readLineSync();
      clear(); menu();
    }
  }
}

void powerOffAction(String part) async {

  final shell = Shell(throwOnError: false, verbose: false);
  clear();
  if(part == "") return;

  final blockTempProcess = await shell.run("bash -c \"echo $part | cut -d \"/\" -f3\"");
  String blockTemp = (blockTempProcess[0].stdout as String).trim();

  final partitionsProcess =  await shell.run("bash -c \"find /dev -name \"$blockTemp[[:digit:]]\" | sort -n | sed 's/^\\/dev\\///' \"");
  List<String>partitions = (partitionsProcess[0].stdout as String).split("\n");

  partitions.removeWhere((e) => e == '');

  for(final partition in partitions) {
    final unMountActionProcess = await shell.run("bash -c \"udisksctl unmount -b /dev/$partition &> /dev/null \"");
    if(unMountActionProcess[0].exitCode == 0) {
      print("");
    } else {
      if(_language == 1) {
        await dialog('ERROR', 'FAIL: Error unmounting /dev/$partition please check or check if you have the right permissions', '7', '60');
        clear();
        menu();
        return;
      } else {
        await dialog('ERROR', 'ERROR: Hubo un error desmontando /dev/$partition por favor revisar o mira si tienes permisos', '7', '60');
        clear();
        menu();
        return;
      }
    }
  }

  final modelProcess = await shell.run("bash -c \"cat /sys/class/block/$blockTemp/device/model\"");
  String model = (modelProcess[0].stdout as String).trim();

  final powerOffProcess = await shell.run("bash -c \"udisksctl power-off -b $part \"");
  if(powerOffProcess[0].exitCode == 0) {
    if(_language == 1) {
      await dialog('SUCCESS', 'SUCCESS: Your device $model was succesfully power-off', '7', '60');
      clear();
      menu();
      return;
    } else {
      await dialog('LISTO', 'LISTO: Tu dispositivo $model se ha apagado exitosamente', '7', '60');
      clear();
      menu();
      return;
    }
  } else {
    if(_language == 1) {
      await dialog('FAIL', 'FAIL: Power-off is not available on this device, please check or check if you have permissions', '7', '60');
      clear();
      menu();
      return;
    } else {
      await dialog('ERROR', 'ERROR: no está disponible el apagar este dispositivo, por favor revisar o mira si tienes permisos', '7', '60');
      clear();
      menu();
      return;
    }
  }
}

void main() {core();}