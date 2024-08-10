// ignore_for_file: discarded_futures

import 'dart:async' show Timer;

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/efitoggler.dart';

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockTui extends Mock implements Tui {}

void main() {
  group('MacosEfi', () {
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockTui mockTui;

    late MacosEfi macosEfi;

    setUpAll(() => registerFallbackValue(''));

    setUp(() {
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockTui = MockTui();

      macosEfi = MacosEfi(mockInputOutput, mockLang, mockTui);
    });

    test('checkEfiPart when checkSu is zero', () async {
      when(() => mockInputOutput.coderes('sudo cat < /dev/null')).thenAnswer(
        (final _) => Future.value(0),
      );
      when(mockTui.spin).thenAnswer(
        (final _) => Timer.periodic(const Duration(seconds: 1), (final _) {}),
      );
      when(() => mockInputOutput.sys(any())).thenAnswer(
        (final _) => Future.value('part'),
      );

      expect(await macosEfi.checkEfiPart(), 'part');

      verify(() => mockInputOutput.coderes('sudo cat < /dev/null')).called(1);
      verify(() => mockInputOutput.sys(any())).called(1);
    });

    test('checkEfiPart when checkSu is not zero', () async {
      when(() => mockInputOutput.coderes('sudo cat < /dev/null')).thenAnswer(
        (final _) => Future.value(1),
      );
      when(mockTui.spin).thenAnswer(
        (final _) => Timer.periodic(const Duration(seconds: 1), (final _) {}),
      );
      when(() => mockLang.error(5)).thenReturn(null);

      expect(await macosEfi.checkEfiPart(), '');

      verify(() => mockInputOutput.coderes('sudo cat < /dev/null')).called(1);
      verify(() => mockLang.error(5)).called(1);
    });

    test('efiCheck', () async {
      when(() => mockInputOutput.sys(any())).thenAnswer((final _) async => '');

      await macosEfi.efiCheck();

      verify(() => mockInputOutput.sys(any())).called(1);
    });
  });
}
