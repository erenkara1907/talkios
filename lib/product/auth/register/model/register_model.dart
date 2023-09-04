class RegisterModel {
  bool? result;
  Data? data;
  ValidationError? validationError;

  RegisterModel({
    this.result,
    this.data,
    this.validationError,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    validationError = json['validation_error'] != null
        ? ValidationError.fromJson(json['validation_error'])
        : null;
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

class ValidationError {
  List<String>? email;

  ValidationError({this.email});

  ValidationError.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}

class Data {
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  dynamic nativeLanguage;
  List<LearnLanguages>? learnLanguages;
  String? profilePhoto;
  bool? isAvatar;
  List<int>? color;
  DailyPractice? dailyPractice;
  bool? isConversations;

  User(
      {this.id,
      this.name,
      this.email,
      this.nativeLanguage,
      this.learnLanguages,
      this.profilePhoto,
      this.isAvatar,
      this.color,
      this.dailyPractice,
      this.isConversations});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    nativeLanguage = json['native_language'];
    if (json['learn_languages'] != null) {
      learnLanguages = <LearnLanguages>[];
      json['learn_languages'].forEach((v) {
        learnLanguages!.add(LearnLanguages.fromJson(v));
      });
    }
    profilePhoto = json['profile_photo'];
    isAvatar = json['is_avatar'];
    color = json['color'].cast<int>();
    dailyPractice = json['daily_practice'] != null
        ? DailyPractice.fromJson(json['daily_practice'])
        : null;
    isConversations = json['is_conversations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['native_language'] = nativeLanguage;
    if (learnLanguages != null) {
      data['learn_languages'] = learnLanguages!.map((v) => v.toJson()).toList();
    }
    data['profile_photo'] = profilePhoto;
    data['is_avatar'] = isAvatar;
    data['color'] = color;
    if (dailyPractice != null) {
      data['daily_practice'] = dailyPractice!.toJson();
    }
    data['is_conversations'] = isConversations;
    return data;
  }
}

class LearnLanguages {
  int? id;
  String? code;
  String? title;
  String? flag;
  int? isPopular;
  ProficiencyLevel? proficiencyLevel;

  LearnLanguages(
      {this.id,
      this.code,
      this.title,
      this.flag,
      this.isPopular,
      this.proficiencyLevel});

  LearnLanguages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    flag = json['flag'];
    isPopular = json['is_popular'];
    proficiencyLevel = json['proficiency_level'] != null
        ? ProficiencyLevel.fromJson(json['proficiency_level'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['flag'] = flag;
    data['is_popular'] = isPopular;
    if (proficiencyLevel != null) {
      data['proficiency_level'] = proficiencyLevel!.toJson();
    }
    return data;
  }
}

class ProficiencyLevel {
  int? id;
  String? cefr;
  String? scale;
  String? title;

  ProficiencyLevel({this.id, this.cefr, this.scale, this.title});

  ProficiencyLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cefr = json['cefr'];
    scale = json['scale'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cefr'] = cefr;
    data['scale'] = scale;
    data['title'] = title;
    return data;
  }
}

class DailyPractice {
  String? count;
  String? completionPercentage;

  DailyPractice({this.count, this.completionPercentage});

  DailyPractice.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    completionPercentage = json['completion_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['completion_percentage'] = completionPercentage;
    return data;
  }
}
