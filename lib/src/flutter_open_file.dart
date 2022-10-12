import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_open_file/src/model/flutter_open_result.dart';
import 'plaform/macos.dart' as mac;
import 'plaform/windows.dart' as windows;
import 'plaform/linux.dart' as linux;

class FlutterOpenFile {
  static const MethodChannel _channel = MethodChannel('open_file');

  FlutterOpenFile._();

  ///linuxDesktopName like 'xdg'/'gnome'
  static Future<FlutterOpenResult> open(String? filePath,
      {String? type,
      String? uti,
      String linuxDesktopName = "xdg",
      bool linuxByProcess = false}) async {
    assert(filePath != null);
    if (!Platform.isIOS && !Platform.isAndroid) {
      int result;
      var windowsResult;
      if (Platform.isMacOS) {
        result = mac.system(['open', '$filePath']);
      } else if (Platform.isLinux) {
        if (linuxByProcess) {
          result = Process.runSync('xdg-open', [filePath!]).exitCode;
        } else {
          result = linux.system(['$linuxDesktopName-open', '$filePath']);
        }
      } else if (Platform.isWindows) {
        windowsResult = windows.shellExecute('open', filePath!);
        result = windowsResult <= 32 ? 1 : 0;
      } else {
        result = -1;
      }
      return FlutterOpenResult(
          type: result == 0 ? ResultType.done : ResultType.error,
          message: result == 0
              ? "done"
              : result == -1
                  ? "This operating system is not currently supported"
                  : "there are some errors when open $filePath${Platform.isWindows ? "   HINSTANCE=$windowsResult" : ""}");
    }

    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
      "uti": uti,
    };
    final result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(result) as Map<String, dynamic>;
    return FlutterOpenResult.fromJson(resultMap);
  }
}
