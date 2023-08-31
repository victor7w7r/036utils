import 'package:fpdart/fpdart.dart' show Task;

import 'package:usb_manager_gui/core/system.dart';

const _usbList =
  "find /dev/disk/by-id/ -name 'usb*' "
  '| sort -n '
  r"| sed 's/^\/dev\/disk\/by-id\///'";

Future<List<String>> usbDevices() =>
  syssplit(_usbList);

Future<bool> checkUsbDevices() =>
  Task(() => sys(_usbList))
    .map((final res) => res == '')
    .run();

Future<String> dirtyDev(
  final String dev
) => syswline(
  'readlink "/dev/disk/by-id/$dev"'
);

Future<String> absoluteDev(
  final String dev
) => sys(
  'echo $dev '
  r"| sed 's/^\.\.\/\.\.\//\/dev\//' "
  r"| sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'"
);

Future<String> mountUsbCheck(
  final String part
) => sys("lsblk /dev/$part | sed -ne '/\\//p'");

Future<String> getBlockDev(
  final String dev
) => syswline("echo $dev | sed 's/^\\.\\.\\/\\.\\.\\///'");

Future<String> getAllBlockDev(
  final String dev
) => syswline(
  'echo $dev '
  r"| sed 's/^\.\.\/\.\.\///' "
  r"| sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'"
);
