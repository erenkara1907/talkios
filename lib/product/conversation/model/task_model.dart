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
  Conversation({
    this.completedTasks,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    if (json['completed_tasks'] != null) {
      completedTasks = <CompletedTask>[];
      json['completed_tasks'].forEach((v) {
        completedTasks!.add(CompletedTask.fromJson(v));
      });
    }
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
