import 'package:dio/dio.dart';

Future<bool> download(String url, String savePath, CancelToken cancel) async {
  try {
    await Dio().download(url, savePath, cancelToken: cancel);
    return true;
  } catch (_) {
    return false;
  }
}