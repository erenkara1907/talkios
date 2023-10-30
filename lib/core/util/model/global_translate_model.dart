class GlobalTranslateModel {
  bool? result;
  Data? data;
  GlobalTranslateModel({
    this.result,
    this.data,
  });

  GlobalTranslateModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? message;
  Data({
    this.message,
  });

  Data.fromJson(Map<String, dynamic> json) {
    message = json["message"];
  }
}
