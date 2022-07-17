import 'dart:io' show exit, stdin;

import 'package:process_run/shell_run.dart';

import 'package:ext4_optimizer/index.dart';

Future<List<String>> ext4listener([String menuable = "", String echoparts = "", int language = 0]) async {

  final shell = Shell();

  int count = 0; int extCount = 0; int mountCount = 0;
  String absoluteParts = ""; List<String> extParts = [];
  List<String> parts = []; List<String> dirtyDevs = [];
  List<String> umounts = [];

  final rootProcess = await shell.runExecutableArguments("bash",["-c",r"df -h | sed -ne '/\/$/p' | cut -d " " -f1"]);
  print(rootProcess.exitCode);
  stdin.readByteSync();
  final root = (rootProcess.stdout as String);

  final verifyProcess = await shell.runExecutableArguments("bash",["-c",r"find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///'"]);
  final verify = (verifyProcess.stdout as String).split("\n");

  for (final device in verify) {
    final dirtDevProcess = await shell.runExecutableArguments("bash",["-c",'readlink "/dev/disk/by-id/$device"']);
    dirtyDevs.add((dirtDevProcess.stdout as String).split("\n")[0]);
  }

  dirtyDevs.removeWhere((e) => e == '');

  for (final dev in dirtyDevs) {
    final absPartsProcess = await shell.runExecutableArguments("bash",["-c","echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"]);
    absoluteParts = (absPartsProcess.stdout as String).trim();
    if(absoluteParts != "") {
      if(absoluteParts != root) {
        final partProcess = await shell.runExecutableArguments("bash",["-c","echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"]);
        parts.add((partProcess.stdout as String).split("\n")[0]);
        count += 1;
      }
    }
  }

  for(final part in parts) {
    final typeProcess = await shell.runExecutableArguments("bash",["-c",'lsblk -f /dev/$part | sed -ne \'2p\' | cut -d " " -f2']);
    final type = (typeProcess.stdout as String).trim();
    if(type == "ext4") extCount +=1; extParts.add(part);
  }

  if(extCount == 0 ){
    clear(); printer("error", 5, language);
    if(menuable == "menu") {
      print(reader(4, language));
      stdin.readLineSync();
    } else {
      exit(1);
    }
  }

  for(final partitionsdef in extParts) {
      final mountedProcess = await shell.runExecutableArguments("bash",["-c","lsblk /dev/{PARTITIONSDEF} | sed -ne '/\\//p'"]);
      final mounted = (mountedProcess.stdout as String).trim();
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