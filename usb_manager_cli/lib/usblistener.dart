import 'dart:io' show stdin;

import 'package:console/console.dart' show Chooser;
import 'package:dcli/dcli.dart' show cyan;
import 'package:fpdart/fpdart.dart' show IO;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager_cli/usb_manager_cli.dart';

enum Action { mount, unmount, off }

void _err(final bool op) {
  clear();
  lang(op ? 7 : 8, PrintQuery.error);
  print(lang(17));
  stdin.readLineSync();
  clear();
}

Future<void> usblistener(
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

  await checkUsbDevices().then((final val){
    if(val) error(6);
  });

  for (final dev in await usbDevices()) {
    dirtyDevs.add(await dirtyDev(dev));
  }

  dirtyDevs.removeWhere((final dev) => dev == '');

  for (final dev in dirtyDevs) {
    if(await absoluteDev(dev) != '') {
      parts.add(await getAllBlockDev(dev));
      count++;
    } else {
      block.add(await getBlockDev(dev));
    }
  }

  for (final part in parts){
    if(await mountUsbCheck(part) != '') {
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
    .map((final sel){
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
