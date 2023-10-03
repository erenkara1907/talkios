class MessageUpdateModel {
  bool? result;
  Data? data;

  MessageUpdateModel({this.result, this.data});

  MessageUpdateModel.fromJson(Map<String, dynamic> json) {
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
  Message? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? id;
  String? role;
  String? message;
  int? score;
  String? sound;
  dynamic soundRatio;
  String? correctSentence;
  String? betterSentence;
  int? endConversation;
  String? createdTime;
  String? conversationCompletionCount;
  int? wordCount;
  int? sentenceCount;

  Message(
      {this.id,
      this.role,
      this.message,
      this.score,
      this.sound,
      this.soundRatio,
      this.correctSentence,
      this.betterSentence,
      this.endConversation,
      this.createdTime,
      this.conversationCompletionCount,
      this.wordCount,
      this.sentenceCount});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    message = json['message'];
    score = json['score'];
    sound = json['sound'];
    soundRatio = json['sound_ratio'];
    correctSentence = json['correct_sentence'];
    betterSentence = json['better_sentence'];
    endConversation = json['end_conversation'];
    createdTime = json['created_time'];
    conversationCompletionCount = json['conversation_completion_count'];
    wordCount = json['word_count'];
    sentenceCount = json['sentence_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['message'] = message;
    data['score'] = score;
    data['sound'] = sound;
    data['sound_ratio'] = soundRatio;
    data['correct_sentence'] = correctSentence;
    data['better_sentence'] = betterSentence;
    data['end_conversation'] = endConversation;
    data['created_time'] = createdTime;
    data['conversation_completion_count'] = conversationCompletionCount;
    data['word_count'] = wordCount;
    data['sentence_count'] = sentenceCount;
    return data;
  }
}
