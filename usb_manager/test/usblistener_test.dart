import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

final class MockAttach extends Mock implements Attach {}

final class MockColorize extends Mock implements Colorize {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockPowerOff extends Mock implements PowerOff {}

final class MockStorage extends Mock implements Storage {}

final class MockTui extends Mock implements Tui {}

final class MockUsbAction extends Mock implements UsbAction {}

void main() {
  group('Usbaction', () {
    late MockAttach mockAttach;
    late MockColorize mockColorize;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockPowerOff mockPowerOff;
    late MockStorage mockStorage;
    late MockTui mockTui;
    late MockUsbAction mockUsbAction;

    late UsbListener usbListener;

    setUpAll(() {
      registerFallbackValue('');
      registerFallbackValue(0);
    });

    setUp(() {
      mockAttach = MockAttach();
      mockColorize = MockColorize();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockPowerOff = MockPowerOff();
      mockStorage = MockStorage();
      mockTui = MockTui();
      mockUsbAction = MockUsbAction();

      usbListener = UsbListener(
        mockAttach,
        mockColorize,
        mockInputOutput,
        mockLang,
        mockPowerOff,
        mockStorage,
        mockTui,
        mockUsbAction,
      );
    });

    test('call usbListener onMount option successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => 'sdb');
      when(() => mockStorage.getAllBlockDev(any())).thenAnswer(
        (final _) async => 'sda1',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '',
      );
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});

      await usbListener(Action.mount);

      verify(mockInputOutput.clear).called(2);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getAllBlockDev(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(1);
      verify(() => mockLang.write(18)).called(1);
      verify(() => mockLang.write(25)).called(2);
      verify(() => mockColorize.cyan('18')).called(1);
      verify(() => mockAttach.chooser(any())).called(1);
      verify(() => mockUsbAction.call(any(), any())).called(1);
    });

    test('call usbListener onMount, but the operation was cancelled', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => 'sdb');
      when(() => mockStorage.getAllBlockDev(any())).thenAnswer(
        (final _) async => 'sda1',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '',
      );
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('25');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});

      await usbListener(Action.mount);

      verify(mockInputOutput.clear).called(2);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getAllBlockDev(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(1);
      verify(() => mockLang.write(18)).called(1);
      verify(() => mockLang.write(25)).called(2);
      verify(() => mockColorize.cyan('18')).called(1);
      verify(() => mockAttach.chooser(any())).called(1);
    });

    test('call usbListener unMount option successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => 'sdb');
      when(() => mockStorage.getAllBlockDev(any())).thenAnswer(
        (final _) async => 'sda1',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '/dev/sda1',
      );
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});

      await usbListener(Action.unmount);

      verify(mockInputOutput.clear).called(2);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getAllBlockDev(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(1);
      verify(() => mockLang.write(20)).called(1);
      verify(() => mockLang.write(25)).called(2);
      verify(() => mockColorize.cyan('20')).called(1);
      verify(() => mockAttach.chooser(any())).called(1);
      verify(() => mockUsbAction.call(any(), any())).called(1);
    });

    test('call usbListener poweroff option successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => '');
      when(() => mockStorage.getBlockDev(any())).thenAnswer(
        (final _) async => '/dev/sda',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '/dev/sda1',
      );
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});
      when(() => mockPowerOff.call(any())).thenAnswer((final _) async {});

      await usbListener(Action.off);

      verify(mockInputOutput.clear).called(2);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getBlockDev(any())).called(1);
      verify(() => mockLang.write(25)).called(2);
      verify(() => mockAttach.chooser(any())).called(1);
      verify(() => mockPowerOff.call(any())).called(1);
    });

    test('call usbListener poweroff option successfully', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => '');
      when(() => mockStorage.getBlockDev(any())).thenAnswer(
        (final _) async => '/dev/sda',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '/dev/sda1',
      );
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});
      when(() => mockPowerOff.call(any())).thenAnswer((final _) async {});

      await usbListener(Action.off);

      verify(mockInputOutput.clear).called(2);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getBlockDev(any())).called(1);
      verify(() => mockLang.write(25)).called(2);
      verify(() => mockAttach.chooser(any())).called(1);
      verify(() => mockPowerOff.call(any())).called(1);
    });

    test(
        'call usbListener onMount option '
        'with all mounted partitions', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => 'sdb');
      when(() => mockStorage.getAllBlockDev(any())).thenAnswer(
        (final _) async => 'sda1',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '/dev/sda1',
      );
      when(() => mockLang.write(17)).thenReturn('18');
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});
      when(mockAttach.readSync).thenReturn('');
      when(() => mockLang.write(7, PrintQuery.error)).thenReturn('7');

      await usbListener(Action.mount);

      verify(mockInputOutput.clear).called(3);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(mockAttach.readSync).called(1);
      verify(() => mockLang.write(7, PrintQuery.error)).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getAllBlockDev(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(1);
    });

    test(
        'call usbListener unMount option '
        'with all unmounted partitions', () async {
      when(mockInputOutput.clear).thenReturn(null);
      when(mockTui.spin).thenReturn(Timer(Duration(), () {}));
      when(mockStorage.checkUsbDevices).thenAnswer((final _) async => true);
      when(mockStorage.usbDevices).thenAnswer((final _) async => ['/dev/sda']);
      when(() => mockStorage.dirtyDev(any()))
          .thenAnswer((final _) async => 'sda');
      when(() => mockStorage.absoluteDev(any()))
          .thenAnswer((final _) async => 'sdb');
      when(() => mockStorage.getAllBlockDev(any())).thenAnswer(
        (final _) async => 'sda1',
      );
      when(() => mockStorage.mountUsbCheck(any())).thenAnswer(
        (final _) async => '',
      );
      when(() => mockLang.write(17)).thenReturn('18');
      when(() => mockLang.write(18)).thenReturn('18');
      when(() => mockLang.write(20)).thenReturn('20');
      when(() => mockLang.write(21)).thenReturn('21');
      when(() => mockLang.write(25)).thenReturn('25');
      when(() => mockColorize.cyan(any())).thenReturn(null);
      when(() => mockAttach.chooser(any())).thenReturn('');
      when(() => mockUsbAction.call(any(), any()))
          .thenAnswer((final _) async {});
      when(mockAttach.readSync).thenReturn('');
      when(() => mockLang.write(8, PrintQuery.error)).thenReturn('8');

      await usbListener(Action.unmount);

      verify(mockInputOutput.clear).called(3);
      verify(mockTui.spin).called(1);
      verify(mockStorage.checkUsbDevices).called(1);
      verify(mockStorage.usbDevices).called(1);
      verify(mockAttach.readSync).called(1);
      verify(() => mockLang.write(8, PrintQuery.error)).called(1);
      verify(() => mockStorage.dirtyDev(any())).called(1);
      verify(() => mockStorage.absoluteDev(any())).called(1);
      verify(() => mockStorage.getAllBlockDev(any())).called(1);
      verify(() => mockStorage.mountUsbCheck(any())).called(1);
    });
  });
}
