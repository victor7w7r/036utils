import 'dart:async' show unawaited;
import 'dart:io' show Process, exit;

import 'package:flutter/material.dart' hide Action;

import 'package:async/async.dart' show CancelableOperation;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:zerothreesix_dart/zerothreesix_dart.dart' hide yesNo;

import 'package:usb_manager_gui/core/core.dart';
import 'package:usb_manager_gui/widgets/dialog.dart';

CancelableOperation<dynamic> _cancellable =
    CancelableOperation.fromFuture(Future.value([]));

Future<List<String>> _usbAction(final String part, final bool isMount) =>
    codeout("udisksctl ${isMount ? 'mount' : 'unmount'} -b $part");

final class ManageController extends ChangeNotifier {
  ManageController(this._prefs, this._prefsMod)
      : _isEnabledRadio = true,
        _isLang = _prefsMod.isEng,
        _isLoading = false,
        items = [],
        noMountParts = false,
        noUmountParts = false,
        radioGroup = 1;

  final SharedPreferences _prefs;
  // ignore: unused_field
  final PrefsModule _prefsMod;
  bool _isEnabledRadio;
  bool _isLang;
  bool _isLoading;

  final List<String> items;
  int radioGroup;
  bool noMountParts;
  bool noUmountParts;

  void init() => unawaited(
        checkUid().then(
          (final val) => !val
              ? alert(
                  okIcon: true,
                  title: 'Error',
                  text: dict(0, _isLang),
                  onOk: () => exit(1),
                )
              : success('udisksctl').then(
                  (final udisk) => !udisk
                      ? alert(
                          okIcon: true,
                          title: 'Error',
                          text: dict(1, _isLang),
                          onOk: () => exit(1),
                        )
                      : Task(
                          () => Process.run(
                            'bash',
                            ['-c', 'systemctl is-active udisks2'],
                            runInShell: true,
                          ),
                        )
                          .map((final srvu) => (srvu.stdout as String).trim())
                          .run()
                          .then(
                            (final srv) => srv == 'inactive'
                                ? alert(
                                    okIcon: true,
                                    title: 'Error',
                                    text: dict(2, _isLang),
                                    onOk: () => exit(1),
                                  )
                                : listMountParts(),
                          ),
                ),
        ),
      );

  Future<void> listMountParts() async {
    unawaited(_cancellable.cancel());
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(usblistener(Action.mount))
        .then((final arr) {
      noMountParts = false;
      items.clear();
      if (arr[0] == 'NOUSB') {
        unawaited(
          alert(
            okIcon: true,
            title: 'Error',
            text: dict(3, _isLang),
            onOk: () => exit(0),
          ),
        );
      } else if (arr[0] == 'NOMOUNT') {
        noMountParts = true;
        isLoading = false;
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  Future<void> listUnmountParts() async {
    unawaited(_cancellable.cancel());
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(usblistener(Action.unmount))
        .then((final arr) {
      noUmountParts = false;
      items.clear();
      if (arr[0] == 'NOUSB') {
        unawaited(
          alert(
            okIcon: true,
            title: 'Error',
            text: dict(3, _isLang),
            onOk: () => exit(0),
          ),
        );
      } else if (arr[0] == 'NOUNMOUNT') {
        noUmountParts = true;
        isLoading = false;
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  Future<void> listPoweroffDevs() async {
    unawaited(_cancellable.cancel());
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(usblistener(Action.off))
        .then((final arr) {
      items.clear();
      if (arr[0] == 'NOUSB') {
        unawaited(
          alert(
            okIcon: true,
            title: 'Error',
            text: dict(3, _isLang),
            onOk: () => exit(0),
          ),
        );
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  void mountChange() {
    if (radioGroup != 1) {
      radioGroup = 1;
      notifyListeners();
      unawaited(listMountParts());
    }
  }

  void unmountChange() {
    if (radioGroup != 2) {
      radioGroup = 2;
      notifyListeners();
      unawaited(listUnmountParts());
    }
  }

  void poweroffChange() {
    if (radioGroup != 3) {
      radioGroup = 3;
      notifyListeners();
      unawaited(listPoweroffDevs());
    }
  }

  void requestManage(final BuildContext context, final String el) {
    if (radioGroup == 1) {
      isEnabledRadio = false;
      isLoading = true;
      unawaited(
        _usbAction(el, true).then((final _) {
          isEnabledRadio = true;
          listMountParts();
          snackBar(context, dict(9, _isLang));
        }),
      );
    } else if (radioGroup == 2) {
      isEnabledRadio = false;
      isLoading = true;
      unawaited(
        _usbAction(el, false).then((final _) {
          isEnabledRadio = true;
          listUnmountParts();
          snackBar(context, dict(10, _isLang));
        }),
      );
    } else {
      unawaited(
        yesNo(
          title: dict(6, _isLang),
          text: '${dict(7, _isLang)} $el ${dict(8, _isLang)}?',
          onYes: () {
            isEnabledRadio = false;
            isLoading = true;
            powerOff(context, _isLang, el).then((final _) {
              isEnabledRadio = true;
              listPoweroffDevs();
            });
          },
        ),
      );
    }
  }

  void update() => switch (radioGroup) {
        1 => unawaited(listMountParts()),
        2 => unawaited(listUnmountParts()),
        _ => unawaited(listPoweroffDevs())
      };

  bool get isEnabledRadio => _isEnabledRadio;

  set isEnabledRadio(final bool value) {
    _isEnabledRadio = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(final bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLang => _isLang;

  set isLang(final bool value) {
    _isLang = value;
    unawaited(
      _prefs.setBool('lang', isLang).then((final _) => notifyListeners()),
    );
  }
}

final manageController = ChangeNotifierProvider<ManageController>(
  (final ref) =>
      ManageController(ref.watch(sharedPrefs), ref.watch(prefsModule))..init(),
);
