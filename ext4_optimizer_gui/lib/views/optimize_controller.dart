import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' show CancelToken, Dio;
import 'package:ext4_optimizer_gui/config/system.dart';
import 'package:ext4_optimizer_gui/inject/inject.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:xterm/xterm.dart';

import 'package:ext4_optimizer_gui/config/config.dart';
import 'package:ext4_optimizer_gui/widgets/dialog.dart';

const _url =
  'https://github.com/victor7w7r/036utils/releases/'
  'download/1.0.0/ext4_optimizer_cli-amd64';

final downloadDir =
  '${inject.get<SharedPrefsModule>().tempPath}'
  '/ext4_optimizer_cli';

Future<bool> _download(
  final String url,
  final String savePath,
  final CancelToken cancel
) async {
  try {
    await Dio().download(
      url,savePath,
      cancelToken: cancel
    );
    return true;
  } catch (_) {
    return false;
  }
}

final class OptimizeController
  extends ChangeNotifier {

  final Terminal terminal;
  final TerminalController terminalCtrl;
  final List<String> parts;

  final CancelToken _cancel;
  Pty? _pty;
  bool _opMode;
  bool _isLang;
  bool _isOptimize;
  bool _isLoading;
  bool _isReady;

  OptimizeController():
    _cancel = CancelToken(),
    _isLang = inject.get<SharedPrefsModule>().isEng,
    _isLoading = false,
    _isOptimize = false,
    _isReady = false,
    _opMode = false,
    parts = [],
    terminal = Terminal(),
    terminalCtrl = TerminalController();

  void init() => success('e4defrag').then((val) =>
    !val ? alert(
      okIcon: true,
      title: 'Error',
      text: dict(1, _isLang),
      onOk: () => exit(1)
    ) : success('fsck.ext4').then((ext4) =>
      !ext4 ? alert(
        okIcon: true,
        title: 'Error',
        text: dict(2, _isLang),
        onOk: () => exit(1)
      ) : success('zenity').then((zen) =>
        !zen ? alert(
          okIcon: true,
          title: 'Error',
          text: dict(12, _isLang),
          onOk: () => exit(1)
        ) : ext4listener().then((query){
          if(query[0] == 'NOT') {
            alert(
              okIcon: true,
              title: 'Error',
              text: dict(3, _isLang),
              onOk: () => exit(1)
            );
          } else if(query[0] == 'FULL') {
            alert(
              okIcon: true,
              title: 'Error',
              text: dict(4, _isLang),
              onOk: () => exit(1)
            );
          } else {
            parts.addAll(query);
            notifyListeners();
          }
        })
      )
    )
  );

  void requestOptimize(
    final String part
  ) => yesNo(
    title: dict(6, _isLang),
    text: '${dict(7, _isLang)} $part ?',
    onYes: () {
      isLoading = true;
      _opMode = true;
      if(!File(downloadDir).existsSync()) {
        _download(_url, downloadDir, _cancel).then((res){
          if(res) {
            coderes('chmod +x $downloadDir').then((_){
              _isLoading = false;
              _initPty('sudo $downloadDir $part; exit');
              isOptimize = true;
            });
          } else {
            isLoading = false;
            alert(
              okIcon: false,
              title: 'Error',
              text: dict(10, _isLang),
              onOk: (){}
            );
          }
        });
      } else {
        _isLoading = false;
        _initPty('sudo $downloadDir $part; exit');
        isOptimize = true;
      }
    },
  );

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

    _pty!.exitCode.then((_) {
      isOptimize = false;
      ready = true;
      notifyListeners();
    });

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
      const Duration(milliseconds: 2000), (){
        terminal.keyInput(TerminalKey.enter);
        isOptimize = true;
        notifyListeners();
      }
    );
  }

  void exitOp() {
    if(isOptimize) {
      cancel();
      isOptimize = false;
    }
    opMode = false;
    _pty = null;
    _isReady = false;
  }


  void cancel(){
    terminal.charInput(99, ctrl: true);
    terminal.textInput('exit');
    terminal.keyInput(TerminalKey.enter);
  }


  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    inject.get<SharedPrefsModule>()
      .prefs.setBool('lang', isLang)
      .then((_) => notifyListeners());
  }

  bool get isOptimize => _isOptimize;

  set isOptimize(final bool val) {
    _isOptimize = val;
    notifyListeners();
  }

  bool get ready => _isReady;

  set ready(final bool val) {
    _isReady = val;
    notifyListeners();
  }

  bool get opMode => _opMode;

  set opMode(final bool val) {
    _opMode = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(final bool val) {
    _isLoading = val;
    notifyListeners();
  }

}

final optimizeController =
  ChangeNotifierProvider<OptimizeController>((_) =>
    OptimizeController()..init()
  );
