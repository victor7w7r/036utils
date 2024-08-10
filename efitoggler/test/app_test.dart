// ignore_for_file: discarded_futures

import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:efitoggler/efitoggler.dart';

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockMacosEfi extends Mock implements MacosEfi {}

void main() {
  group('App', () {
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockMacosEfi mockMacosEfi;

    late App app;

    setUpAll(() => registerFallbackValue(''));

    setUp(() {
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockMacosEfi = MockMacosEfi();

      app = App(mockInputOutput, mockLang, mockMacosEfi);
    });

    test('call app when efiCheck is not empty', () async {
      when(mockMacosEfi.efiCheck).thenAnswer((final _) async => 'efi');
      when(() => mockLang.write(2, PrintQuery.normal)).thenReturn('');
      when(mockMacosEfi.checkEfiPart).thenAnswer((final _) async => 'part');

      when(() => mockInputOutput.syncCall(any()))
          .thenReturn(ProcessResult(1, 0, stdout, stderr));

      await app();

      verify(() => mockLang.write(2, PrintQuery.normal)).called(1);
      verify(mockMacosEfi.checkEfiPart).called(1);
    });

    test('call app when efiCheck is empty', () async {
      when(mockMacosEfi.efiCheck).thenAnswer((final _) async => '');
      when(() => mockLang.write(3, PrintQuery.normal)).thenReturn('');
      when(mockMacosEfi.checkEfiPart).thenAnswer((final _) async => '');

      when(() => mockInputOutput.syncCall(any()))
          .thenReturn(ProcessResult(1, 0, stdout, stderr));

      await app();

      verify(() => mockLang.write(3, PrintQuery.normal)).called(1);
      verify(mockMacosEfi.checkEfiPart).called(1);
    });
  });
}
