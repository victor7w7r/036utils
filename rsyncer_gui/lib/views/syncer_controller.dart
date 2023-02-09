import 'dart:convert';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;
import 'package:xterm/xterm.dart';

import 'package:rsyncer_gui/config/index.dart';
import 'package:rsyncer_gui/utils/commands.dart';

class SyncerController extends ChangeNotifier {

  final terminal = Terminal();
  final terminalController = TerminalController();

  Pty? pty;

  bool syncMode = false;
  bool isSyncing = false;

  bool lang = locator.get<AppConfig>().isEng;

  String sourceDir = "";
  String destDir = "";

  Future<bool> checkPermission(String dir) =>
    Task(() => sysout('if [ -w $dir ]; then echo "y"; else echo "n"; fi'))
      .map((res) => res == "y")
      .run();

  void init() => verifycmd("rsync").then((ex) =>
    !ex ? FlutterPlatformAlert.showAlert(
      windowTitle: 'Error',
      text: dict(4, lang),
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error
    ).then((_) => exit(1)) : {}
  );

  void initPty(String cmd) {

    pty = Pty.start(
      "bash",
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

    pty!.output
      .cast<List<int>>()
      .transform(const Utf8Decoder())
      .listen(terminal.write);

    pty!.exitCode.then((_) {
      isSyncing = false;
      notifyListeners();
    });

    terminal.onOutput = (data) => pty!.write(const Utf8Encoder().convert(data));
    terminal.onResize = (w, h, _, __) => pty!.resize(h, w);

    Future.delayed(const Duration(seconds: 1), () => terminal.textInput(cmd));
    Future.delayed(const Duration(milliseconds: 1400), (){
      terminal.keyInput(TerminalKey.enter);
      isSyncing = true;
      notifyListeners();
    });
  }

  Future<void> requestSync() async {
    final chk1 = await checkPermission(sourceDir);
    final chk2 = await checkPermission(destDir);

    chk1 && chk2
      ? initPty("rsync -axHAWXS --numeric-ids --info=progress2 $sourceDir $destDir && exit")
      : initPty("sudo rsync -axHAWXS --numeric-ids --info=progress2 $sourceDir $destDir; exit");

    syncMode = true;
    notifyListeners();

  }

  void changeSourceDir(String dir) {
    sourceDir = dir;
    notifyListeners();
  }

  void changeDestDir(String dir) {
    destDir = dir;
    notifyListeners();
  }

  void exitOp() {
    if(isSyncing) {
      cancel();
      isSyncing = false;
    }
    syncMode = false;
    pty = null;
    notifyListeners();
  }

  void cancel(){
    terminal.charInput(99, ctrl: true);
    terminal.textInput("exit");
    terminal.keyInput(TerminalKey.enter);
  }

  Future<void> toggleLang() async {
    lang = !lang;
    await locator.get<AppConfig>().prefs.setBool('lang', lang);
    notifyListeners();
  }

}

final syncerController = ChangeNotifierProvider<SyncerController>((_) =>
  SyncerController()..init()
);