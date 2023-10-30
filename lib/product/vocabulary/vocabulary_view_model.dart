// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/provider/vocabulary_state.dart';
import 'package:talkios/product/vocabulary/view/complete_word_view.dart';
import 'package:talkios/product/vocabulary/vocabulary_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/constant/config_constant.dart';
import '../../core/util/provider/sound/sound_recorder_service.dart';
import '../../core/util/provider/sound/speech_provider.dart';

class VocabularyViewModel extends ChangeNotifier {
  String? _path = '';

  int _currentCardIndex = 0;
  int get currentCardIndex => _currentCardIndex;

  String _score = "";
  String get score => _score;

  int _newScore = 0;
  int get newScore => _newScore;

  bool _isRecord = false;
  bool get isRecord => _isRecord;

  bool _isVisibleGif = false;
  bool get isVisibleGif => _isVisibleGif;

  String voiceMessage = "";

  bool _isScore = false;
  bool get isScore => _isScore;

  double _indicatorValue = 0.0;
  double get indicatorValue => _indicatorValue;

  bool _onTapVoiceButton = false;
  bool get onTapVoiceButton => _onTapVoiceButton;
  
  int _completeWordCount = 1;
  int get completeWordCount => _completeWordCount;

  int _completeWordCountV2 = 0;
  int get completeWordCountV2 => _completeWordCountV2;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isComplete = false;
  bool get isComplete => _isComplete;

  set isComplete(bool value) {
    _isComplete = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set completeWordCountV2(int value) {
    _completeWordCountV2 = value;
  }

  set completeWordCount(int value) {
    _completeWordCount = value;
    notifyListeners();
  }

  set onTapVoiceButton(bool value) {
    _onTapVoiceButton = value;
    notifyListeners();
  }

  set indicatorValue(double value) {
    _indicatorValue = value;
    notifyListeners();
  }

  set isScore(bool value) {
    _isScore = value;
    notifyListeners();
  }

  final VocabularyService _service = VocabularyService();
  final SoundRecorderService _soundService = SoundRecorderService();

  PageController pageController = PageController();

  void showGif() async {
    bool? _isFirst =
        CacheManager().getBool(PreferencesKeys.IS_FIRST_VOCABULARY.toString());
    if (_isFirst != null) {
      if (_isFirst) {
        _isVisibleGif = true;
        notifyListeners();
      }
    }
  }

  void hideGif() async {
    bool? _isFirst =
        CacheManager().getBool(PreferencesKeys.IS_FIRST_VOCABULARY.toString());
    if (_isFirst != null) {
      if (_isFirst) {
        _isVisibleGif = false;
        await CacheManager()
            .setBool(PreferencesKeys.IS_FIRST_VOCABULARY.toString(), false);
        notifyListeners();
      }
    }
  }

  void forceHideGif() async {
    _isVisibleGif = false;
    await CacheManager()
        .setBool(PreferencesKeys.IS_FIRST_VOCABULARY.toString(), false);
    notifyListeners();
  }

  void cardIndex(int index) {
    _currentCardIndex = index; 
    notifyListeners();
  }

  void defaultNewScore(int defaultScore) {
    _newScore = defaultScore;
    notifyListeners();
  }

  void incrementScore(int score) {
    _newScore += score;
    notifyListeners();
  }

  void record(bool value) {
    _isRecord = value;
    notifyListeners();
  }

  Future<void> startRecording() async {
    await _soundService.init();
    _path = await _soundService.startRecording();
    _score = "";
    notifyListeners();
  }

  Future<void> stopRecord() async {
    await _soundService.stopRecording();
  }

  Future<void> stopRecording(BuildContext context, String voiceMessage,
      String wordId, int conversationId, int wordLength) async {
    await _soundService.stopRecording();
    _path = _soundService.currentPath;
    if (context.read<SpeechProvider>().lastWords.isNotEmpty) {
      await pronunciationCheck(
        context,
        voiceMessage,
        wordId,
        conversationId,
        wordLength,
      );
    } else {
      record(false);
      stopRecord();
    }

    notifyListeners();
  }

  void removeScore() {
    _score = "";
    notifyListeners();
  }

  Future updateScore(String score, String wordId, int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    final response = await _service.updateScore(
      token!,
      score,
      wordId,
      conversationId,
    );

    if (response.result!) {
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () {
      //     _score = "";
      //     notifyListeners();
      //   },
      // );
    }
  }

  Future<void> pronunciationCheck(
    BuildContext context,
    String voiceMessage,
    String wordId,
    int conversationId,
    int wordLength,
  ) async {
    isLoading = true;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var params = {
      "connect": {
        "cmd": "connect",
        "param": {
          "sdk": {"version": 16777472, "source": 9, "protocol": 2},
          "app": {
            "applicationId": appKey,
            "sig": sha1
                .convert(utf8.encode("$appKey$timestamp$secretKey"))
                .toString(),
            "timestamp": timestamp
          }
        }
      },
      "start": {
        "cmd": "start",
        "param": {
          "app": {
            "applicationId": appKey,
            "sig": sha1
                .convert(utf8.encode("$appKey$timestamp$userId$secretKey"))
                .toString(),
            "userId": userId,
            "timestamp": timestamp
          },
          "audio": {
            "audioType": audioType,
            "sampleRate": audioSampleRate,
            "channel": 1,
            "sampleBytes": 2
          },
          "request": {
            "refText": voiceMessage,
            "coreType": coreType,
            "tokenId": timestamp,
          }
        }
      }
    };

    var response = await _service.sendPronunciationCheckRequest(
        voiceMessage, params, coreType, _path!);

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).join().then((String str) async {
        // Handle success
        var respJson = jsonDecode(str);
        if (respJson != null &&
            respJson["result"] != null &&
            respJson["result"]["overall"] != null) {
          _score = respJson["result"]["overall"].toString();
          context.read<VocabularyViewModel>().record(false);
          context.read<VocabularyViewModel>().showGif();
          incrementScore(int.parse(_score));
          notifyListeners();

          await updateScore(_score, wordId, conversationId);

          print("completeCount : $completeWordCount");
          isScore = true;
          isLoading = false;
          context.read<SpeechProvider>().lastWords = "";
          Future.delayed(
            const Duration(seconds: 2),
            () {
              // context.read<VocabularyViewModel>().hideGif();
              context.read<VocabularyState>().completeWord(voiceMessage);

              if (completeWordCount < 5) {
                completeWordCount += 1;
                completeWordCountV2 += 1;
                pageController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut);
              }

              print("completeWordCount : $completeWordCount");

              if (completeWordCountV2 == wordLength) {
                completeWordCountV2 = 0;
                completeWordCount = 1;
                isComplete = false;
                indicatorValue = 0.0;
                context.read<SpeechProvider>().lastWords = "";
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const CompleteWordView()),
                  (Route<dynamic> route) => false,
                );
              }

              isScore = false;

              switch (wordLength) {
                case 4:
                  return indicatorValue += 0.25;
                case 3:
                  return indicatorValue += 0.33;
                case 2:
                  return indicatorValue += 0.5;
                case 1:
                  return indicatorValue += 1;
                default:
              }
            },
          );
        } else {
          context.read<VocabularyViewModel>().record(false);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Please try again",
            ),
          );
          // "result" ya da "overall" anahtarı mevcut değil. Bu durumu nasıl ele almak istediğinize karar verin.
          // Örneğin, bir hata mesajı gösterebilir veya başka bir işlem yapabilirsiniz.
        }
      });
    } else {
      context.read<VocabularyViewModel>().record(false);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please try again",
        ),
      );
    }
  }
}
