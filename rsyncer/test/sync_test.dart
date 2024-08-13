// ignore_for_file: discarded_futures

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

final class MockAttach extends Mock implements Attach {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

void main() {
  group('System', () {
    late MockAttach mockAttach;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;

    late Sync syncClass;

    setUpAll(() => registerFallbackValue(''));

    setUp(() {
      mockAttach = MockAttach();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();

      syncClass = Sync(mockAttach, mockInputOutput, mockLang);
    });

    test('call sync with success action', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(() => mockLang.write(4, PrintQuery.normal)).thenReturn('');
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) async => 0);
      await syncClass('/test/', '/testeable/');

      verify(mockInputOutput.clear).called(1);
      verify(() => mockLang.write(4, PrintQuery.normal)).called(1);
      verify(() => mockInputOutput.coderes(any())).called(1);
    });

    test('call sync with sudo action and fail', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(() => mockLang.write(4, PrintQuery.normal)).thenReturn('');
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) async => 1);
      when(() => mockLang.write(6, PrintQuery.normal)).thenReturn('');
      when(() => mockLang.write(7, PrintQuery.normal)).thenReturn('');
      when(mockAttach.errorExit).thenReturn(null);

      await syncClass('/test/', '/testeable/');

      verify(mockInputOutput.clear).called(2);
      verify(() => mockLang.write(4, PrintQuery.normal)).called(1);
      verify(() => mockInputOutput.coderes(any())).called(2);
      verify(() => mockLang.write(6, PrintQuery.normal)).called(1);
      verify(() => mockLang.write(7, PrintQuery.normal)).called(1);
      verify(mockAttach.errorExit).called(1);
    });
  });
}
