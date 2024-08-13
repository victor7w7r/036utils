import 'dart:async' show Timer;

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockStorage extends Mock implements Storage {}

final class MockTui extends Mock implements Tui {}

void main() {
  group('Poweroff', () {
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockStorage mockStorage;
    late MockTui mockTui;

    late PowerOff powerOff;

    setUpAll(() {
      registerFallbackValue('');
      registerFallbackValue(0);
    });

    setUp(() {
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockStorage = MockStorage();
      mockTui = MockTui();

      powerOff = PowerOff(mockInputOutput, mockLang, mockStorage, mockTui);
    });

    test('call poweroff with zero partitions on device successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenAnswer((final _) => Timer(Duration(), () {}));
      when(() => mockInputOutput.syssplit(any()))
          .thenAnswer((final _) => Future.value(['sda1', 'sda2']));
      when(() => mockInputOutput.sys(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.mountUsbCheck(any()))
          .thenAnswer((final _) => Future.value(''));
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockTui.dialog(any(), any(), any(), any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockLang.dialogLang(any())).thenReturn('dialogLang');
      when(() => mockLang.dialogLang(any(), any())).thenReturn('dialogLang');

      await powerOff('sda1');

      verify(mockInputOutput.clear).called(2);
      verify(() => mockInputOutput.syssplit(any())).called(1);
      verify(() => mockInputOutput.sys(any())).called(3);
      verify(() => mockStorage.mountUsbCheck(any())).called(2);
      verify(() => mockInputOutput.coderes(any())).called(1);
      verify(() => mockTui.dialog(any(), any(), any(), any())).called(1);
    });

    test('call poweroff with zero partitions with errors', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenAnswer((final _) => Timer(Duration(), () {}));
      when(() => mockInputOutput.syssplit(any()))
          .thenAnswer((final _) => Future.value(['sda1', 'sda2']));
      when(() => mockInputOutput.sys(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.mountUsbCheck(any()))
          .thenAnswer((final _) => Future.value(''));
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) => Future.value(1));
      when(() => mockTui.dialog(any(), any(), any(), any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockLang.dialogLang(any())).thenReturn('dialogLang');
      when(() => mockLang.dialogLang(any(), any())).thenReturn('dialogLang');

      await powerOff('sda1');

      verify(mockInputOutput.clear).called(2);
      verify(() => mockInputOutput.syssplit(any())).called(1);
      verify(() => mockInputOutput.sys(any())).called(3);
      verify(() => mockStorage.mountUsbCheck(any())).called(2);
      verify(() => mockInputOutput.coderes(any())).called(1);
      verify(() => mockTui.dialog(any(), any(), any(), any())).called(1);
    });

    test('call poweroff with one partition on device successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenAnswer((final _) => Timer(Duration(), () {}));
      when(() => mockInputOutput.syssplit(any()))
          .thenAnswer((final _) => Future.value(['sda1', 'sda2']));
      when(() => mockInputOutput.sys(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.mountUsbCheck(any()))
          .thenAnswer((final _) => Future.value('sda1'));
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockTui.dialog(any(), any(), any(), any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockLang.dialogLang(any())).thenReturn('dialogLang');
      when(() => mockLang.dialogLang(any(), any())).thenReturn('dialogLang');

      await powerOff('sda1');

      verify(mockInputOutput.clear).called(2);
      verify(() => mockInputOutput.syssplit(any())).called(1);
      verify(() => mockInputOutput.sys(any())).called(3);
      verify(() => mockStorage.mountUsbCheck(any())).called(2);
      verify(() => mockInputOutput.coderes(any())).called(3);
    });

    test('call poweroff with one partition with errors', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenAnswer((final _) => Timer(Duration(), () {}));
      when(() => mockInputOutput.syssplit(any()))
          .thenAnswer((final _) => Future.value(['sda1', 'sda2']));
      when(() => mockInputOutput.sys(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.mountUsbCheck(any()))
          .thenAnswer((final _) => Future.value('sda1'));
      when(() => mockInputOutput.coderes(any()))
          .thenAnswer((final _) => Future.value(1));
      when(() => mockTui.dialog(any(), any(), any(), any()))
          .thenAnswer((final _) => Future.value(0));
      when(() => mockLang.dialogLang(any())).thenReturn('dialogLang');
      when(() => mockLang.dialogLang(any(), any())).thenReturn('dialogLang');

      await powerOff('sda1');

      verify(mockInputOutput.clear).called(2);
      verify(() => mockInputOutput.syssplit(any())).called(1);
      verify(() => mockInputOutput.sys(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(2);
      verify(() => mockInputOutput.coderes(any())).called(1);
    });
  });
}
