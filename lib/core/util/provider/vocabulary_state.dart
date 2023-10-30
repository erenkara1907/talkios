import 'package:flutter/foundation.dart';

class VocabularyState with ChangeNotifier {
  List<String> completedWords = [];

  void completeWord(String word) {
    if (!completedWords.contains(word)) {
      completedWords.add(word);
      notifyListeners(); // Yeni kelime eklendiğinde dinleyicilere bildir.

      print("words: ${completedWords.length}");
      print("words: ${completedWords[0]}");
    }
  }

  bool isWordComplete(String word) {
    return completedWords.contains(word);
  }
}
