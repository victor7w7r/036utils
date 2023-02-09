import 'package:file_picker/file_picker.dart' show FilePicker;

Future<String?> dirPick() =>
  FilePicker.platform.getDirectoryPath(lockParentWindow: true);