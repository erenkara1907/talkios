class TranslationModel {
  bool? result;
  Data? data;
  TranslationModel({
    this.result,
    this.data,
  });

  TranslationModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Message? message;
  Data({
    this.message,
  });

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  String? message;
  Message({
    this.message,
  });

  Message.fromJson(Map<String, dynamic> json) {
    message = json["message"];
  }
}
