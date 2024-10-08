// ignore_for_file: lines_longer_than_80_chars

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

final class MockLang extends Mock implements Lang {}

void main() {
  group('InitLang', () {
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
          'Your Operating System is not GNU/Linux, exiting',
          'The rsync binary is not available in this system, please install',
          'All dependencies is ok!',
          "The directory * doesn't exist",
          '=============== START RSYNC =============== \n',
          'Done!\n',
          "You don't have permissions to write the destination or read the source \n",
          '=============== FAIL =============== \n',
          'Please write your source directory: ',
          'Please write your destination directory to copy: ',
          'Press Enter to continue...',
          'You dont have enough permissions to run this program, try with sudo...',
        ]),
      ).called(1);

      verify(
        () => mockLang.dictEsp.addAll([
          'Este sistema no es GNU/Linux, saliendo',
          'El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo',
          '¡Todo ok!',
          'El directorio * no existe',
          '=============== EMPEZAR RSYNC =============== \n',
          'Listo!\n',
          'No tienes permisos para escribir el directorio de destino o para leer el origen \n',
          '=============== FALLA =============== \n',
          'Por favor escriba su directorio de origen: ',
          'Por favor escriba su directorio de destino: ',
          'Presione Enter para continuar...',
          'No tienes los suficientes permisos para ejecutar este programa, intenta con sudo...',
        ]),
      ).called(1);
    });
  });
}
