import 'dart:io' show exit;

import 'package:ext4_optimizer_cli/ext4_optimizer_cli.dart';

Future<String> _rootDev() =>
  sys(r"df -h | sed -ne '/\/$/p' | cut -d ' ' -f1");

Future<List<String>> _physicalDevs() =>
  syssplit(
    'find /dev/disk/by-id/ '
    '| sort -n '
    r"| sed 's/^\/dev\/disk\/by-id\///'"
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

Future<String> _blockDev(
  final String dev
) => syswline(
  'echo $dev '
  "| sed 's/^\\.\\.\\/\\.\\.\\///' "
  "| sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'"
);

Future<String> _typePart(
  final String part
) => sys("lsblk -f /dev/$part | sed -ne '2p' | cut -d ' ' -f2");

Future<String> _mountCheck(
  final String part
) => sys("lsblk /dev/$part | sed -ne '/\\//p'");

void _interrupt(final bool op) {
  clear();
  lang(op ? 5 : 6, PrintQuery.error);
  exit(1);
}

Future<List<String>> ext4listener(
  final bool isMenu
) async {

  var (extCount, mountCount) = (0, 0);

  final dirtyDevs = <String>[];
  final extParts = <String>[];
  final parts = <String>[];
  final umounts = <String>[];

  for (final dev in await _physicalDevs()) {
    dirtyDevs.add(await _dirtyDev(dev));
  }

  dirtyDevs.removeWhere((dev) => dev == '');

  for (final dev in dirtyDevs) {
    final abs = await _absoluteDev(dev);
    abs != '' && abs != await _rootDev()
      ? parts.add(await _blockDev(dev))
      : {};
  }

  for(final part in parts) {
    if(await _typePart(part) == 'ext4') {
      extCount += 1;
      extParts.add(part);
    }
  }

  if(extCount == 0) _interrupt(true);

  for(final part in extParts) {
    await _mountCheck(part) != ''
      ? mountCount +=1
      : umounts.add('/dev/$part');
  }

  if(mountCount == extCount) _interrupt(false);

  return umounts.reversed
    .toSet().toList();

}