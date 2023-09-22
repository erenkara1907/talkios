class UpdateScoreModel {
  bool? result;
  UpdateScoreModel({
    this.result,
  });

  UpdateScoreModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
  }
}
