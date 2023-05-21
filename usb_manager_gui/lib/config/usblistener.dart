import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/config/system.dart';

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
  "| sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"
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

Future<List<String>> usblistener(
  final Action action
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

  if(await _usbCheck()) return ['NOUSB'];

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

  return action == Action.off
    ? argspoweroff
    : args;
}