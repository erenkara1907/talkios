class VerifyMailModel {
  bool? result;
  String? message;
  VerifyMailModel({
    this.result,
    this.message,
  });

  VerifyMailModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    message = json["message"];
  }
}
