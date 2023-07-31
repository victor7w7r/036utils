import 'package:flutter/material.dart';

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
  iconStyle: okIcon ? IconStyle.information : IconStyle.error
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
).then((btn) => btn == AlertButton.yesButton ? onYes() : {});

dynamic snackBar(
  final BuildContext context,
  final String text
) => ScaffoldMessenger.of(context)
  .showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2)
  ));
