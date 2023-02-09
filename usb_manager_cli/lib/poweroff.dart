import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_cli/index.dart';

Future<String> _block(String part) =>
  sysout("echo $part | cut -d \"/\" -f3");

Future<List<String>> _partsQuery(String part) =>
  Task(() => _block(part))
    .flatMap((block) => Task(() => syssplit("find /dev -name \"$block[[:digit:]]\" | sort -n | sed 's/^\\/dev\\///'")))
    .run();

Future<String> _modelQuery(String part) =>
  Task(() => _block(part))
    .flatMap((block) => Task(() => sysout("cat /sys/class/block/$block/device/model")))
    .run();

Future<String> _mountQuery(String part) =>
  sysout("lsblk /dev/$part | sed -ne '/\\//p'");

Future<void> powerOff(String part, void Function() call) async {

  final mounts = <String>[];

  clear();
  final spinAction = spin();

  final partitionsQuery = await _partsQuery(part);
  partitionsQuery.removeWhere((e) => e == '');

  for(final parts in partitionsQuery) {
    if(await _mountQuery(parts) != "") mounts.add(parts);
  }

  if(mounts.isNotEmpty) {
    for(final partition in mounts) {
      if(await codeproc("udisksctl unmount -b /dev/$partition &> /dev/null") == 0) {
        print("");
      } else {
        spinAction.cancel();
        await dialog('ERROR', dialogLang(1, partition), '8', '80');
        clear();
        call();
        return;
      }
    }
  }

  final model = await _modelQuery(part);
  final powerOff = await codeproc("udisksctl power-off -b $part");

  spinAction.cancel();
  if(powerOff == 0) {
    await dialog(dialogLang(0), dialogLang(2, model), '8', '80');
    clear();
    call();
    return;
  } else {
    await dialog('ERROR', dialogLang(3, model), '8', '80');
    clear();
    call();
    return;
  }
}