import 'package:zerothreesix_dart/zerothreesix_dart.dart';

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

  if(await checkUsbDevices()) return ['NOUSB'];

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

  for(final part in parts){
    if(await mountUsbCheck(part) != '') {
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
