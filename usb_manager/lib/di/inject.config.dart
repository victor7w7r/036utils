// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' as _i717;

import 'package:usb_manager/attach.dart' as _i855;
import 'package:usb_manager/init.dart' as _i597;
import 'package:usb_manager/lang.dart' as _i835;
import 'package:usb_manager/usb_manager.dart' as _i883;

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
    gh.factory<_i835.InitLang>(() => _i835.InitLang(gh<_i717.Lang>()));
    gh.factory<_i597.Init>(() => _i597.Init(
          gh<_i883.InitLang>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i717.Storage>(),
          gh<_i717.Tui>(),
        ));
    return this;
  }
}
