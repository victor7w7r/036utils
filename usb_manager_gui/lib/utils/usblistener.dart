import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/utils/index.dart';

Future<bool> _usbCheck() =>
  Task(() => sysout("find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\\/dev\\/disk\\/by-id\\///'"))
  .map((res) => res == '')
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

Future<List<String>> usblistener(Action action) async {

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

  if(await _usbCheck()) return ['NOUSB'];

  for (final dev in await _usbPhysicalDevs()) {
    dirtyDevs.add(await _dirtyDev(dev));
  }

  dirtyDevs.removeWhere((e) => e == '');

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
    return ['NOMOUNT'];
  } else if(action == Action.unmount && mountCount == count) {
    return ['NOUNMOUNT'];
  }

  for(final part in action == Action.mount ? unmounts : mounts) {
    args.add('/dev/$part');
  }

  for(final part in block) {
    if(action == Action.off) argspoweroff.add('/dev/$part');
  }

  if(action == Action.off) {
    return argspoweroff;
  } else {
    return args;
  }

}