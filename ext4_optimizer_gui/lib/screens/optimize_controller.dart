import 'dart:async' show unawaited;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart' show Pty;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:xterm/xterm.dart';
import 'package:zerothreesix_dart/zerothreesix_dart.dart' hide yesNo;

import 'package:ext4_optimizer_gui/core/core.dart';
import 'package:ext4_optimizer_gui/widgets/dialog.dart';

const _url =
  'https://github.com/victor7w7r/036utils/releases/'
  'download/1.0.0/ext4_optimizer_cli-amd64';

Future<String> _downloadDir() =>
  const Task(getTemporaryDirectory)
    .map((final dir) => '${dir.path}/ext4_optimizer_cli')
    .run();

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
  } on DioException catch (_) {
    return false;
  }
}

final class OptimizeController
  extends ChangeNotifier {

  OptimizeController(
    this._prefs,
    this._prefsMod
  ):
    _cancel = CancelToken(),
    _isLang =  _prefsMod.isEng,
    _isLoading = false,
    _isOptimize = false,
    _isReady = false,
    _opMode = false,
    parts = [],
    terminal = Terminal(),
    terminalCtrl = TerminalController();

  final SharedPreferences _prefs;
  // ignore: unused_field
  final PrefsModule _prefsMod;
  final CancelToken _cancel;
  Pty? _pty;
  bool _opMode;
  bool _isLang;
  bool _isOptimize;
  bool _isLoading;
  bool _isReady;

  final Terminal terminal;
  final TerminalController terminalCtrl;
  final List<String> parts;

  void init() => unawaited(success('e4defrag').then((final val) =>
    !val ? alert(
      okIcon: true,
      title: 'Error',
      text: dict(1, _isLang),
      onOk: () => exit(1)
    ) : success('fsck.ext4').then((final ext4) =>
      !ext4 ? alert(
        okIcon: true,
        title: 'Error',
        text: dict(2, _isLang),
        onOk: () => exit(1)
      ) : success('zenity').then((final zen) =>
        !zen ? alert(
          okIcon: true,
          title: 'Error',
          text: dict(12, _isLang),
          onOk: () => exit(1)
        ) : ext4listener().then((final query){
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
  ));

  void requestOptimize(
    final String part
  ) => unawaited(yesNo(
    title: dict(6, _isLang),
    text: '${dict(7, _isLang)} $part ?',
    onYes: () async {
      isLoading = true;
      _opMode = true;
      final downloadDir = await _downloadDir();
      if(!File(downloadDir).existsSync()) {
        unawaited(_download(_url, downloadDir, _cancel).then((final res){
          if(res) {
            coderes('chmod +x $downloadDir').then((final _){
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
        }));
      } else {
        _isLoading = false;
        _initPty('sudo $downloadDir $part; exit');
        isOptimize = true;
      }
    },
  ));

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

    unawaited(_pty!.exitCode.then((final _) {
      isOptimize = false;
      ready = true;
      notifyListeners();
    }));

    terminal.onOutput = (final data) => _pty!.write(
      const Utf8Encoder().convert(data)
    );

    // ignore: cascade_invocations
    terminal.onResize = (final w, final h, final _, final __) =>
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

  void cancel() => terminal
    ..charInput(99, ctrl: true)
    ..textInput('exit')
    ..keyInput(TerminalKey.enter);

  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    unawaited(_prefs
      .setBool('lang', isLang)
      .then((final _) => notifyListeners())
    );
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
  ChangeNotifierProvider<OptimizeController>((final ref) =>
    OptimizeController(
      ref.watch(prefsModule),
      ref.watch(sharedPrefs)
    )..init()
  );
