class SendMessageModel {
  bool? result;
  Data? data;

  SendMessageModel({this.result, this.data});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
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
  List<ChatModel>? chatModel;
  String? sound;

  Data({this.chatModel, this.sound});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      chatModel = <ChatModel>[];
      json['message'].forEach((v) {
        chatModel!.add(ChatModel.fromJson(v));
      });
    }
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chatModel != null) {
      data['message'] = chatModel!.map((v) => v.toJson()).toList();
    }
    data['sound'] = sound;
    return data;
  }
}

class ChatModel {
  int? id;
  String? role;
  String? message;
  int? score;
  dynamic sound;
  dynamic soundRatio;
  dynamic correctSentence;
  dynamic betterSentence;
  int? endConversation;
  String? createdTime;
  String? conversationCompletionCount;
  int? wordCount;
  int? sentenceCount;

  ChatModel({
    this.id,
    this.role,
    this.message,
    this.sound,
    this.soundRatio,
    this.correctSentence,
    this.betterSentence,
    this.endConversation,
    this.createdTime,
    this.conversationCompletionCount,
    this.wordCount,
    this.sentenceCount,
    this.score,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
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
