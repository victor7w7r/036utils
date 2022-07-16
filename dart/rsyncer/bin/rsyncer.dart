import 'dart:io' show Directory, Platform, Process, exit, stdin, stdout;

import 'package:colorize/colorize.dart' show Colorize;
import 'package:interact/interact.dart';

import 'package:rsyncer/index.dart';

void core() {
  clear(); language(); cover(); verify();
}

int _language = 0;
String _source = "";
String _dest = "";

void printer(String typeQuery, int position, [String additional=""]) {
  List<String> dictionaryEng = [
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The rsync binary is not available in this system, please install",
		"The dialog binary is not available in this system, please install",
		"All dependencies is ok!",
    "The directory $additional doesn't exist"
		"=============== START RSYNC =============== \n" ,
		"Done!\n",
		"You don't have permissions to write the destination or read the source",
		"=============== FAIL =============== \n",
  ];

  List<String> dictionaryEsp = [
    "Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
		"EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
		"¡Todo ok!",
		"El directorio $additional no existe",
		"=============== EMPEZAR RSYNC =============== \n" ,
		"Listo!\n",
		"No tienes permisos para escribir el directorio de destino o para leer el origen",
		"=============== FALLA =============== \n",
  ];

  final info = Colorize("[+] ").green();
  final warn = Colorize("[*] ").cyan();
  final error = Colorize("[*] ").red();

  switch(typeQuery) {
    case "print":
      print(_language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]);
      break;
    case "info":
      stdout.write(info);
      print("INFO: ${
        _language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
    case "warn":
      stdout.write(warn);
      print("WARNING: ${
        _language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
    case "error":
      stdout.write(error);
      print("ERROR: ${
        _language == 1
          ? dictionaryEng[position]
          : dictionaryEsp[position]}");
      break;
  }
}

String reader(int position) {
  List<String> dictionaryEng = [
    "Please write your source directory",
    "Please write your destination directory to copy",
    "Press Enter to continue...",
  ];

	List<String> dictionaryEsp = [
    "Por favor escriba su directorio de origen",
    "Por favor escriba su directorio de destino",
    "Presione Enter para continuar...",
  ];

	if(_language == 1) {
		return dictionaryEng[position];
	} else {
		return dictionaryEsp[position];
	}
}

Future<bool> commandverify(String command) async {
    final check = await Process.run("bash", ["-c", "type $command"]);
    if(check.exitCode == 0) {
      return true;
    } else {
      return false;
    }
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

Future<void> verify() async {
  if(!Platform.isLinux) {
    clear();
    printer("error", 0);
    print("\n");
    exit(1);
  }
  final commandVef = await commandverify("rsync");
  if(!commandVef) {
    clear();
    printer("error", 2);
    print("\n");
    exit(1);
  }
  printer("print", 4);
  spin(() {
    clear();
    sourceaction();
  });
}

Future<void> validator(String typeData, String data) async {

  bool path = await Directory(data).exists();

  if(typeData == "source") {
    if((data.isNotEmpty)) {
      if(path) {
        _source = data; clear(); destiaction();
        return;
      } else {
        clear(); printer("error", 5, data);
        print("\n"); print(reader(2));
        stdin.readLineSync();
        clear(); sourceaction();
        return;
      }
    } else {
      print(""); exit(0);
    }
  } else if(typeData == "dest") {
    if(data.isEmpty) {
      if(path) {
        _dest = data; clear(); syncer();
      } else {
        clear(); printer("error", 5, data);
        print("\n"); print(reader(2));
        stdin.readLineSync();
        clear(); destiaction();
        return;
      }
    } else {
      sourceaction(); return;
    }
  } else {
      print(""); exit(0);
  }
}

void sourceaction() {
  final data = Input(prompt: reader(0)).interact();
  validator("source", data);
}

void destiaction() {
  final data = Input(prompt: reader(0)).interact();
  validator("source", data);
}

Future<void> syncer() async {
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

  clear(); printer("print", 6); print("");
  print("SOURCE:{$sourceReady}");
	print("DESTINATION:{$destReady}");
	print("");
  final syncApt = await Process.run("rsync",[
    "-axHAWXS", "--numeric-ids", "--info=progress2", sourceReady, destReady
  ]);

  if(syncApt.exitCode == 0) {
    print("\n =============== OK =============== \n");
    printer("print", 7); exit(0);
  } else {
    clear(); printer("error", 8); print("");
    print("SOURCE:{$sourceReady}");
    print("DESTINATION:{$destReady}");
    print("");
    final syncAptTwo = await Process.run("sudo",["rsync",
      "-axHAWXS", "--numeric-ids", "--info=progress2", sourceReady, destReady
    ]);
    if(syncAptTwo.exitCode == 0) {
      print("\n =============== OK =============== \n");
      printer("print", 7); exit(0);
    } else {
      printer("printer", 10); exit(1);
    }
  }
}

void main() { core(); }