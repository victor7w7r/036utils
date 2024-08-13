import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

final class MockAttach extends Mock implements Attach {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockTui extends Mock implements Tui {}

void main() {
  group('Usbaction', () {
    late MockAttach mockAttach;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockTui mockTui;

    late UsbAction usbAction;

    setUp(() {
      mockAttach = MockAttach();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockTui = MockTui();

      usbAction = UsbAction(mockAttach, mockInputOutput, mockLang, mockTui);
    });

    test('call usbaction with mount option selected', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(() => mockLang.write(19)).thenReturn('19');
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(() => mockInputOutput.codeout('udisksctl mount -b /dev/sda1'))
          .thenAnswer((final _) async => ['0', '']);
      when(() => mockTui.dialog('19', '19', '8', '80'))
          .thenAnswer((final _) async => 1);

      await usbAction('/dev/sda1', true);

      verify(() => mockLang.write(19)).called(2);
      verify(mockTui.spin).called(1);
      verify(() => mockInputOutput.codeout('udisksctl mount -b /dev/sda1'))
          .called(1);
      verify(() => mockTui.dialog('19', '19', '8', '80')).called(1);
      verify(mockInputOutput.clear).called(2);
    });

    test('call usbaction with unmount option selected', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(() => mockLang.write(19)).thenReturn('19');
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(() => mockInputOutput.codeout('udisksctl unmount -b /dev/sda1'))
          .thenAnswer((final _) async => ['0', '']);
      when(() => mockTui.dialog('19', '19', '8', '80'))
          .thenAnswer((final _) async => 1);

      await usbAction('/dev/sda1', false);

      verify(() => mockLang.write(19)).called(2);
      verify(mockTui.spin).called(1);
      verify(() => mockInputOutput.codeout('udisksctl unmount -b /dev/sda1'))
          .called(1);
      verify(() => mockTui.dialog('19', '19', '8', '80')).called(1);
      verify(mockInputOutput.clear).called(2);
    });

    test('call usbaction with not authorized error', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(() => mockLang.write(17)).thenReturn('17');
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(() => mockInputOutput.codeout('udisksctl mount -b /dev/sda1'))
          .thenAnswer((final _) async => ['1', 'NotAuthorized']);
      when(mockAttach.readSync).thenReturn('');
      when(() => mockLang.write(8, PrintQuery.error)).thenReturn('8');

      await usbAction('/dev/sda1', true);

      verify(() => mockLang.write(17)).called(1);
      verify(mockTui.spin).called(1);
      verify(() => mockInputOutput.codeout('udisksctl mount -b /dev/sda1'))
          .called(1);
      verify(mockAttach.readSync).called(1);
      verify(() => mockLang.write(8, PrintQuery.error)).called(1);
      verify(mockInputOutput.clear).called(3);
    });
  });
}
