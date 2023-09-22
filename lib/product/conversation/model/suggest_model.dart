class SuggestModel {
  bool? result;
  Data? data;
  SuggestModel({
    this.result,
    this.data,
  });

  SuggestModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? suggestResponse;
  Data({
    this.suggestResponse,
  });

  Data.fromJson(Map<String, dynamic> json) {
    suggestResponse = json["suggest_response"];
  }
}
