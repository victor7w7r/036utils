import 'dart:io' show exit, Process;

import 'package:async/async.dart' show CancelableOperation;
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ChangeNotifierProvider;
import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/config/index.dart';
import 'package:usb_manager_gui/utils/index.dart';
import 'package:usb_manager_gui/widgets/dialog.dart';

class ManageController extends ChangeNotifier {

  bool lang = locator.get<AppConfig>().isEng;

  int radioGroup = 1;

  bool loading = false;
  bool noMountParts = false;
  bool noUmountParts = false;
  bool enableRadio = true;

  final items = <String>[];

  Future<String> _block(String part) =>
    sysout("echo $part | cut -d \"/\" -f3");

  Future<List<String>> _partsQuery(String part) =>
    Task(() => _block(part))
      .flatMap((block) => Task(() => syssplit("find /dev -name \"$block[[:digit:]]\" | sort -n | sed 's/^\\/dev\\///'")))
      .run();

  Future<List<String>> _usbAction(String part, bool isMount)  =>
    syscodeout("udisksctl ${isMount ? 'mount' : 'unmount'} -b $part");

  Future<String> _modelQuery(String part) =>
    Task(() => _block(part))
      .flatMap((block) => Task(() => sysout("cat /sys/class/block/$block/device/model")))
      .run();

  Future<String> _mountQuery(String part) =>
    sysout("lsblk /dev/$part | sed -ne '/\\//p'");

  CancelableOperation cancellable =
    CancelableOperation.fromFuture(Future.value());

  void init() => checkUid().then((val) =>
    !val ? alert(
      okIcon: true,
      title: "Error",
      text: dict(0, lang),
      onOk: () => exit(1)
    ) : verifycmd("udisksctl").then((val) =>
      !val ? alert(
        okIcon: true,
        title: "Error",
        text: dict(1, lang),
        onOk: () => exit(1)
      ) : Task(() => Process.run(
        "bash",
        ["-c", "systemctl is-active udisks2"],
        runInShell: true
      ))
        .map((srvu) => (srvu.stdout as String).trim())
        .run()
        .then((srv) => srv == "inactive" ? alert(
          okIcon: true,
          title: "Error",
          text: dict(2, lang),
          onOk: () => exit(1)
        ) : listMountParts()
      )
    )
  );

  void listMountParts() {
    cancellable.cancel();
    loading = true;
    notifyListeners();
    cancellable = CancelableOperation.fromFuture(usblistener(Action.mount)).then((arr){
      noMountParts = false;
      items.clear();
      if(arr[0] == "NOUSB") {
        alert(
          okIcon: true,
          title: "Error",
          text: dict(3, lang),
          onOk: () => exit(0)
        );
      } else if(arr[0] == "NOMOUNT") {
        noMountParts = true;
        loading = false;
        notifyListeners();
      } else {
        items.addAll(arr);
        loading = false;
        notifyListeners();
      }
    });
  }

  void listUnmountParts() {
    cancellable.cancel();
    loading = true;
    notifyListeners();
    cancellable = CancelableOperation.fromFuture(usblistener(Action.unmount)).then((arr){
      noUmountParts = false;
      items.clear();
      if(arr[0] == "NOUSB") {
        alert(
          okIcon: true,
          title: "Error",
          text: dict(3, lang),
          onOk: () => exit(0)
        );
      } else if(arr[0] == "NOUNMOUNT") {
        noUmountParts = true;
        loading = false;
        notifyListeners();
      } else {
        items.addAll(arr);
        loading = false;
        notifyListeners();
      }
    });
  }

  void listPoweroffDevs() {
    cancellable.cancel();
    loading = true;
    notifyListeners();
    cancellable = CancelableOperation.fromFuture(usblistener(Action.off)).then((arr){
      items.clear();
      if(arr[0] == "NOUSB") {
        alert(
          okIcon: true,
          title: "Error",
          text: dict(3, lang),
          onOk: () => exit(0)
        );
      } else {
        items.addAll(arr);
        loading = false;
        notifyListeners();
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

  void update() {
    if(radioGroup == 1) {
      listMountParts();
    } else if(radioGroup == 2) {
      listUnmountParts();
    } else {
      listPoweroffDevs();
    }
  }

  void requestManage(BuildContext context, String el) {
    if(radioGroup == 1) {
      loading = true;
      enableRadio = false;
      notifyListeners();
      _usbAction(el, true).then((_){
        enableRadio = true;
        notifyListeners();
        listMountParts();
        snackBar(context, dict(9, lang));
      });
    } else if(radioGroup == 2) {
      loading = true;
      enableRadio = false;
      notifyListeners();
      _usbAction(el, false).then((_){
        enableRadio = true;
        notifyListeners();
        listUnmountParts();
        snackBar(context, dict(10, lang));
      });
    } else {
      yesNo(
        title: dict(6, lang),
        text: "${dict(7, lang)} $el ${dict(8, lang)}?",
        onYes: () {
          loading = true;
          enableRadio = false;
          notifyListeners();
          powerOff(context, el).then((_){
            enableRadio = true;
            notifyListeners();
            listPoweroffDevs();
          });
        }
      );
    }
  }

  Future<void> powerOff(BuildContext context, String part) async {

    final mounts = <String>[];

    final partitionsQuery = await _partsQuery(part);
    partitionsQuery.removeWhere((e) => e == '');

    for(final parts in partitionsQuery) {
      if(await _mountQuery(parts) != "") mounts.add(parts);
    }

    if(mounts.isNotEmpty) {
      for(final partition in mounts) {
        if(await codeproc("udisksctl unmount -b /dev/$partition &> /dev/null") != 0) {
          snackBar(context, dict(12, lang));
          return;
        }
      }
    }

    final model = await _modelQuery(part);
    final powerOff = await codeproc("udisksctl power-off -b $part");

    powerOff == 0
      ? snackBar(context, "${dict(11, lang)} $model")
      : snackBar(context, "${dict(13, lang)} $model");
  }

  Future<void> toggleLang() async {
    lang = !lang;
    await locator.get<AppConfig>().prefs.setBool('lang', lang);
    notifyListeners();
  }

}

final manageController = ChangeNotifierProvider<ManageController>((_) =>
  ManageController()..init()
);