import 'dart:io';

import 'package:fpdart/fpdart.dart' show Task;

const _usbList =
  "find /dev/disk/by-id/ -name 'usb*' "
  '| sort -n '
  r"| sed 's/^\/dev\/disk\/by-id\///'";

Task<ProcessResult> _exec(
  final String cmd
) => Task(() async => Process.run(
  'bash',
  ['-c', cmd],
  runInShell: true
));

Future<int> call(
  final String cmd
) => _exec(cmd)
  .map((final res) => res.exitCode)
  .run();

Future<bool> success(
  final String cmd
) => _exec('type $cmd')
  .map((final res) => res.exitCode == 0)
  .run();

Future<String> sys(
  final String cmd
) => _exec(cmd)
  .map((final res) => res.stdout.toString().trim())
  .run();

Future<List<String>> syssplit(
  final String cmd
) => _exec(cmd)
  .map((final res) => res.stdout.toString().split('\n'))
  .run();

Future<String> syswline(
  final String cmd
) => _exec(cmd)
  .map((final res) => res.stdout.toString().split('\n')[0])
  .run();

Future<List<String>> usbDevices() =>
  syssplit(_usbList);

Future<String> checkPartFs(
  final String part
) => sys("lsblk -f /dev/$part | sed -ne '2p' | cut -d ' ' -f2");

Future<String> dirtyDev(
  final String dev
) => syswline(
  'readlink "/dev/disk/by-id/$dev"'
);

Future<String> absoluteDev(
  final String dev
) => sys(
  'echo $dev '
  r"| sed 's/^\.\.\/\.\.\//\/dev\//' "
  r"| sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'"
);

Future<String> mountUsbCheck(
  final String part
) => sys("lsblk /dev/$part | sed -ne '/\\//p'");

Future<String> getRootDev() =>
  sys(r"df -h | sed -ne '/\/$/p' | cut -d ' ' -f1");

Future<String> getAllBlockDev(
  final String dev
) => syswline(
  'echo $dev '
  r"| sed 's/^\.\.\/\.\.\///' "
  r"| sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'"
);

Future<List<String>> ext4listener() async {

  var extCount = 0;
  var mountCount = 0;

  final dirtyDevs = <String>[];
  final extParts = <String>[];
  final parts = <String>[];
  final umounts = <String>[];

  for (final dev in await usbDevices()) {
    dirtyDevs.add(await dirtyDev(dev));
  }

  dirtyDevs.removeWhere((final dev) => dev == '');

  for (final dev in dirtyDevs) {
    final abs = await absoluteDev(dev);
    if(abs != '' && abs != await getRootDev()) {
      parts.add(await getAllBlockDev(dev));
    }
  }

  for(final part in parts) {
    if(await checkPartFs(part) == 'ext4') {
      extCount += 1;
      extParts.add(part);
    }
  }

  if(extCount == 0) return ['NOT'];

  for(final part in extParts) {
    await mountUsbCheck(part) != ''
      ? mountCount +=1
      : umounts.add('/dev/$part');
  }

  if(mountCount == extCount) return ['FULL'];

  return umounts.reversed
    .toSet().toList();

}
