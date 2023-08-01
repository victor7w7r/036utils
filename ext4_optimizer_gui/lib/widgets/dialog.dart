import 'package:flutter/material.dart' show VoidCallback;

import 'package:flutter_platform_alert/flutter_platform_alert.dart';

Future<dynamic> alert({
  required final bool okIcon,
  required final String title,
  required final String text,
  required final VoidCallback onOk
}) => FlutterPlatformAlert.showAlert(
  windowTitle: title,
  text: text,
  iconStyle: okIcon
    ? IconStyle.information
    : IconStyle.error
).then((final _) => onOk());

Future<dynamic> yesNo({
  required final String title,
  required final String text,
  required final VoidCallback onYes,
}) => FlutterPlatformAlert.showAlert(
  windowTitle: title,
  text: text,
  alertStyle: AlertButtonStyle.yesNo,
  iconStyle: IconStyle.question
).then((final btn) =>
  btn == AlertButton.yesButton ? onYes() : {}
);
