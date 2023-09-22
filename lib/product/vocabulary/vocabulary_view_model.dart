// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/vocabulary/vocabulary_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/util/provider/sound/sound_recorder_service.dart';

class VocabularyViewModel extends ChangeNotifier {
  final _appKey = "1686539747000176";
  final _secretKey = "acf887731c9876ee6e41652394c4c873";
  final _userId = "uid";
  final _coreType = "sent.eval";
  final _audioType = "wav";
  final _audioSampleRate = "16000";
  String? _path = '';

  CardSwiperController cardSwiperController = CardSwiperController();

  int _currentCardIndex = 0;
  int get currentCardIndex => _currentCardIndex;

  String _score = "";
  String get score => _score;

  int _newScore = 0;
  int get newScore => _newScore;

  bool _isRecord = false;
  bool get isRecord => _isRecord;

  bool _isGlowAnimate = false;
  bool get isGlowAnimate => _isGlowAnimate;

  String voiceMessage = "";

  final VocabularyService _service = VocabularyService();
  final SoundRecorderService _soundService = SoundRecorderService();

  void cardIndex(int index) {
    _currentCardIndex = index;
    notifyListeners();
  }

  void defaultNewScore(int defaultScore) {
    _newScore = defaultScore;
  }

  void incrementScore(int score) {
    _newScore += score;
    notifyListeners();
  }

  void record() {
    _isRecord = !_isRecord;
    notifyListeners();
  }

  void glowAnimate() {
    _isGlowAnimate = !_isGlowAnimate;
    notifyListeners();
  }

  Future<void> startRecording() async {
    await _soundService.init();
    _path = await _soundService.startRecording();
    _score = "";
    notifyListeners();
  }

  FutureOr<bool> mySwipeFunction(int firstParam,
      [int? secondParam, CardSwiperDirection? direction]) {
    // Burada işlemlerinizi yapın
    return true; // ya da return Future.value(true);
  }

  Future<void> stopRecording(
      BuildContext context, String voiceMessage, String wordId) async {
    await _soundService.stopRecording();
    _path = _soundService.currentPath;
    await pronunciationCheck(
      context,
      voiceMessage,
      wordId,
    );
    notifyListeners();
  }

  // void defaultScore() {
  //   _score = "";
  //   notifyListeners();
  // }

  Future updateScore(String score, String wordId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    final response = await _service.updateScore(
      token!,
      score,
      wordId,
    );

    if (response.result!) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          cardSwiperController.swipeRight();
          notifyListeners();
        },
      );
    }
  }

  Future<void> pronunciationCheck(
      BuildContext context, String voiceMessage, String wordId) async {
    print("voiceMesssage : ${voiceMessage}");
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var params = {
      "connect": {
        "cmd": "connect",
        "param": {
          "sdk": {"version": 16777472, "source": 9, "protocol": 2},
          "app": {
            "applicationId": _appKey,
            "sig": sha1
                .convert(utf8.encode("$_appKey$timestamp$_secretKey"))
                .toString(),
            "timestamp": timestamp
          }
        }
      },
      "start": {
        "cmd": "start",
        "param": {
          "app": {
            "applicationId": _appKey,
            "sig": sha1
                .convert(utf8.encode("$_appKey$timestamp$_userId$_secretKey"))
                .toString(),
            "userId": _userId,
            "timestamp": timestamp
          },
          "audio": {
            "audioType": _audioType,
            "sampleRate": _audioSampleRate,
            "channel": 1,
            "sampleBytes": 2
          },
          "request": {
            "refText": voiceMessage,
            "coreType": _coreType,
            "tokenId": timestamp,
          }
        }
      }
    };
    var response = await _service.sendPronunciationCheckRequest(
        voiceMessage, params, _coreType, _path!);

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).join().then((String str) {
        // Handle success
        var respJson = jsonDecode(str);
        print("status code : ${respJson["result"]}");
        if (respJson != null &&
            respJson["result"] != null &&
            respJson["result"]["overall"] != null) {
          _score = respJson["result"]["overall"].toString();
          context.read<VocabularyViewModel>().record();
          print("score : $_score");
          incrementScore(int.parse(_score));
          notifyListeners();

          updateScore(_score, wordId);
        } else {
          context.read<VocabularyViewModel>().record();
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
      context.read<VocabularyViewModel>().record();
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please try again",
        ),
      );
    }
  }
}
