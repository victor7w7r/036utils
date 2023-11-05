import 'dart:io' show Platform;

import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler_cli/lang.dart';

void init() {
  clear();
  setLang();
  initLang();
  clear();
  cover();

  if (!Platform.isMacOS) error(0);

  lang(1, PrintQuery.normal);
}
