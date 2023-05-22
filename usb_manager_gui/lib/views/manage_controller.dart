import 'dart:io' show exit, Process;

import 'package:flutter/material.dart' hide Action;

import 'package:async/async.dart' show CancelableOperation;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/config/config.dart';
import 'package:usb_manager_gui/inject/inject.dart';
import 'package:usb_manager_gui/widgets/dialog.dart';

CancelableOperation _cancellable =
  CancelableOperation.fromFuture(Future.value());

Future<List<String>> _usbAction(
  final String part,
  final bool isMount
) => codeout(
  "udisksctl ${isMount ? 'mount' : 'unmount'} -b $part"
);

final class ManageController extends ChangeNotifier {

  bool _isEnabledRadio;
  bool _isLang;
  bool _isLoading;
  final List<String> items;

  int radioGroup;
  bool noMountParts;
  bool noUmountParts;

  ManageController():
    _isEnabledRadio = true,
    _isLang = inject.get<SharedPrefsModule>().isEng,
    _isLoading = false,
    items = [],
    noMountParts = false,
    noUmountParts = false,
    radioGroup = 1;

  void init() => checkUid().then((val) =>
    !val ? alert(
      okIcon: true,
      title: 'Error',
      text: dict(0, _isLang),
      onOk: () => exit(1)
    ) : success('udisksctl').then((udisk) =>
      !udisk ? alert(
        okIcon: true,
        title: 'Error',
        text: dict(1, _isLang),
        onOk: () => exit(1)
      ) : Task(() => Process.run(
        'bash',
        ['-c', 'systemctl is-active udisks2'],
        runInShell: true
      ))
        .map((srvu) => (srvu.stdout as String).trim())
        .run()
        .then((srv) => srv == 'inactive' ? alert(
          okIcon: true,
          title: 'Error',
          text: dict(2, _isLang),
          onOk: () => exit(1)
        ) : listMountParts()
      )
    )
  );

  void listMountParts() {
    _cancellable.cancel();
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(
      usblistener(Action.mount)
    ).then((arr){
      noMountParts = false;
      items.clear();
      if(arr[0] == 'NOUSB') {
        alert(
          okIcon: true,
          title: 'Error',
          text: dict(3, _isLang),
          onOk: () => exit(0)
        );
      } else if(arr[0] == 'NOMOUNT') {
        noMountParts = true;
        isLoading = false;
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  void listUnmountParts() {
    _cancellable.cancel();
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(
      usblistener(Action.unmount)
    ).then((arr){
      noUmountParts = false;
      items.clear();
      if(arr[0] == 'NOUSB') {
        alert(
          okIcon: true,
          title: 'Error',
          text: dict(3, _isLang),
          onOk: () => exit(0)
        );
      } else if(arr[0] == 'NOUNMOUNT') {
        noUmountParts = true;
        isLoading = false;
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  void listPoweroffDevs() {
    _cancellable.cancel();
    isLoading = true;
    _cancellable = CancelableOperation.fromFuture(
      usblistener(Action.off)
    ).then((arr){
      items.clear();
      if(arr[0] == 'NOUSB') {
        alert(
          okIcon: true,
          title: 'Error',
          text: dict(3, _isLang),
          onOk: () => exit(0)
        );
      } else {
        items.addAll(arr);
        isLoading = false;
      }
    });
  }

  void mountChange() {
    if(radioGroup != 1) {
      radioGroup = 1;
      notifyListeners();
      listMountParts();
    }
  }

  void unmountChange() {
    if(radioGroup != 2) {
      radioGroup = 2;
      notifyListeners();
      listUnmountParts();
    }
  }

  void poweroffChange() {
    if(radioGroup != 3) {
      radioGroup = 3;
      notifyListeners();
      listPoweroffDevs();
    }
  }


  void requestManage(
    final BuildContext context,
    final String el
  ) {
    if(radioGroup == 1) {
      isEnabledRadio = false;
      isLoading = true;
      _usbAction(el, true).then((_){
        isEnabledRadio = true;
        listMountParts();
        snackBar(context, dict(9, _isLang));
      });
    } else if(radioGroup == 2) {
      isEnabledRadio = false;
      isLoading = true;
      _usbAction(el, false).then((_){
        isEnabledRadio = true;
        listUnmountParts();
        snackBar(context, dict(10, _isLang));
      });
    } else {
      yesNo(
        title: dict(6, _isLang),
        text: '${dict(7, _isLang)} $el ${dict(8, _isLang)}?',
        onYes: () {
          isEnabledRadio = false;
          isLoading = true;
          powerOff(context, _isLang, el).then((_){
            isEnabledRadio = true;
            listPoweroffDevs();
          });
        }
      );
    }
  }

  void update() =>
    switch(radioGroup) {
      1 => listMountParts(),
      2 => listUnmountParts(),
      _ => listPoweroffDevs()
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
    inject.get<SharedPrefsModule>()
      .prefs.setBool('lang', isLang)
      .then((_) => notifyListeners());
  }

}

final manageController =
  ChangeNotifierProvider<ManageController>((_) =>
    ManageController()..init()
  );