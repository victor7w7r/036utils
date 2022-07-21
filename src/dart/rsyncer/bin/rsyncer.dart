import 'dart:io' show Directory, Platform, exit, stdin;

import 'package:process_run/shell_run.dart';

import 'package:interact/interact.dart';

import 'package:rsyncer/index.dart';

void core() {
  clear(); language(); cover(); verify();
}

int _language = 0;
String _source = "";
String _dest = "";

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
    clear();
    printer("error", 0, _language);
    print("\n");
    exit(1);
  }
  final commandVef = await commandverify("rsync");
  if(!commandVef) {
    clear();
    printer("error", 2, _language);
    print("\n");
    exit(1);
  }
  printer("print", 3, _language);
  spin(() {
    clear();
    sourceaction();
  });
}

void validator(String typeData, String data) async {

  bool path = await Directory(data).exists();

  if(typeData == "source") {
    if((data.isNotEmpty)) {
      if(path) {
        _source = data; clear(); destiaction();
        return;
      } else {
        clear(); printer("error", 4, _language, data);
        print(reader(2, _language));
        stdin.readLineSync();
        clear(); sourceaction();
        return;
      }
    } else {
      clear(); exit(0);
    }
  } else if(typeData == "dest") {
    if(data.isNotEmpty) {
      if(path) {
        _dest = data; clear(); syncer();
      } else {
        clear(); printer("error", 4, _language, data);
        print(reader(2, _language));
        stdin.readLineSync();
        clear(); destiaction();
        return;
      }
    } else {
      sourceaction(); return;
    }
  } else {
    clear(); exit(0);
  }
}

void sourceaction() {
  final data = Input(prompt: reader(0, _language)).interact();
  validator("source", data);
}

void destiaction() {
  final data = Input(prompt: reader(1, _language)).interact();
  validator("dest", data);
}

void syncer() {

  final shell = Shell(throwOnError: false, verbose: false);

  String sourceReady = "";
  String destReady = "";

  final reg = RegExp(r'.*\/$');

  if(reg.hasMatch(_source)) {
    sourceReady = _source;
  } else {
    sourceReady = "$_source/";
  }
  if(reg.hasMatch(_dest)) {
    destReady = _dest;
  } else {
    destReady = "$_dest/";
  }

  clear(); printer("print", 5, _language);
  print("SOURCE:{$sourceReady}");
	print("DESTINATION:{$destReady}");
	print("");
  shell.runExecutableArguments("rsync",[
    "-axHAWXS", "--numeric-ids", "--info=progress2", sourceReady, destReady
  ]).then((syncApt) {
    if(syncApt.exitCode == 0) {
      print("\n =============== OK =============== \n");
      printer("print", 6, _language); exit(0);
    } else {
      clear(); printer("print", 7, _language);
      print("SOURCE:{$sourceReady}");
      print("DESTINATION:{$destReady}");
      print("");
      shell.runExecutableArguments("sudo",["rsync",
        "-axHAWXS", "--numeric-ids", "--info=progress2", sourceReady, destReady
      ]).then((syncAptTwo) {
        if(syncAptTwo.exitCode == 0) {
          print("\n =============== OK =============== \n");
          printer("print", _language, 6); exit(0);
        } else {
          printer("print", _language, 8); exit(1);
        }
      });
    }
  });
}

void main() { core(); }