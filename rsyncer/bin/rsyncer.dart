import 'package:get_it/get_it.dart' show GetIt;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' show setupDartUtils;

import 'package:rsyncer/rsyncer.dart';

void main() async {
  setupDartUtils();
  configInjection();
  await GetIt.I<Init>()();
  await GetIt.I<App>()();
}
