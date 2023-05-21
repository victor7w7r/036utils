import 'package:flutter/material.dart' show VoidCallback;

import 'package:flutter_platform_alert/flutter_platform_alert.dart';

Future<dynamic> alert({
  required bool okIcon,
  required String title,
  required String text,
  required VoidCallback onOk
}) => FlutterPlatformAlert.showAlert(
  windowTitle: title,
  text: text,
  alertStyle: AlertButtonStyle.ok,
  iconStyle: okIcon
    ? IconStyle.information
    : IconStyle.error
).then((_) => onOk());

Future<dynamic> yesNo({
  required String title,
  required String text,
  required VoidCallback onYes,
}) => FlutterPlatformAlert.showAlert(
  windowTitle: title,
  text: text,
  alertStyle: AlertButtonStyle.yesNo,
  iconStyle: IconStyle.question
).then((btn) =>
  btn == AlertButton.yesButton ? onYes() : {}
);