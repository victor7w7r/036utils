// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:usb_manager/app.dart' as _i565;
import 'package:usb_manager/attach.dart' as _i855;
import 'package:usb_manager/init.dart' as _i597;
import 'package:usb_manager/lang.dart' as _i835;
import 'package:usb_manager/poweroff.dart' as _i715;
import 'package:usb_manager/usb_manager.dart' as _i883;
import 'package:usb_manager/usbaction.dart' as _i254;
import 'package:usb_manager/usblistener.dart' as _i755;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' as _i717;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i855.Attach>(() => _i855.Attach());
    gh.factory<_i715.PowerOff>(() => _i715.PowerOff(
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i717.Storage>(),
          gh<_i717.Tui>(),
        ));
    gh.factory<_i254.UsbAction>(() => _i254.UsbAction(
          gh<_i855.Attach>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i717.Tui>(),
        ));
    gh.factory<_i835.InitLang>(() => _i835.InitLang(gh<_i717.Lang>()));
    gh.factory<_i755.UsbListener>(() => _i755.UsbListener(
          gh<_i883.Attach>(),
          gh<_i717.Colorize>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i883.PowerOff>(),
          gh<_i717.Storage>(),
          gh<_i717.Tui>(),
          gh<_i883.UsbAction>(),
        ));
    gh.factory<_i565.App>(() => _i565.App(
          gh<_i883.Attach>(),
          gh<_i717.Colorize>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i883.UsbListener>(),
        ));
    gh.factory<_i597.Init>(() => _i597.Init(
          gh<_i883.Attach>(),
          gh<_i883.InitLang>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i717.Storage>(),
          gh<_i717.Tui>(),
        ));
    return this;
  }
}
