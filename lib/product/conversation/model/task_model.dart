class TaskModel {
  bool? result;
  Data? data;
  TaskModel({
    this.result,
    this.data,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Conversation? conversation;
  Data({
    this.conversation,
  });

  Data.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null
        ? Conversation.fromJson(json['conversation'])
        : null;
  }
}

class Conversation {
  List<CompletedTask>? completedTasks;
  List<Word>? words;
  Conversation({
    this.completedTasks,
    this.words,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    if (json['completed_tasks'] != null) {
      completedTasks = <CompletedTask>[];
      json['completed_tasks'].forEach((v) {
        completedTasks!.add(CompletedTask.fromJson(v));
      });
    }
    if (json['words'] != null) {
      words = <Word>[];
      json['words'].forEach((v) {
        words!.add(Word.fromJson(v));
      });
    }
  }
}

class Word {
  int? id;
  String? title;
  String? image;
  int? scenarioId;
  String? version;
  bool? isCompleted;

  Word(
      {this.id,
      this.title,
      this.image,
      this.scenarioId,
      this.version,
      this.isCompleted});

  Word.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    scenarioId = json['scenario_id'];
    version = json['version'];
    isCompleted = json['is_completed'];
  }
}

class CompletedTask {
  String? title;
  bool? isComplete;
  CompletedTask({
    this.title,
    this.isComplete,
  });

  CompletedTask.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    isComplete = json["is_completed"];
  }
}
