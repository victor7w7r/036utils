import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_cli/usb_manager_cli.dart';

Future<T> _block<T>(
  final String part,
  Future<T> Function(String) query
) => Task(() => sys(
  'echo $part | cut -d \'/\' -f3'
))
  .flatMap((block) => Task(() => query(block)))
  .run();

Future<List<String>> _partsQuery(
  final String part
) => _block(part, (block) => syssplit(
  'find /dev -name "$block[[:digit:]] "'
  "| sort -n | sed 's/^\\/dev\\///'"
));

Future<String> _modelQuery(
  final String part
) => _block(part, (block) => sys(
  'cat /sys/class/block/$block/device/model'
));

Future<String> _mountQuery(
  final String part
) => sys("lsblk /dev/$part | sed -ne '/\\//p'");

void powerOff(
  final String part,
  final void Function() call
) async {

  final mounts = <String>[];

  clear();
  final spinAction = spin();

  final partitionsQuery = await _partsQuery(part);

  partitionsQuery.removeWhere((item) => item == '');

  for(final parts in partitionsQuery) {
    if(await _mountQuery(parts) != '') mounts.add(parts);
  }

  if(mounts.isNotEmpty) {
    for(final partition in mounts) {
      if(await coderes(
        'udisksctl unmount -b /dev/$partition &> /dev/null'
      ) == 0) {
        print('');
      } else {
        spinAction.cancel();
        await dialog(
          'ERROR',
          dialogLang(1, partition),
          '8', '80'
        );
        clear();
        call();
        return;
      }
    }
  }

  final model = await _modelQuery(part);

  spinAction.cancel();
  if(await coderes(
    'udisksctl power-off -b $part'
  ) == 0) {
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