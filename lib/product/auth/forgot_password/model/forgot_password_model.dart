class ForgotPasswordModel {
  bool? result;
  String? message;
  ForgotPasswordModel({
    this.result,
    this.message,
  });

  ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    message = json["message"];
  }
}
