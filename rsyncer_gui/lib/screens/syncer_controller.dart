import 'dart:async' show unawaited;
import 'dart:convert' show Utf8Decoder, Utf8Encoder;
import 'dart:io' show exit;

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart' show FilePicker;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:xterm/xterm.dart';

import 'package:rsyncer_gui/core/core.dart';

Future<bool> _checkPermission(final String dir) => Task(
      () => sys('if [ -w $dir ]; then echo "y";'
          ' else echo "n"; fi'),
    ).map((final res) => res == 'y').run();

Future<String?> dirPick() =>
    FilePicker.platform.getDirectoryPath(lockParentWindow: true);

final class SyncerController extends ChangeNotifier {
  SyncerController(this._prefs, this._prefsMod)
      : _destDir = '',
        _isSyncing = false,
        _isLang = _prefsMod.isEng,
        _syncMode = false,
        _sourceDir = '',
        terminal = Terminal(),
        terminalCtrl = TerminalController();

  final SharedPreferences _prefs;
  // ignore: unused_field
  final PrefsModule _prefsMod;
  String _destDir;
  bool _isSyncing;
  bool _isLang;
  Pty? _pty;
  String _sourceDir;
  bool _syncMode;

  final Terminal terminal;
  final TerminalController terminalCtrl;

  void _initPty(final String cmd) {
    _pty = Pty.start(
      'bash',
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

    _pty!.output
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .listen(terminal.write);

    unawaited(_pty!.exitCode.then((final _) => isSyncing = false));

    terminal.onOutput =
        (final data) => _pty!.write(const Utf8Encoder().convert(data));

    // ignore: cascade_invocations
    terminal.onResize =
        (final w, final h, final _, final __) => _pty!.resize(h, w);

    Future.delayed(const Duration(seconds: 1), () => terminal.textInput(cmd));

    Future.delayed(const Duration(milliseconds: 1400), () {
      terminal.keyInput(TerminalKey.enter);
      isSyncing = true;
    });
  }

  void cancel() => terminal
    ..charInput(99, ctrl: true)
    ..textInput('exit')
    ..keyInput(TerminalKey.enter);

  void exitOp() {
    if (isSyncing) {
      cancel();
      isSyncing = false;
    }
    syncMode = false;
    _pty = null;
  }

  void init() => unawaited(
        success('rsync').then(
          (final ex) => !ex
              ? FlutterPlatformAlert.showAlert(
                  windowTitle: 'Error',
                  text: dict(3, isLang),
                  iconStyle: IconStyle.error,
                ).then((final _) => exit(1))
              : success('zenity').then(
                  (final zen) => !zen
                      ? FlutterPlatformAlert.showAlert(
                          windowTitle: 'Error',
                          text: dict(5, isLang),
                          iconStyle: IconStyle.error,
                        ).then((final _) => exit(1))
                      : {},
                ),
        ),
      );

  Future<void> requestSync() async {
    final chk1 = await _checkPermission(_sourceDir);
    final chk2 = await _checkPermission(_destDir);
    _initPty('${chk1 && chk2 ? 'sudo' : ''} '
        'rsync -axHAWXS --numeric-ids '
        '--info=progress2 $sourceDir $destDir; exit');
    syncMode = true;
  }

  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    unawaited(
      _prefs.setBool('lang', isLang).then((final _) => notifyListeners()),
    );
  }

  bool get isSyncing => _isSyncing;

  set isSyncing(final bool val) {
    _isSyncing = val;
    notifyListeners();
  }

  bool get syncMode => _syncMode;

  set syncMode(final bool val) {
    _syncMode = val;
    notifyListeners();
  }

  String get sourceDir => _sourceDir;

  set sourceDir(final String val) {
    _sourceDir = val;
    notifyListeners();
  }

  String get destDir => _destDir;

  set destDir(final String val) {
    _destDir = val;
    notifyListeners();
  }
}

final syncerController = ChangeNotifierProvider<SyncerController>(
  (final ref) =>
      SyncerController(ref.watch(sharedPrefs), ref.watch(prefsModule))..init(),
);
