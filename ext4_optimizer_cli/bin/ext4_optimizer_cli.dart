import 'dart:async' show unawaited;
import 'dart:io' show exit, stdin;

import 'package:console/console.dart' show Chooser;
import 'package:fpdart/fpdart.dart' show IO;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:ext4_optimizer_cli/ext4_optimizer_cli.dart';

final _options = <String>[];

void _continue() {
  print(lang(17));
  stdin.readLineSync();
  clear();
}

bool _runner(final int code) {
  if (code != 8) {
    lang(9, PrintQuery.normal);
    _continue();
    return false;
  } else {
    lang(8, PrintQuery.normal);
    _continue();
    unawaited(_menu());
    return true;
  }
}

Future<void> _menu() async {
  _options.add(lang(16));
  cyan(lang(14));
  IO(
    Chooser<String>(
      _options,
      message: lang(13),
    ).chooseSync,
  ).map((final sel) {
    if (sel == lang(16)) {
      clear();
      exit(0);
    } else {
      _defragction(true, sel);
    }
  }).run();
}

Future<void> _defragction(
  final bool interactive,
  final String part,
) async {
  clear();
  lang(7, PrintQuery.normal);

  if (_runner(await coderes('fsck.ext4 -y -f -v $part'))) {
    if (interactive) {
      return;
    } else {
      exit(1);
    }
  }

  lang(10, PrintQuery.normal);
  if (_runner(await coderes('fsck.ext4 -y -f -v -D $part'))) {
    if (interactive) {
      return;
    } else {
      exit(1);
    }
  }

  syncCall("bash -c 'mkdir /tmp/optimize 2> /dev/null'");
  syncCall("bash -c 'mount $part /tmp/optimize'");

  lang(11, PrintQuery.normal);
  await coderes('e4defrag -v $part');

  syncCall("bash -c 'umount $part'");

  lang(9, PrintQuery.normal);
  _continue();

  lang(12, PrintQuery.normal);

  if (_runner(await coderes('fsck.ext4 -y -f -v $part'))) {
    if (interactive) {
      return;
    } else {
      exit(1);
    }
  }

  if (interactive) {
    _options
      ..clear()
      ..addAll(await ext4listener(false));
    unawaited(_menu());
  } else {
    exit(0);
  }
}

void main(final List<String> args) async {
  _options.addAll(await init(args));
  if (args.isEmpty) {
    clear();
    unawaited(_menu());
  } else {
    unawaited(_defragction(false, args[0]));
  }
}
