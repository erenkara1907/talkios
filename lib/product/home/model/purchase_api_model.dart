class PurchaseAPIModel {
  bool? result;
  Data? data;

  PurchaseAPIModel({this.result, this.data});

  PurchaseAPIModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Purchases>? purchases;

  Data({this.purchases});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['purchases'] != null) {
      purchases = <Purchases>[];
      json['purchases'].forEach((v) {
        purchases!.add(Purchases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchases != null) {
      data['purchases'] = purchases!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Purchases {
  int? id;
  int? userId;
  int? purchased;
  String? createdAt;
  String? updatedAt;

  Purchases(
      {this.id, this.userId, this.purchased, this.createdAt, this.updatedAt});

  Purchases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    purchased = json['purchased'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['purchased'] = purchased;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
