import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

final class MockAttach extends Mock implements Attach {}

final class MockInitLang extends Mock implements InitLang {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

void main() {
  group('Init', () {
    late MockAttach mockAttach;
    late MockInitLang mockInitLang;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;

    late Init init;

    setUp(() {
      mockAttach = MockAttach();
      mockInitLang = MockInitLang();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();

      init = Init(mockAttach, mockInitLang, mockInputOutput, mockLang);
    });

    test('init', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockInitLang.call).thenReturn(null);
      when(mockLang.assignLang).thenReturn(null);
      when(() => mockLang.write(2, PrintQuery.normal)).thenReturn('');
      when(() => mockAttach.isLinux).thenReturn(true);
      // ignore: discarded_futures
      when(() => mockInputOutput.success('rsync'))
          .thenAnswer((final _) async => true);

      await init();

      verify(mockInputOutput.clear).called(3);
      verify(mockInitLang.call).called(1);
      verify(mockLang.assignLang).called(1);
      verifyNever(() => mockLang.error(0));
      verify(() => mockLang.write(2, PrintQuery.normal)).called(1);
    });
  });
}
