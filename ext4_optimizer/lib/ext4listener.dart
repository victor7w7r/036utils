import 'dart:io' show exit;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

void _interrupt(final bool op) {
  clear();
  lang(op ? 5 : 6, PrintQuery.error);
  exit(1);
}

Future<List<String>> ext4listener(final bool isMenu) async {
  var (extCount, mountCount) = (0, 0);

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
    if (abs != '' && abs != await getRootDev()) {
      parts.add(await getAllBlockDev(dev));
    }
  }

  for (final part in parts) {
    if (await checkPartFs(part) == 'ext4') {
      extCount += 1;
      extParts.add(part);
    }
  }

  if (extCount == 0) _interrupt(true);

  for (final part in extParts) {
    await mountUsbCheck(part) != ''
        ? mountCount += 1
        : umounts.add('/dev/$part');
  }

  if (mountCount == extCount) _interrupt(false);

  return umounts.reversed.toSet().toList();
}
