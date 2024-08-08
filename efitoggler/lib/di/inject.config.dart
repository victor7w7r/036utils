// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:efitoggler/app.dart' as _i667;
import 'package:efitoggler/efitoggler.dart' as _i1005;
import 'package:efitoggler/init.dart' as _i215;
import 'package:efitoggler/lang.dart' as _i281;
import 'package:efitoggler/macos_efi.dart' as _i1058;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
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
    gh.factory<_i1058.MacosEfi>(() => _i1058.MacosEfi(
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i717.Tui>(),
        ));
    gh.factory<_i281.InitLang>(() => _i281.InitLang(gh<_i717.Lang>()));
    gh.factory<_i667.App>(() => _i667.App(
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
          gh<_i1005.MacosEfi>(),
        ));
    gh.factory<_i215.Init>(() => _i215.Init(
          gh<_i281.InitLang>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
        ));
    return this;
  }
}
