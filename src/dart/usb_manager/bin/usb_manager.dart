import 'dart:io' show Platform, exit, stdin;

import 'package:process_run/shell_run.dart';

import 'package:interact/interact.dart';

import 'package:usb_manager/index.dart';

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
    clear(); printer("error", 0, _language);
    print(""); exit(1);
  }
  final commandVef1 = await commandverify("whiptail");
  if(!commandVef1) {
    clear(); printer("error", 3, _language);
    print(""); exit(1);
  }
  final commandVef2 = await commandverify("udisksctl");
  if(!commandVef2) {
    clear(); printer("error", 2, _language);
    print(""); exit(1);
  }
  //
  printer("print", 4, _language);
  //ext4listener();
  spin(() {
    clear();
    menu();
  });
}

void menu() {
  if(!Platform.isLinux) {
    clear(); printer("error", 0, _language);
    print(""); exit(1);
  }
}