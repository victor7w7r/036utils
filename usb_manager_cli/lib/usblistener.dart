import 'dart:io' show stdin;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan;
import 'package:fpdart/fpdart.dart' show IO, Task;

import 'package:usb_manager_cli/usb_manager_cli.dart';

Future<bool> _usbCheck() =>
  Task(() => sys(
    "find /dev/disk/by-id/ -name 'usb*' "
    '| sort -n '
    "| sed 's/^\\/dev\\/disk\\/by-id\\///'"
  ))
  .map((res) => res == '')
  .run();

Future<List<String>> _usbPhysicalDevs() =>
  syssplit(
    "find /dev/disk/by-id/ -name 'usb*' "
    '| sort -n '
    "| sed 's/^\\/dev\\/disk\\/by-id\\///'"
  );

Future<String> _dirtyDev(
  final String dev
) => syswline(
  'readlink "/dev/disk/by-id/$dev"'
);

Future<String> _absoluteDev(
  final String dev
) => sys(
  'echo $dev '
  "| sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' "
  "| sed '/.*[[:alpha:]]\$/d' |d se '/blk[[:digit:]]\$/d'"
);

Future<String> _partsDev(
  final String dev
) => syswline(
  'echo $dev '
  "| sed 's/^\\.\\.\\/\\.\\.\\///' "
  "| sed '/.*[[:alpha:]]\$/d' "
  "| sed '/blk[[:digit:]]\$/d'"
);

Future<String> _blocksDev(
  final String dev
) => syswline(
  "echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///'"
);

Future<String> _mountCheck(
  final String part
) => sys("lsblk /dev/$part | sed -ne '/\\//p'");

enum Action { mount , unmount, off }

void _err(final bool op) {
  clear();
  lang(op ? 7 : 8, PrintQuery.error);
  print(lang(17));
  stdin.readLineSync();
  clear();
}

void usblistener(
  final Action action,
  final void Function() call
) async {

  final (
    parts, block, mounts,
    unmounts, args, argspoweroff,
    dirtyDevs
  ) = (
    <String>[], <String>[], <String>[],
    <String>[], <String>[], <String>[],
    <String>[]
  );

  var (
    count, mountCount, unmountCount
  ) = (0,0,0);

  clear();

  final spinAction = spin();

  await _usbCheck().then((val){
    if(val) error(6);
  });

  for (final dev in await _usbPhysicalDevs()) {
    dirtyDevs.add(await _dirtyDev(dev));
  }

  dirtyDevs.removeWhere((dev) => dev == '');

  for (final dev in dirtyDevs) {
    if(await _absoluteDev(dev) != '') {
      parts.add(await _partsDev(dev));
      count++;
    } else {
      block.add(await _blocksDev(dev));
    }
  }

  for(final part in parts){
    if(await _mountCheck(part) != '') {
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
    args.add('/dev/$part');
  }

  for(final part in block) {
    if(action == Action.off) argspoweroff.add('/dev/$part');
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