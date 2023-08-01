import 'package:zerothreesix_dart/zerothreesix_dart.dart';

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
