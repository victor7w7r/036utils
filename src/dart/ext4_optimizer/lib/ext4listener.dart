import 'dart:io' show exit, stdin;

import 'package:process_run/shell_run.dart';

import 'package:ext4_optimizer/index.dart';

Future<List<String>> ext4listener([String menuable = "", String echoparts = "", int language = 0]) async {

  final shell = Shell(throwOnError: false, verbose: false);

  int extCount = 0; int mountCount = 0;
  String absoluteParts = ""; List<String> extParts = [];
  List<String> parts = []; List<String> dirtyDevs = [];
  List<String> umounts = [];

  final rootProcess = await shell.run("bash -c \"df -h | sed -ne '/\\/\$/p' | cut -d ' ' -f1\"");
  final root = (rootProcess[0].stdout as String).trim();

  final verifyProcess = await shell.run("bash -c \"find /dev/disk/by-id/ | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'\"");
  final verify = (verifyProcess[0].stdout as String).split("\n");

  for (final device in verify) {
    final dirtDevProcess = await shell.runExecutableArguments("bash",["-c",'readlink "/dev/disk/by-id/$device"']);
    dirtyDevs.add((dirtDevProcess.stdout as String).split("\n")[0]);
  }

  dirtyDevs.removeWhere((e) => e == '');

  for (final dev in dirtyDevs) {
    final absPartsProcess = await shell.run("bash -c \"echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'\"");
    absoluteParts = (absPartsProcess[0].stdout as String).trim();
    if(absoluteParts != "") {
      if(absoluteParts != root) {
        final partProcess = await shell.run("bash -c \"echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'\"");
        parts.add((partProcess[0].stdout as String).split("\n")[0]);
      }
    }
  }

  for(final part in parts) {
    final typeProcess = await shell.run("bash -c \"lsblk -f /dev/$part | sed -ne '2p' | cut -d ' ' -f2\"");
    final type = (typeProcess[0].stdout as String).trim();
    if(type == "ext4") {
      extCount +=1;
      extParts.add(part);
    }
  }

  if(extCount == 0){
    clear(); printer("error", 5, language);
    if(menuable == "menu") {
      print(reader(4, language));
      stdin.readLineSync();
    } else {
      exit(1);
    }
  }

  for(final partitionsdef in extParts) {
      final mountedProcess = await shell.run("bash -c \"lsblk /dev/$partitionsdef | sed -ne '/\\//p'\"");
      final mounted = (mountedProcess[0].stdout as String).trim();
      mounted != "" ? mountCount +=1 : umounts.add("/dev/$partitionsdef");
  }

  if(mountCount == extCount) {
    clear(); printer("error", 6, language);
    if(menuable == "menu") {
      print(reader(4, language));
      stdin.readLineSync();
    } else {
      exit(1);
    }
  }

  return umounts;

}