import 'dart:convert';
import 'dart:io' show exit;

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart' show FilePicker;
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;
import 'package:xterm/xterm.dart';

import 'package:rsyncer_gui/config/config.dart';
import 'package:rsyncer_gui/inject/inject.dart';

Future<bool> _checkPermission(
  final String dir
) => Task(() => sys(
    'if [ -w $dir ]; then echo "y";'
    ' else echo "n"; fi'
  ))
  .map((res) => res == 'y')
  .run();

Future<String?> dirPick() => FilePicker
  .platform
  .getDirectoryPath(lockParentWindow: true);

final class SyncerController extends ChangeNotifier {

  final Terminal terminal;
  final TerminalController terminalCtrl;
  String _destDir;
  bool _isSyncing;
  bool _isLang;
  Pty? _pty;
  String _sourceDir;
  bool _syncMode;

  SyncerController():
    _destDir = '',
    _isSyncing = false,
    _isLang = inject.get<SharedPrefsModule>().isEng,
    _syncMode = false,
    _sourceDir = '',
    terminal = Terminal(),
    terminalCtrl = TerminalController();

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

    _pty!.exitCode.then((_) =>
      isSyncing = false
    );

    terminal.onOutput = (data) => _pty!.write(
      const Utf8Encoder().convert(data)
    );

    terminal.onResize = (w, h, _, __) =>
      _pty!.resize(h, w);

    Future.delayed(
      const Duration(seconds: 1),
      () => terminal.textInput(cmd)
    );

    Future.delayed(
      const Duration(milliseconds: 1400), (){
        terminal.keyInput(TerminalKey.enter);
        isSyncing = true;
      }
    );
  }

  void cancel() {
    terminal.charInput(99, ctrl: true);
    terminal.textInput('exit');
    terminal.keyInput(TerminalKey.enter);
  }

  void exitOp() {
    if(isSyncing) {
      cancel();
      isSyncing = false;
    }
    syncMode = false;
    _pty = null;
  }

    void init() => verify('rsync').then((ex) =>
    !ex ? FlutterPlatformAlert.showAlert(
      windowTitle: 'Error',
      text: dict(3, isLang),
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error
    ).then((_) => exit(1)) : verify('zenity').then((zen) =>
      !zen ? FlutterPlatformAlert.showAlert(
        windowTitle: 'Error',
        text: dict(5, isLang),
        alertStyle: AlertButtonStyle.ok,
        iconStyle: IconStyle.error
      ).then((_) => exit(1)) : {}
    )
  );

  Future<void> requestSync() async {
    final chk1 = await _checkPermission(_sourceDir);
    final chk2 = await _checkPermission(_destDir);
    _initPty('${chk1 && chk2 ? 'sudo' : ''} '
      'rsync -axHAWXS --numeric-ids '
      '--info=progress2 $sourceDir $destDir; exit'
    );
    syncMode = true;
  }

  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    inject.get<SharedPrefsModule>()
      .prefs.setBool('lang', isLang)
      .then((_) => notifyListeners());
  }

  bool get isSyncing => _isSyncing;

  set isSyncing(bool val) {
    _isSyncing = val;
    notifyListeners();
  }

  bool get syncMode => _syncMode;

  set syncMode(bool val) {
    _syncMode = val;
    notifyListeners();
  }

  String get sourceDir => _sourceDir;

  set sourceDir(String val) {
    _sourceDir = val;
    notifyListeners();
  }

  String get destDir => _destDir;

  set destDir(String val) {
    _destDir = val;
    notifyListeners();
  }

}

final syncerController =
  ChangeNotifierProvider<SyncerController>((_) =>
    SyncerController()..init()
  );