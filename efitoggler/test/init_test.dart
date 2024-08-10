import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/efitoggler.dart';

final class MockInitLang extends Mock implements InitLang {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

void main() {
  group('initTest', () {
    late MockInitLang mockInitLang;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;

    late Init init;

    setUp(() {
      mockInitLang = MockInitLang();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();

      init = Init(mockInitLang, mockInputOutput, mockLang);
    });

    test('init', () {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockInitLang.call).thenReturn(null);
      when(mockLang.assignLang).thenReturn(null);
      when(() => mockLang.write(1, PrintQuery.normal)).thenReturn('');

      init();

      verify(mockInputOutput.clear).called(2);
      verify(mockInitLang.call).called(1);
      verify(mockLang.assignLang).called(1);
      verifyNever(() => mockLang.error(0));
      verify(() => mockLang.write(1, PrintQuery.normal)).called(1);
    });
  });
}
