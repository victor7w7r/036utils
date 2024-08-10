import 'package:get_it/get_it.dart' show GetIt;
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

void main() async {
  setupDartUtils();
  configInjection();
  await GetIt.I<Init>()();
  await GetIt.I<App>()();
}
