import 'package:efitoggler/efitoggler.dart';

import 'package:get_it/get_it.dart' show GetIt;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' show setupDartUtils;

void main() async {
  setupDartUtils();
  configInjection();
  GetIt.I<Init>().init();
  await GetIt.I<App>().app();
}
