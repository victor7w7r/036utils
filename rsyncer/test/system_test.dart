// ignore_for_file: discarded_futures

import 'dart:io';

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

    late System system;

    setUpAll(() => registerFallbackValue(''));

    setUp(() {
      mockAttach = MockAttach();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();

      system = System(mockAttach, mockInputOutput, mockLang);
    });

    test('call directoryCheck successfully', () {
      when(() => mockAttach.existsDir('data')).thenReturn(true);

      system.directoryCheck('data');

      verify(() => mockAttach.existsDir('data')).called(1);
      verifyNever(() => mockInputOutput.clear());
      verifyNever(() => mockLang.write(11, PrintQuery.error));
      verifyNever(() => mockAttach.successExit());
    });

    test('call directoryCheck unsuccessfully', () {
      when(() => mockAttach.existsDir('data')).thenThrow(FileSystemException());
      when(() => mockLang.write(11, PrintQuery.error)).thenReturn('');
      when(mockAttach.successExit).thenReturn(null);

      system.directoryCheck('data');

      verify(() => mockAttach.existsDir('data')).called(1);
      verify(() => mockInputOutput.clear()).called(1);
      verify(() => mockLang.write(11, PrintQuery.error)).called(1);
      verify(() => mockAttach.successExit()).called(1);
    });
  });
}
