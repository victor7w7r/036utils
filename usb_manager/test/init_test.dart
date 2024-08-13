import 'dart:async';
import 'dart:io' show ProcessResult;

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

final class MockAttach extends Mock implements Attach {}

final class MockInitLang extends Mock implements InitLang {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockStorage extends Mock implements Storage {}

final class MockTui extends Mock implements Tui {}

void main() {
  group('Init', () {
    late MockAttach mockAttach;
    late MockInitLang mockInitLang;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockStorage mockStorage;
    late MockTui mockTui;

    late Init init;

    setUp(() {
      mockAttach = MockAttach();
      mockInitLang = MockInitLang();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockStorage = MockStorage();
      mockTui = MockTui();

      init = Init(
        mockAttach,
        mockInitLang,
        mockInputOutput,
        mockLang,
        mockStorage,
        mockTui,
      );
    });

    test('call init successfully, with all restrictions', () async {
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(() => mockAttach.isLinux).thenReturn(true);
      when(mockInputOutput.checkUid).thenAnswer((final _) async => false);
      when(() => mockInputOutput.success('udisksctl'))
          .thenAnswer((final _) async => false);
      when(() => mockInputOutput.success('whiptail'))
          .thenAnswer((final _) async => false);
      when(mockAttach.udisks2)
          .thenAnswer((final _) async => ProcessResult(0, 0, 'inactive', ''));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(() => mockLang.write(5, PrintQuery.normal)).thenReturn('');

      await init();

      verify(mockInputOutput.clear).called(3);
      verify(mockLang.assignLang).called(1);
      verify(mockInputOutput.checkUid).called(1);
      verify(() => mockInputOutput.success('udisksctl')).called(1);
      verify(() => mockInputOutput.success('whiptail')).called(1);
      verify(mockAttach.udisks2).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(() => mockTui.spin().cancel()).called(1);
      verify(() => mockLang.write(5, PrintQuery.normal)).called(1);
    });
  });
}
