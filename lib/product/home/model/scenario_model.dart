class ScenarioModel {
  bool? result;
  Data? data;

  ScenarioModel({this.result, this.data});

  ScenarioModel.fromJson(Map<String, dynamic> json) {
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
  List<Scenarios>? scenarios;

  Data({this.scenarios});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['scenarios'] != null) {
      scenarios = <Scenarios>[];
      json['scenarios'].forEach((v) {
        scenarios!.add(Scenarios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (scenarios != null) {
      data['scenarios'] = scenarios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scenarios {
  int? id;
  Category? category;
  bool? isConversation;
  dynamic conversationId;
  int? conversationIsActive;
  String? title;
  String? subTitle;
  String? assistantRole;
  String? userRole;
  String? scenario;
  String? gender;
  String? openingSentence;
  String? photo;
  String? icon;
  String? conversationCompletedScenario;
  int? isLocked;
  List<Levels>? levels;
  List<WordScenario>? scenarioWords;

  Scenarios({
    this.id,
    this.category,
    this.isConversation,
    this.conversationId,
    this.title,
    this.assistantRole,
    this.userRole,
    this.scenario,
    this.gender,
    this.openingSentence,
    this.photo,
    this.icon,
    this.subTitle,
    this.conversationCompletedScenario,
    this.isLocked,
    this.scenarioWords,
    this.levels,
    this.conversationIsActive,
  });

  Scenarios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    isConversation = json['is_conversation'];
    conversationId = json['conversation_id'];
    conversationIsActive = json['conversation_is_active'];
    title = json['title'];
    subTitle = json['subtitle'];
    assistantRole = json['assistant_role'];
    userRole = json['user_role'];
    scenario = json['scenario'];
    gender = json['gender'];
    openingSentence = json['opening_sentence'];
    photo = json['photo'];
    icon = json['icon'];
    isLocked = json['is_locked'];
    conversationCompletedScenario = json['conversation_completed_scenario'];
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(Levels.fromJson(v));
      });
    }
    if (json['words'] != null) {
      scenarioWords = <WordScenario>[];
      json['words'].forEach((v) {
        scenarioWords!.add(WordScenario.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['title'] = title;
    data['assistant_role'] = assistantRole;
    data['user_role'] = userRole;
    data['scenario'] = scenario;
    data['opening_sentence'] = openingSentence;
    data['photo'] = photo;
    data['icon'] = icon;
    data['conversation_completed_scenario'] = conversationCompletedScenario;
    if (levels != null) {
      data['levels'] = levels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WordScenario {
  int? id;
  String? title;
  String? image;
  bool? isComplete;
  WordScenario({
    this.id,
    this.title,
    this.image,
    this.isComplete,
  });

  WordScenario.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    image = json["image"];
    isComplete = json["is_completed"];
  }
}

class Category {
  int? id;
  String? title;
  String? icon;

  Category({this.id, this.title, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    return data;
  }
}

class Levels {
  int? id;
  String? cefr;
  String? scale;
  String? title;
  dynamic conversationId;
  String? conversationCompleted;

  Levels(
      {this.id,
      this.cefr,
      this.scale,
      this.title,
      this.conversationId,
      this.conversationCompleted});

  Levels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cefr = json['cefr'];
    scale = json['scale'];
    title = json['title'];
    conversationId = json['conversation_id'];
    conversationCompleted = json['conversation_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cefr'] = cefr;
    data['scale'] = scale;
    data['title'] = title;
    data['conversation_id'] = conversationId;
    data['conversation_completed'] = conversationCompleted;
    return data;
  }
}
