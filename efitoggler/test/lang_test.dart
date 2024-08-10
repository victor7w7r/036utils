import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/efitoggler.dart';

final class MockLang extends Mock implements Lang {}

void main() {
  group('langTest', () {
    late MockLang mockLang;

    late InitLang initLang;

    setUp(() {
      mockLang = MockLang();
      initLang = InitLang(mockLang);
    });

    test('lang', () {
      when(() => mockLang.dictEsp).thenReturn([]);
      when(() => mockLang.dictEng).thenReturn([]);

      initLang();

      verify(
        () => mockLang.dictEng.addAll([
          'Your Operating System is not macOS, exiting',
          'All dependencies is ok!',
          'EFI Folder is mounted, unmounting',
          'EFI Folder is not mounted, mounting',
          'Done!',
          'Sudo auth fails',
        ]),
      ).called(1);

      verify(
        () => mockLang.dictEsp.addAll([
          'Tu sistema operativo no es macOS, saliendo',
          '¡Todo ok!',
          'La carpeta EFI esta montada, desmontando',
          'La carpeta EFI no esta montada, montando',
          '¡Listo!',
          'Autenticación con sudo falló',
        ]),
      ).called(1);
    });
  });
}
