import 'dart:async';

import 'package:flutter_open_file/src/model/flutter_open_result.dart';

import 'web.dart' as web;

class FlutterOpenFile {
  static Future<FlutterOpenResult> open(String filePath,
      {String? type, String? uti, String linuxDesktopName = "xdg"}) async {
    final b = await web.open("file://$filePath");
    return FlutterOpenResult(
        type: b ? ResultType.done : ResultType.error,
        message: b ? "done" : "there are some errors when open $filePath");
  }
}
