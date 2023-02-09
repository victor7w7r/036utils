import 'dart:io' show exit, stdin;

import 'package:console/console.dart';
import 'package:dcli/dcli.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ext4_optimizer_cli/index.dart';

final _options = <String>[];

void _continue() {
  print(lang(17));
  stdin.readLineSync();
  clear();
}

bool _runner(int code) {
  if(code != 8) {
    lang(9, PrintQuery.normal);
    _continue();
    return false;
  } else {
    lang(8, PrintQuery.normal);
    _continue();
    _menu();
    return true;
  }
}

Future<void> _menu() async {
  _options.add(lang(16));
  print(cyan(lang(14)));
  IO(Chooser<String>(_options, message: lang(13)).chooseSync)
    .map((sel){
      if(sel == lang(16)) {
        clear();
        exit(0);
      } else {
        _defragction(true, sel);
      }
    })
    .run();
}

Future<void> _defragction(bool interactive, String part) async {

  clear();
  lang(7, PrintQuery.normal);

  if(_runner(await codeproc("fsck.ext4 -y -f -v $part"))) {
    if(interactive) {
      return;
    } else {
      exit(1);
    }
  }

  lang(10, PrintQuery.normal);
  if(_runner(await codeproc("fsck.ext4 -y -f -v -D $part"))) {
    if(interactive) {
      return;
    } else {
      exit(1);
    }
  }

  "bash -c 'mkdir /tmp/optimize 2> /dev/null'".start(detached: false, nothrow: true);
  "bash -c 'mount $part /tmp/optimize'".run;

  lang(11, PrintQuery.normal);
  await codeproc("e4defrag -v $part");

  print("");
  "bash -c 'umount $part'".run;

  lang(9, PrintQuery.normal);
  _continue();

  lang(12, PrintQuery.normal);

  if(_runner(await codeproc("fsck.ext4 -y -f -v $part"))) {
    if(interactive) {
      return;
    } else {
      exit(1);
    }
  }

  interactive ? _menu() : exit(0);
}

Future<void> main(List<String> args) async {
  setup();
  _options.addAll(await locator.get<App>().init(args));
  if(args.isEmpty) {
    clear();
    _menu();
  } else {
    _defragction(false, args[0]);
  }
}
