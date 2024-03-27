import 'dart:io' show stdin;

import 'package:cli_menu/cli_menu.dart' show Menu;
import 'package:fpdart/fpdart.dart' show IO;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

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
  final void Function() call,
) async {
  final (parts, block, mounts, unmounts, args, argspoweroff, dirtyDevs) = (
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[]
  );

  var (count, mountCount, unmountCount) = (0, 0, 0);

  clear();

  final spinAction = spin();

  await checkUsbDevices().then(
    (final val) => onlyIf(val, () => error(6)),
  );

  for (final dev in await usbDevices()) {
    dirtyDevs.add(await dirtyDev(dev));
  }

  dirtyDevs.removeWhere((final dev) => dev == '');

  for (final dev in dirtyDevs) {
    if (await absoluteDev(dev) != '') {
      parts.add(await getAllBlockDev(dev));
      count++;
    } else {
      block.add(await getBlockDev(dev));
    }
  }

  for (final part in parts) {
    if (await mountUsbCheck(part) != '') {
      unmountCount++;
      mounts.add(part);
    } else {
      mountCount++;
      unmounts.add(part);
    }
  }

  if (action == Action.mount && unmountCount == count) {
    _err(true);
    call();
    return;
  } else if (action == Action.unmount && mountCount == count) {
    _err(false);
    call();
    return;
  }

  for (final part in action == Action.mount ? unmounts : mounts) {
    args.add('/dev/$part');
  }

  for (final part in block) {
    if (action == Action.off) argspoweroff.add('/dev/$part');
  }

  action == Action.off ? argspoweroff.add(lang(25)) : args.add(lang(25));

  if (action == Action.mount) {
    cyan(lang(18));
  } else if (action == Action.unmount) {
    cyan(lang(20));
  } else {
    cyan(lang(21));
  }

  spinAction.cancel();

  IO(
    Menu(action == Action.off ? argspoweroff : args).choose,
  ).map((final op) {
    if (op.value == lang(25)) {
      clear();
      call();
      return;
    } else {
      clear();
      switch (action) {
        case Action.mount:
          usbAction(op.value, true, call);
        case Action.unmount:
          usbAction(op.value, false, call);
        case Action.off:
          powerOff(op.value, call);
      }
    }
  }).run();
}
