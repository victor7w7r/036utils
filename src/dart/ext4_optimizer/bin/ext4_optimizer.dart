import 'dart:io' show Platform, exit, stdin;

import 'package:process_run/shell_run.dart';

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

void verify() async {
  if(!Platform.isLinux) {
    clear(); printer("error", 0, _language); exit(1);
  }
  final commandVef1 = await commandverify("e4defrag");
  if(!commandVef1) {
    clear(); printer("error", 2, _language); exit(1);
  }
  final commandVef2 = await commandverify("fsck.ext4");
  if(!commandVef2) {
    clear(); printer("error", 3, _language); exit(1);
  }
  printer("print", 4, _language);
  ext4listener(_language);
  spin(() {
    clear();
    menu();
  });
}

void menu() {
  final selection = Select(
    prompt: reader(0, _language),
    options: [reader(1, _language), reader(2, _language)]
  ).interact();
  clear();
  if(selection == 0) {
    clear(); defragmenu();
  } else {
    clear(); exit(0);
  }
}

void defragmenu() async {
  List<String> optionable = await ext4listener(_language, "menu","print");
  optionable.add(reader(6, _language));
  final selection = Select(
    prompt: reader(0, _language),
    options: optionable
  ).interact();
  clear();
  if(optionable[selection] == reader(6, _language)) {
    clear(); menu();
  } else {
    defragction(optionable[selection]);
  }
}

void defragction(String part) async {

  final shellNoVerb = Shell(throwOnError: false, verbose: false);
  final shell = Shell(throwOnError: false, verbose: true);

  clear(); if (part == "") return;
  printer("print", 7, _language);

  final sudoRequest = await shellNoVerb.runExecutableArguments("bash",["-c","sudo cat < /dev/null"]);
  if(sudoRequest.exitCode == 0) {

    final repairRequest = await shell.runExecutableArguments("bash",["-c","sudo fsck.ext4 -y -f -v $part"]);
    if(repairRequest.exitCode != 8) {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear();
    } else {
      printer("print", 8, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear(); menu(); return;
    }

    printer("print", 10, _language);

    final optimizeRequest = await shell.runExecutableArguments("bash",["-c","sudo fsck.ext4 -y -f -v -D $part"]);
    if(optimizeRequest.exitCode != 8) {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear();
    } else {
      printer("print", 8, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear(); menu(); return;
    }

    await shellNoVerb.runExecutableArguments("bash",["-c","mkdir /tmp/optimize 2> /dev/null"]);
    await shellNoVerb.runExecutableArguments("bash",["-c","sudo mount $part /tmp/optimize"]);

    printer("print", 11, _language);
    await shell.runExecutableArguments("bash",["-c","sudo e4defrag -v $part"]);
    print("");
    await shellNoVerb.runExecutableArguments("bash",["-c","sudo umount $part"]);
    printer("print", 9, _language);
    print(reader(4, _language));
    stdin.readLineSync();
    clear();

    printer("print", 12, _language);

    final repairRequestFinal = await shell.runExecutableArguments("bash",["-c","sudo fsck.ext4 -y -f -v $part"]);
    if(repairRequestFinal.exitCode != 8) {
      printer("print", 9, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear(); menu(); return;
    } else {
      printer("print", 8, _language);
      print(reader(4, _language));
      stdin.readLineSync();
      clear(); menu(); return;
    }

  } else {
    clear(); printer("print", 8, _language);
    print(reader(4, _language));
    stdin.readLineSync();
    clear(); menu(); return;
  }
}

void main() { core(); }