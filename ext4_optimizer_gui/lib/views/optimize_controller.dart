import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' show CancelToken;

import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:xterm/xterm.dart';

import 'package:ext4_optimizer_gui/config/index.dart';
import 'package:ext4_optimizer_gui/utils/index.dart';
import 'package:ext4_optimizer_gui/widgets/dialog.dart';

class OptimizeController extends ChangeNotifier {

  final terminal = Terminal();
  final terminalController = TerminalController();

  final parts = <String>[];

  bool opMode = false;
  bool isOptimize = false;
  bool loading = false;
  bool ready = false;

  final _app = locator.get<AppConfig>();
  final _url = "https://github.com/victor7w7r/036utils/releases/download/1.0.0/ext4_optimizer_cli-amd64";
  final _cancel = CancelToken();

  Pty? pty;

  bool lang = locator.get<AppConfig>().isEng;

  void init() =>
    verifycmd("e4defrag").then((val) =>
      !val ? alert(
        okIcon: true,
        title: "Error",
        text: dict(1, lang),
        onOk: () => exit(1)
      ) : verifycmd("fsck.ext4").then((val) =>
        !val ? alert(
          okIcon: true,
          title: "Error",
          text: dict(2, lang),
          onOk: () => exit(1)
        ) : ext4listener().then((query){
          if(query[0] == "NOT") {
            alert(
              okIcon: true,
              title: "Error",
              text: dict(3, lang),
              onOk: () => exit(1)
            );
          } else if(query[0] == "FULL") {
            alert(
              okIcon: true,
              title: "Error",
              text: dict(4, lang),
              onOk: () => exit(1)
            );
          } else {
            parts.addAll(query);
            notifyListeners();
          }
        })
      )
    );

  void requestOptimize(String part) => yesNo(
    title: dict(6, lang),
    text: "${dict(7, lang)} $part ?",
    onYes: () {
      loading = true;
      opMode = true;
      notifyListeners();
      final location = '${_app.tempPath}/ext4_optimizer_cli';
      if(!File(location).existsSync()) {
        download(_url, location, _cancel).then((res){
          if(res) {
            codeproc("chmod +x ${_app.tempPath}/ext4_optimizer_cli").then((_){
              loading = false;
              initPty("sudo $location $part; exit");
              isOptimize = true;
              notifyListeners();
            });
          } else {
            loading = false;
            alert(okIcon: false, title: "Error", text: dict(10, lang), onOk: (){});
            notifyListeners();
          }
        });
      } else {
        loading = false;
        initPty("sudo $location $part; exit");
        isOptimize = true;
        notifyListeners();
      }
    },
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
      isOptimize = false;
      ready = true;
      notifyListeners();
    });

    terminal.onOutput = (data) => pty!.write(const Utf8Encoder().convert(data));
    terminal.onResize = (w, h, _, __) => pty!.resize(h, w);

    Future.delayed(const Duration(seconds: 1), () => terminal.textInput(cmd));
    Future.delayed(const Duration(milliseconds: 2000), (){
      terminal.keyInput(TerminalKey.enter);
      isOptimize = true;
      notifyListeners();
    });
  }

  void exitOp() {
    if(isOptimize) {
      cancel();
      isOptimize = false;
    }
    opMode = false;
    pty = null;
    ready = false;
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

final optimizeController = ChangeNotifierProvider<OptimizeController>((_) =>
  OptimizeController()..init()
);