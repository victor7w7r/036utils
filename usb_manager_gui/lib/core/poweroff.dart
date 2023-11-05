// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart' show BuildContext;

import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/core/core.dart';
import 'package:usb_manager_gui/widgets/dialog.dart';

Future<T> _block<T>(
  final String part,
  final Future<T> Function(String) query,
) =>
    Task(() => sys("echo $part | cut -d '/' -f3"))
        .flatMap((final block) => Task(() => query(block)))
        .run();

Future<List<String>> _partsQuery(final String part) => _block(
      part,
      (final block) => syssplit('find /dev -name "$block[[:digit:]]" '
          r"| sort -n | sed 's/^\/dev\///'"),
    );

Future<String> _modelQuery(final String part) => _block(
      part,
      (final block) => sys('cat /sys/class/block/$block/device/model'),
    );

Future<void> powerOff(
  final BuildContext context,
  final bool isLang,
  final String part,
) async {
  final mounts = <String>[];

  final partitionsQuery = await _partsQuery(part);
  partitionsQuery.removeWhere((final part) => part == '');

  for (final parts in partitionsQuery) {
    if (await mountUsbCheck(parts) != '') mounts.add(parts);
  }

  if (mounts.isNotEmpty) {
    for (final partition in mounts) {
      if (await coderes('udisksctl unmount -b /dev/$partition &> /dev/null') !=
          0) {
        snackBar(context, dict(12, isLang));
        return;
      }
    }
  }

  final model = await _modelQuery(part);

  await coderes('udisksctl power-off -b $part') == 0
      ? snackBar(context, '${dict(11, isLang)} $model')
      : snackBar(context, '${dict(13, isLang)} $model');
}
