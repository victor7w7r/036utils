import 'dart:io' show exit, stdin;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan;
import 'package:fpdart/fpdart.dart' show IO, Task;

import 'package:usb_manager_cli/index.dart';

Future<bool> _usbCheck() =>
  Task(() => sysout("find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'"))
  .map((res) => res == "")
  .run();

Future<List<String>> _usbPhysicalDevs() =>
  syssplit("find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'");

Future<String> _dirtyDev(String dev) =>
  sysoutwline('readlink "/dev/disk/by-id/$dev"');

Future<String> _absoluteDev(String dev) =>
  sysout("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'");

Future<String> _partsDev(String dev) =>
  sysoutwline("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'");

Future<String> _blocksDev(String dev) =>
  sysoutwline("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///'");

Future<String> _mountCheck(String part) =>
  sysout("lsblk /dev/$part | sed -ne '/\\//p'");

enum Action { mount , unmount, off }

void _err(bool op) {
  clear();
  lang(op ? 7 : 8, PrintQuery.error);
  print(lang(17));
  stdin.readLineSync();
  clear();
}

Future<void> usblistener(Action action, void Function() call) async {

  final parts = <String>[];
  final block = <String>[];
  final mounts = <String>[];
  final unmounts = <String>[];
  final args = <String>[];
  final argspoweroff = <String>[];
  final dirtyDevs = <String>[];

  int count = 0;
  int mountCount = 0;
  int unmountCount = 0;

  clear();

  final spinAction = spin();

  _usbCheck().then((val){
    if(val) {
      clear();
      lang(6, PrintQuery.error);
      exit(1);
    }
  });

  for (final dev in await _usbPhysicalDevs()) {
    dirtyDevs.add(await _dirtyDev(dev));
  }

  dirtyDevs.removeWhere((e) => e == '');

  for (final dev in dirtyDevs) {
    if(await _absoluteDev(dev) != "") {
      parts.add(await _partsDev(dev));
      count++;
    } else {
      block.add(await _blocksDev(dev));
    }
  }

  for(final part in parts){
    if(await _mountCheck(part) != "") {
      unmountCount++;
      mounts.add(part);
    } else {
      mountCount++;
      unmounts.add(part);
    }
  }

  if(action == Action.mount && unmountCount == count) {
    _err(true);
    call();
    return;
  } else if(action == Action.unmount && mountCount == count) {
    _err(false);
    call();
    return;
  }

  for(final part in action == Action.mount ? unmounts : mounts) {
    args.add("/dev/$part");
  }

  for(final part in block) {
    if(action == Action.off) argspoweroff.add("/dev/$part");
  }

  action == Action.off
    ? argspoweroff.add(lang(25))
    : args.add(lang(25));

  if(action == Action.mount) {
    print(cyan(lang(18)));
  } else if(action == Action.unmount) {
    print(cyan(lang(20)));
  } else {
    print(cyan(lang(21)));
  }

  spinAction.cancel();

  IO(Chooser<String>(
    action == Action.off ? argspoweroff : args,
    message: lang(12)).chooseSync
  )
    .map((sel){
      if(sel == lang(25)) {
        clear();
        call();
        return;
      } else {
        clear();
        switch(action) {
          case Action.mount:
            usbAction(sel, true, call);
            break;
          case Action.unmount:
            usbAction(sel, false, call);
            break;
          case Action.off:
            powerOff(sel, call);
            break;
        }
      }
    })
    .run();
}