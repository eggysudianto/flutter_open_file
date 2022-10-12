class FlutterOpenResult {
  ResultType type;
  String message;

  FlutterOpenResult({this.type = ResultType.done, this.message = "done"});

  FlutterOpenResult.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        type = _convertJson(json['type']);

  static ResultType _convertJson(int? jsonType) {
    switch (jsonType) {
      case -1:
        return ResultType.noAppToOpen;
      case -2:
        return ResultType.fileNotFound;
      case -3:
        return ResultType.permissionDenied;
      case -4:
        return ResultType.error;
    }
    return ResultType.done;
  }
}

enum ResultType {
  done,
  fileNotFound,
  noAppToOpen,
  permissionDenied,
  error,
}
