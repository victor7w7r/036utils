import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:usb_manager/usb_manager.dart';

final class MockAttach extends Mock implements Attach {}

final class MockColorize extends Mock implements Colorize {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockUsbListener extends Mock implements UsbListener {}

void main() {
  group('App', () {
    late MockAttach mockAttach;
    late MockColorize mockColorize;
    late MockInputOutput mockInputOutput;
    late MockLang mockLang;
    late MockUsbListener mockUsbListener;
    late App app;

    setUp(() {
      mockAttach = MockAttach();
      mockColorize = MockColorize();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockUsbListener = MockUsbListener();
      app = App(
        mockAttach,
        mockColorize,
        mockInputOutput,
        mockLang,
        mockUsbListener,
      );
    });

    test('call app with mount option selected', () async {
      when(() => mockColorize.cyan('11')).thenReturn(null);
      when(() => mockLang.write(11)).thenReturn('11');
      when(() => mockLang.write(13)).thenReturn('13');
      when(() => mockLang.write(14)).thenReturn('14');
      when(() => mockLang.write(15)).thenReturn('15');
      when(() => mockLang.write(16)).thenReturn('16');

      when(() => mockAttach.chooser(['13', '14', '15', '16'])).thenReturn('13');
      when(() => mockUsbListener(Action.mount)).thenAnswer((final _) async {});

      await app(true);

      verify(() => mockColorize.cyan('11')).called(1);
      verify(() => mockLang.write(11)).called(1);
      verify(() => mockLang.write(13)).called(2);
      verify(() => mockLang.write(14)).called(1);
      verify(() => mockLang.write(15)).called(1);
      verify(() => mockLang.write(16)).called(1);
      verify(() => mockAttach.chooser(['13', '14', '15', '16'])).called(1);
      verify(() => mockUsbListener(Action.mount)).called(1);
    });

    test('call app with unmount option selected', () async {
      when(() => mockColorize.cyan('11')).thenReturn(null);
      when(() => mockLang.write(11)).thenReturn('11');
      when(() => mockLang.write(13)).thenReturn('13');
      when(() => mockLang.write(14)).thenReturn('14');
      when(() => mockLang.write(15)).thenReturn('15');
      when(() => mockLang.write(16)).thenReturn('16');

      when(() => mockAttach.chooser(['13', '14', '15', '16'])).thenReturn('14');
      when(() => mockUsbListener(Action.unmount))
          .thenAnswer((final _) async {});

      await app(true);

      verify(() => mockColorize.cyan('11')).called(1);
      verify(() => mockLang.write(11)).called(1);
      verify(() => mockLang.write(13)).called(2);
      verify(() => mockLang.write(14)).called(2);
      verify(() => mockLang.write(15)).called(1);
      verify(() => mockLang.write(16)).called(1);
      verify(() => mockAttach.chooser(['13', '14', '15', '16'])).called(1);
      verify(() => mockUsbListener(Action.unmount)).called(1);
    });

    test('call app with off option selected', () async {
      when(() => mockColorize.cyan('11')).thenReturn(null);
      when(() => mockLang.write(11)).thenReturn('11');
      when(() => mockLang.write(13)).thenReturn('13');
      when(() => mockLang.write(14)).thenReturn('14');
      when(() => mockLang.write(15)).thenReturn('15');
      when(() => mockLang.write(16)).thenReturn('16');

      when(() => mockAttach.chooser(['13', '14', '15', '16'])).thenReturn('15');
      when(() => mockUsbListener(Action.off)).thenAnswer((final _) async {});

      await app(true);

      verify(() => mockColorize.cyan('11')).called(1);
      verify(() => mockLang.write(11)).called(1);
      verify(() => mockLang.write(13)).called(2);
      verify(() => mockLang.write(14)).called(2);
      verify(() => mockLang.write(15)).called(2);
      verify(() => mockLang.write(16)).called(1);
      verify(() => mockAttach.chooser(['13', '14', '15', '16'])).called(1);
      verify(() => mockUsbListener(Action.off)).called(1);
    });

    test('call app with exit option selected', () async {
      when(() => mockColorize.cyan('11')).thenReturn(null);
      when(() => mockLang.write(11)).thenReturn('11');
      when(() => mockLang.write(13)).thenReturn('13');
      when(() => mockLang.write(14)).thenReturn('14');
      when(() => mockLang.write(15)).thenReturn('15');
      when(() => mockLang.write(16)).thenReturn('16');
      when(() => mockInputOutput.clear()).thenReturn(null);
      when(() => mockAttach.chooser(['13', '14', '15', '16'])).thenReturn('16');
      when(mockAttach.successExit).thenReturn(null);

      await app(true);

      verify(() => mockColorize.cyan('11')).called(1);
      verify(() => mockLang.write(11)).called(1);
      verify(() => mockLang.write(13)).called(2);
      verify(() => mockLang.write(14)).called(2);
      verify(() => mockLang.write(15)).called(2);
      verify(() => mockLang.write(16)).called(2);
      verify(() => mockInputOutput.clear()).called(1);
      verify(() => mockAttach.chooser(['13', '14', '15', '16'])).called(1);
      verify(mockAttach.successExit).called(1);
    });
  });
}
