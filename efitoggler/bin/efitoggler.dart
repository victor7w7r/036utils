import 'package:get_it/get_it.dart' show GetIt;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' show setupDartUtils;

import 'package:efitoggler/efitoggler.dart';

void main() async {
  setupDartUtils();
  configInjection();
  GetIt.I<Init>()();
  await GetIt.I<App>()();
}
