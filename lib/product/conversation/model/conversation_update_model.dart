class ConversationUpdateModel {
  bool? result;

  ConversationUpdateModel({this.result});

  ConversationUpdateModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;

    return data;
  }
}
