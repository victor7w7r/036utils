import 'dart:io' show Platform;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:ext4_optimizer/ext4_optimizer.dart';

Future<List<String>> init(final List<String> args) async {
  clear();

  if (args.isEmpty) setLang();

  initLang();
  clear();
  cover();

  if (args.isEmpty) {
    final spinAction = spin();

    onlyIf(!Platform.isLinux, () => error(0));

    await checkUid().then(
      (final val) => onlyIf(!val, () => error(1)),
    );

    await success('e4defrag').then(
      (final val) => onlyIf(!val, () => error(2)),
    );

    await success('fsck.ext4').then(
      (final val) => onlyIf(!val, () => error(3)),
    );

    lang(4, PrintQuery.normal);
    final parts = await ext4listener(false);
    spinAction.cancel();

    return parts;
  } else {
    english = true;
    return [];
  }
}
