// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:rsyncer/app.dart' as _i303;
import 'package:rsyncer/attach.dart' as _i472;
import 'package:rsyncer/init.dart' as _i994;
import 'package:rsyncer/lang.dart' as _i313;
import 'package:rsyncer/rsyncer.dart' as _i756;
import 'package:rsyncer/system.dart' as _i1019;
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
    gh.factory<_i472.Attach>(() => _i472.Attach());
    gh.factory<_i1019.System>(() => _i1019.System(
          gh<_i756.Attach>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
        ));
    gh.factory<_i303.App>(() => _i303.App(
          gh<_i756.Attach>(),
          gh<_i756.System>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
        ));
    gh.factory<_i313.InitLang>(() => _i313.InitLang(gh<_i717.Lang>()));
    gh.factory<_i994.Init>(() => _i994.Init(
          gh<_i756.Attach>(),
          gh<_i756.InitLang>(),
          gh<_i717.InputOutput>(),
          gh<_i717.Lang>(),
        ));
    return this;
  }
}
