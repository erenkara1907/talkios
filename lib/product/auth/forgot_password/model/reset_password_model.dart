class ResetPasswordModel {
  bool? result;
  String? message;
  ResetPasswordModel({
    this.result,
    this.message,
  });

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    message = json["message"];
  }
}
