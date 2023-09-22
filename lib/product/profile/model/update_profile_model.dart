class UpdateProfileModel {
  bool? result;
  UpdateProfileModel({
    this.result,
  });

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
  }
}
