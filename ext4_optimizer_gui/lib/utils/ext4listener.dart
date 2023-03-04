import 'package:ext4_optimizer_gui/utils/commands.dart';

Future<String> _rootDev() =>
  sysout(r"df -h | sed -ne '/\/$/p' | cut -d ' ' -f1");

Future<List<String>> _physicalDevs() =>
  syssplit(r"find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///'");

Future<String> _dirtyDev(String dev) =>
  sysoutwline('readlink "/dev/disk/by-id/$dev"');

Future<String> _absoluteDev(String dev) =>
  sysout("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\//\\/dev\\//' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'");

Future<String> _blockDev(String dev) =>
  sysoutwline("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///' | sed '/.*[[:alpha:]]\$/d' | sed '/blk[[:digit:]]\$/d'");

Future<String> _typePart(String part) =>
  sysout("lsblk -f /dev/$part | sed -ne '2p' | cut -d ' ' -f2");

Future<String> _mountCheck(String part) =>
  sysout("lsblk /dev/$part | sed -ne '/\\//p'");

Future<List<String>> ext4listener() async {

  int extCount = 0;
  int mountCount = 0;

  final dirtyDevs = <String>[];
  final extParts = <String>[];
  final parts = <String>[];
  final umounts = <String>[];

  for (final dev in await _physicalDevs()) {
    dirtyDevs.add(await _dirtyDev(dev));
  }

  dirtyDevs.removeWhere((e) => e == '');

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

  if(extCount == 0) return ['NOT'];

  for(final part in extParts) {
    await _mountCheck(part) != ''
      ? mountCount +=1
      : umounts.add('/dev/$part');
  }

  if(mountCount == extCount) return ['FULL'];

  return umounts.reversed.toSet().toList();


}