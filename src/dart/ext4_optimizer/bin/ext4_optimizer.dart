import 'dart:io' show Platform, Process, exit, stdin;

import 'package:interact/interact.dart';

import 'package:ext4_optimizer/index.dart';

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

Future<void> verify() async {
  if(!Platform.isLinux) {
    clear(); printer("error", 0, _language);
    print(""); exit(1);
  }
  final commandVef1 = await commandverify("e4defrag");
  if(!commandVef1) {
    clear(); printer("error", 2, _language);
    print(""); exit(1);
  }
  final commandVef2 = await commandverify("fsck.ext4");
  if(!commandVef2) {
    clear(); printer("error", 3, _language);
    print(""); exit(1);
  }
  ext4listener(); printer("print", 5, _language);
  spin(() {
    clear();
    menu();
  });
}

Future<List<String>> ext4listener([String menuable = "", String echoparts = ""]) async {

  int count = 0; int extCount = 0; int mountCount = 0;
  String absoluteParts = ""; List<String> extParts = [];
  List<String> parts = []; List<String> dirtyDevs = [];
  List<String> umounts = [];

  final rootProcess = await Process.run("bash",["-c",r"df -h | sed -ne '/\/$/p' | cut -d" " -f1"]);
  final root = (rootProcess.stdout as String).split("\n");

  final verifyProcess = await Process.run("bash",["-c",r"find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///'"]);
  final verify = (verifyProcess.stdout as String).split("\n");

  for (final device in verify) {
    final dirtDevProcess = await Process.run("bash",["-c",'readlink "/dev/disk/by-id/$device"']);
    dirtyDevs.add((dirtDevProcess.stdout as String).split("\n")[0]);
  }

  dirtyDevs.removeWhere((e) => e == '');

  for (final dev in dirtyDevs) {
    final absPartsProcess = await Process.run("bash",["-c","echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"]);
    absoluteParts = (absPartsProcess.stdout as String).trim();

    if(absoluteParts != "") {
      if(absoluteParts != root) {
        final partProcess = await Process.run("bash",["-c","echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"]);
        parts.add((partProcess.stdout as String).split("\n")[0]);
        count += 1;
      }
    }
  }

  for(final part in parts) {
    final typeProcess = await Process.run("bash",["-c",'lsblk -f /dev/$part | sed -ne \'2p\' | cut -d " " -f2']);
    final type = (typeProcess.stdout as String).trim();
    if(type == "ext4") extCount +=1; extParts.add(part);
  }

  if(extCount == 0 ){
    clear(); printer("error", 6, _language);
    if(menuable == "menu") {
      print(reader(4, _language));
      stdin.readLineSync();
    } else {
      exit(1);
    }
  }

  for(final partitionsdef in extParts) {
      final mountedProcess = await Process.run("bash",["-c","lsblk /dev/{PARTITIONSDEF} | sed -ne '/\\//p'"]);
      final mounted = (mountedProcess.stdout as String).trim();
      mounted != "" ? mountCount +=1 : umounts.add("/dev/$partitionsdef");
  }

  if(mountCount == extCount) {
    clear(); printer("error", 7, _language);
    if(menuable == "menu") {
      print(reader(4, _language));
      stdin.readLineSync();
    } else {
      exit(1);
    }
  }

  return umounts;

}

void menu() {
  final selection = Select(
    prompt: reader(0, _language),
    options: [reader(1, _language), reader(2, _language)]
  ).interact();
  clear();
  if(selection ==0) {
    clear(); defragmenu();
  } else {
    clear(); exit(0);
  }
}

Future<void> defragmenu() async {
  List<String> optionable = await ext4listener("menu","print");
  final selection = Select(
    prompt: reader(0, _language),
    options: optionable
  ).interact();
  clear();
  defragction(optionable[selection]);

}

Future<void> defragction(String part) async {

  clear(); if (part == "") return;
  printer("print", 8, _language);

  final sudoRequest = await Process.run("bash",["-c","sudo cat < /dev/null"]);
  if(sudoRequest.exitCode == 0) {

    final repairRequest = await Process.run("bash",["-c","sudo fsck.ext4 -y -f -v $part"]);
    if(repairRequest.exitCode != 8) {
      printer("print", 10, _language);
      print(reader(4, _language));
      clear();
    } else {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      menu(); return;
    }

    printer("print", 11, _language);

    final optimizeRequest = await Process.run("bash",["-c","sudo fsck.ext4 -y -f -v -D $part"]);
    if(optimizeRequest.exitCode != 8) {
      printer("print", 10, _language);
      print(reader(4, _language));
      clear();
    } else {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      menu(); return;
    }

    await Process.run("bash",["-c","mkdir /tmp/optimize 2> /dev/null"]);
    await Process.run("bash",["-c","sudo mount $part /tmp/optimize"]);

    printer("print", 12, _language);
    await Process.run("bash",["-c","sudo e4defrag -v $part"]);
    print("");
    await Process.run("bash",["-c","sudo umount $part"]);
    printer("print", 10, _language);
    print(reader(4, _language));
    clear();

    printer("print", 13, _language);

    final repairRequestFinal = await Process.run("bash",["-c","sudo fsck.ext4 -y -f -v $part"]);
    if(repairRequestFinal.exitCode != 8) {
      printer("print", 10, _language);
      print(reader(4, _language));
      clear();
    } else {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      menu(); return;
    }

  } else {
    clear(); printer("print", 9, _language);
    print(reader(4, _language));
    stdin.readLineSync();
    menu(); return;
  }

}

void main() {core(); }