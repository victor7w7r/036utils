import 'package:fpdart/fpdart.dart' show Task;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

Future<T> _block<T>(
  final String part,
  final Future<T> Function(String) query
) => Task(() => sys(
  "echo $part | cut -d '/' -f3"
))
  .flatMap((final block) => Task(() => query(block)))
  .run();

Future<List<String>> _partsQuery(
  final String part
) => _block(part, (final block) => syssplit(
  'find /dev -name "$block[[:digit:]]" '
  r"| sort -n | sed 's/^\/dev\///'"
));

Future<String> _modelQuery(
  final String part
) => _block(part, (final block) => sys(
  'cat /sys/class/block/$block/device/model'
));

Future<void> powerOff(
  final String part,
  final void Function() call
) async {

  final mounts = <String>[];

  clear();
  final spinAction = spin();

  final partitionsQuery = await _partsQuery(part);

  partitionsQuery.removeWhere((final item) => item == '');

  for(final parts in partitionsQuery) {
    if(await mountUsbCheck(parts) != '') mounts.add(parts);
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
