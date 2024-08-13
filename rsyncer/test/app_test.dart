import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart';

import 'package:rsyncer/rsyncer.dart';

final class MockAttach extends Mock implements Attach {}

final class MockSystem extends Mock implements System {}

final class MockInputOutput extends Mock implements InputOutput {}

final class MockLang extends Mock implements Lang {}

final class MockSync extends Mock implements Sync {}

void main() {
  group('App', () {
    late MockAttach mockAttach;
    late MockLang mockLang;
    late MockInputOutput mockInputOutput;
    late MockSystem mockSystem;
    late MockSync mockSync;

    late App app;

    setUp(() {
      mockAttach = MockAttach();
      mockInputOutput = MockInputOutput();
      mockLang = MockLang();
      mockSync = MockSync();
      mockSystem = MockSystem();

      app = App(mockAttach, mockInputOutput, mockLang, mockSync, mockSystem);
    });

    test(
        'call app when typeData is source,'
        ' data is not empty and directory exists', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '/test');
      when(() => mockLang.write(any())).thenReturn('');
      when(() => mockSystem.directoryCheck(any())).thenReturn(true);

      await app(true);

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
      verify(() => mockSystem.directoryCheck(any())).called(1);
    });

    test(
        'call app when typeData is source,'
        ' data is not empty and directory does not exist', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '/test');
      when(() => mockLang.write(3, PrintQuery.error, any())).thenReturn('');
      when(() => mockLang.write(10, PrintQuery.normal)).thenReturn('');
      when(() => mockLang.write(any())).thenReturn('');
      when(mockAttach.readSync).thenReturn('');

      when(() => mockSystem.directoryCheck(any())).thenReturn(false);

      await app(true);

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
      verify(() => mockSystem.directoryCheck(any())).called(1);
    });

    test(
        'call app when typeData is source,'
        ' data is empty and directory does not exist', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '');
      when(() => mockLang.write(any())).thenReturn('');
      when(mockAttach.readSync).thenReturn('');
      when(mockAttach.successExit).thenReturn(null);

      when(() => mockSystem.directoryCheck(any())).thenReturn(false);

      await app(true);

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
      verify(mockInputOutput.clear).called(1);
      verify(mockAttach.successExit).called(1);
    });

    test(
        'call app when typeData is dest,'
        ' data is not empty and directory exists', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '/test');
      when(() => mockLang.write(any())).thenReturn('');
      when(() => mockSystem.directoryCheck(any())).thenReturn(true);
      when(() => mockSync(any(), any())).thenAnswer((final _) async {});

      await app.callDest();

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
      verify(() => mockSystem.directoryCheck(any())).called(1);
      verify(() => mockSync(any(), any())).called(1);
    });

    test(
        'call app when typeData is dest,'
        ' data is not empty and directory does not exist', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '/test');
      when(() => mockLang.write(3, PrintQuery.error, any())).thenReturn('');
      when(() => mockLang.write(10, PrintQuery.normal)).thenReturn('');
      when(() => mockLang.write(any())).thenReturn('');
      when(mockAttach.readSync).thenReturn('');

      when(() => mockSystem.directoryCheck(any())).thenReturn(false);

      await app.callDest();

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
      verify(() => mockSystem.directoryCheck(any())).called(1);
    });

    test(
        'call app when typeData is dest,'
        ' data is empty and directory does not exist', () async {
      when(() => mockAttach.readMessage(any()))
          .thenAnswer((final _) async => '');
      when(() => mockLang.write(any())).thenReturn('');

      await app.callDest();

      verify(() => mockAttach.readMessage(any())).called(1);
      verify(() => mockLang.write(any())).called(1);
    });
  });
}
