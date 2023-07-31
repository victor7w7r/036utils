import 'dart:io' show Platform;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer_cli/rsyncer_cli.dart';

Future<void> init() async {

  clear();
  setLang();
  initLang();
  clear();
  cover();

  if(!Platform.isLinux) error(0);

  await success('rsync').then((final val){
    if(!val) error(1);
  });

  lang(2, PrintQuery.normal);

}
