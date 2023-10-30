// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_field, unrelated_type_equality_checks, prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/sound_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/provider/chat_tools_provider.dart';
import 'package:talkios/product/conversation/conversation_service.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/suggest_model.dart';
import 'package:talkios/product/conversation/model/task_model.dart';
import 'package:talkios/product/conversation/model/translation_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/constant/config_constant.dart';
import '../../../core/util/provider/sound/sound_recorder_service.dart';
import '../../home/view/new_home_view.dart';

class ConversationRoomViewModel with ChangeNotifier {
  // Package
  AudioPlayer player = AudioPlayer();

  // Service
  final ConversationService _service = ConversationService();

  // Controller
  TextEditingController askController = TextEditingController();

  // FocusNode
  FocusNode askFocusNode = FocusNode();

  // Variable
  String _soundUrl = "";
  String get soundUrl => _soundUrl;

  bool _isTapAIVoice = false;
  bool get isTapAIVoice => _isTapAIVoice;

  bool _isTapUserVoice = false;
  bool get isTapUserVoice => _isTapUserVoice;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  String _score = "";
  String get score => _score;

  bool _isEmptyText = true;
  bool get isEmptyText => _isEmptyText;

  bool _isShowWarning = false;
  bool get isShowWarning => _isShowWarning;

  bool _isSendAutomaticMessage = true;
  bool get isSendAutomaticMessage => _isSendAutomaticMessage;

  bool _endChat = false;
  bool get endChat => _endChat;

  final bool _isNewScoreLoading = false;
  bool get isNewScoreLoading => _isNewScoreLoading;

  bool _endChatTap = false;
  bool get endChatTap => _endChatTap;

  bool _isActiveChat = true;
  bool get isActiveChat => _isActiveChat;

  bool _isContinue = false;
  bool get isContinue => _isContinue;

  int _selectMenuId = 0;
  int get selectMenuId => _selectMenuId;

  int _messageIndex = -1;
  int get messageIndex => _messageIndex;

  bool _isFirstConversation = false;
  bool get isFirstConversation => _isFirstConversation;

  bool _isPracticeRecord = false;
  bool get isPracticeRecord => _isPracticeRecord;

  bool _isPracticeLoading = false;
  bool get isPracticeLoading => _isPracticeLoading;

  bool _isKeyboard = false;
  bool get isKeyboard => _isKeyboard;

  bool _onTapVoiceButton = false;
  bool get onTapVoiceButton => _onTapVoiceButton;

  List<ChatModel> chats = [];
  SendMessageModel sendModel = SendMessageModel();

  SuggestModel suggestModel = SuggestModel();
  TranslationModel translationModel = TranslationModel();
  TaskModel taskModel = TaskModel();

  final SoundRecorderService _soundService = SoundRecorderService();
  String? _path = '';
  String get path => _path!;

  String _betterSentence = "";
  String get betterSentence => _betterSentence;

  // Function
  set isPracticeRecord(bool value) {
    _isPracticeRecord = value;
    notifyListeners();
  }

  Future<void> startRecording() async {
    await _soundService.init();
    _path = await _soundService.startRecording();
    notifyListeners();
  }

  set onTapVoiceButton(bool value) {
    _onTapVoiceButton = value;
    notifyListeners();
  }

  set isKeyboard(bool value) {
    _isKeyboard = value;
    notifyListeners();
  }

  set soundUrl(String value) {
    if (_soundUrl != value) {
      _soundUrl = value;
      notifyListeners();
    }
  }

  set betterSentence(String value) {
    _betterSentence = value;
    notifyListeners();
  }

  set endChat(bool value) {
    if (_endChat != value) {
      _endChat = value;
      notifyListeners();
    }
  }

  void typing() {
    _isTyping = !_isTyping;
    notifyListeners();
  }

  // void newScoreLoad() {
  //   _isNewScoreLoading = !_isNewScoreLoading;
  //   notifyListeners();
  // }

  // void practiceRecord() {
  //   _isPracticeRecord = !_isPracticeRecord;
  //   notifyListeners();
  // }

  void practiceLoading() {
    _isPracticeLoading = !_isPracticeLoading;
    notifyListeners();
  }

  void addSoundUrl(String url) {
    chats[0].sound = url;
    notifyListeners();
  }

  void tapAIVoice() {
    _isTapAIVoice = !_isTapAIVoice;
    _isTapUserVoice = false;
    notifyListeners();
  }

  void tapUserVoice() {
    _isTapUserVoice = !_isTapUserVoice;
    _isTapAIVoice = false;
    notifyListeners();
  }

  String getScoreStatus(int score) {
    if (score >= 0 && score < 25) {
      return 'Very Bad';
    } else if (score >= 25 && score < 50) {
      return 'Bad';
    } else if (score >= 50 && score < 75) {
      return 'Good';
    } else if (score >= 75 && score <= 100) {
      return 'Very Good';
    } else {
      return 'Invalid Score'; // Hatalı bir puan değeri için varsayılan mesaj
    }
  }

  Color getScoreColor(int score) {
    if (score >= 0 && score < 25) {
      return const Color.fromRGBO(255, 98, 67, 1);
    } else if (score >= 25 && score < 50) {
      return const Color.fromRGBO(255, 122, 46, 1);
    } else if (score >= 50 && score < 75) {
      return const Color.fromRGBO(255, 217, 32, 1);
    } else if (score >= 75 && score <= 100) {
      return const Color.fromRGBO(0, 211, 148, 1);
    } else {
      return Colors.grey; // Hatalı bir puan değeri için varsayılan renk
    }
  }

  void changeStatusFirstConversation(bool value) {
    CacheManager()
        .setBool(PreferencesKeys.IS_FIRST_CONVERSATION.toString(), false);
    _isFirstConversation = value;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _soundService.stopRecording();
    _path = _soundService.currentPath;
    notifyListeners();
  }

  void sendAutomaticMessage(bool value) {
    _isSendAutomaticMessage = value;
    notifyListeners();
  }

  void changeMessageIndex(int index) {
    _messageIndex = index;
    notifyListeners();
  }

  void showWarning() {
    _isShowWarning = true;
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _isShowWarning = false;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void changeEmptyTextStatus(bool status) {
    _isEmptyText = status;
    notifyListeners();
  }

  int messageIdVal = -1;

  void addToChatList(String message, String messageId) {
    messageIdVal = int.parse(messageId);
    chats.insert(
      0,
      ChatModel(id: int.parse(messageId), message: message, role: "user"),
    );
    chats.insert(
      0,
      ChatModel(id: -2, message: "Loading", role: "assistant"),
    );

    askController.clear();
    notifyListeners();
  }

  void continueChat(bool value) {
    _isContinue = value;
    notifyListeners();
  }

  void selectMenu(int id) {
    _selectMenuId = id;
    notifyListeners();
  }

  void tapEndChat() {
    _endChatTap = !_endChatTap;
    notifyListeners();
  }

  Future suggestResponse(int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.suggestResponse(token!, conversationId);

    if (response.result!) {
      suggestModel = response;
      notifyListeners();
    }
  }

  Future getTasks(int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.getAllTasks(token!, conversationId);

    if (response.result!) {
      taskModel = response;
    }
  }

  Future translate({
    required int conversationId,
    required int messageId,
  }) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    String? language =
        CacheManager().getString(PreferencesKeys.LANGUAGE.toString());

    final response = await _service.translate(
      token!,
      conversationId: conversationId,
      messageId: messageId,
      translateLanguage: language ?? "english",
    );

    if (response.result!) {
      translationModel = response;
    }
  }

  List<int> _indexesWithSound = [];
  List<int> get indexesWithSound => _indexesWithSound;

  int _lastIndex = -1;

  void addToIndexList(int index) {
    // _lastIndex += 2;
    _indexesWithSound.add(index);
    notifyListeners();
  }

  Future<void> sendMessage({
    required BuildContext context,
    required String message,
    required int conversationId,
    required String gender,
    String? path,
    required bool isVoice,
  }) async {
    // Close Chat State
    context.read<ChatToolsProvider>().isTranslate = false;
    context.read<ChatToolsProvider>().isTip = false;
    context.read<ChatToolsProvider>().isPronunciation = false;

    typing();

    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    if (token == null) throw "Token is null";

    int retryCount = 0;
    const int maxRetries = 3; // Maksimum yeniden deneme sayısı
    bool isSentSuccessfully = false;

    while (retryCount < maxRetries && !isSentSuccessfully) {
      try {
        final responseModel = await _service.sendMessage(
          token,
          conversationId,
          message,
          path ?? "",
        );

        if (responseModel.result ?? false) {
          isSentSuccessfully = true;

          sendModel = responseModel;

          if (responseModel.data?.chatModel != null) {
            // provider.chats[0].id! + 1
            if (isVoice) {
              addToIndexList(messageIdVal);
            }

            soundUrl = responseModel.data!.sound ?? "";
            betterSentence = responseModel.data!.betterSentence ?? "";

            endChat = responseModel.data!.chatModel!.last.endConversation == 0;
            chats.removeWhere((element) => element.message == "Loading");

            // Mesajların tersini al
            List<ChatModel> newChats =
                responseModel.data!.chatModel!.reversed.toList();

            // Null mesaj kontrolü
            if (newChats.any((item) => item.message == null)) {
              throw "Message is null";
            }

            // Tüm yeni mesajları tek seferde listenin başına ekle
            chats.insertAll(0, newChats);

            // Liste güncellendiği için UI'yi güncelle
            notifyListeners();

            // İlk mesajın sesini oynat ve konuşma sağlayıcı ile oku
            await player.play(AssetSource(SoundConstant.instance.chatBubble));
            // context.read<DubbingProvider>().speak(
            //       chats[0].message!,
            //       0,
            //     );
          }
        } else {
          // Yanıt başarılı değilse, hatayı göstermeden yeniden dene
          // print("Request failed: ${responseModel.error} - Retrying...");
          retryCount++;

          // Belirli bir bekleme süresi ekleyerek API'nin toparlanmasına izin verebilirsiniz
          await Future.delayed(const Duration(seconds: 2));
        }
      } catch (error) {
        // Hata durumunda, hata mesajını logla ve yeniden deneme sayacını artır
        print("An error occurred: $error - Retrying...");
        retryCount++;

        // Belirli bir bekleme süresi ekleyerek API'nin toparlanmasına izin verebilirsiniz
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (!isSentSuccessfully) {
      // Maksimum yeniden deneme sayısına ulaşıldıysa, hata mesajını göster
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Unexpected error, please restart the app.",
        ),
      );
    }

    typing();
  }

  Future conversationUpdate(
      BuildContext context, bool endConversation, int cId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.conversationUpdate(
      token!,
      cId,
      {
        "end_conversation": endConversation,
      },
    );

    if (response.result!) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeView()),
        (Route<dynamic> route) => false,
      );
    } else {}
  }

  changeAskText(String value) {
    askController.text = value;
    notifyListeners();
  }

  Future getAllMessages(int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response =
        await _service.getAllMessages(token!, conversationId: conversationId);
    if (response.result!) {
      if (response.data!.conversation!.isActive == 0) {
        _isActiveChat = false;
        notifyListeners();
      } else {
        _isActiveChat = true;
        notifyListeners();
      }

      chats = List.generate(
        response.data!.messages!.length,
        (index) => ChatModel(
          message: response.data!.messages![index].message!,
          role: response.data!.messages![index].role!,
          id: response.data!.messages![index].id!,
          score: response.data!.messages![index].score,
          conversationCompletionCount: "0.0",
          endConversation: response.data!.messages![index].endConversation!,
          betterSentence: response.data!.messages![index].betterSentence ?? "",
          correctSentence:
              response.data!.messages![index].correctSentence ?? "",
          sound: response.data!.messages![index].sound ?? "",
          soundRatio: response.data!.messages![index].soundRatio ?? "",
        ),
      );
    }

    chats = chats.reversed.toList();

    notifyListeners();
  }

  void deFocus() {
    askFocusNode.unfocus();
  }

  void voiceText(String text) {
    askController.text = text;
    notifyListeners();
  }

  Future<void> pronunciationCheck(
      bool isFirst,
      int conversationId,
      int messageId,
      BuildContext context,
      String voiceMessage,
      String apiPath,
      List<ChatModel> chats) async {
    practiceLoading();
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
      voiceMessage,
      params,
      coreType,
      _path!.isEmpty ? apiPath : _path!,
    );

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).join().then((String str) async {
        // Handle success
        var respJson = jsonDecode(str);
        if (respJson != null &&
            respJson["result"] != null &&
            respJson["result"]["overall"] != null) {
          _score = respJson["result"]["overall"].toString();
          updateScore(_score);

          await updateAPIScore(
            chats: chats,
            conversationId: conversationId,
            messageId: messageId,
            score: _score,
          );
          practiceLoading();
          // context.read<VocabularyViewModel>().record(false);
        } else {
          // context.read<VocabularyViewModel>().record(false);
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
      // context.read<VocabularyViewModel>().record(false);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please try again",
        ),
      );
    }
  }

  Future<void> pronunciationCheckAPI(
      bool isFirst,
      int conversationId,
      int messageId,
      BuildContext context,
      String voiceMessage,
      String apiPath,
      List<ChatModel> chats) async {
    try {
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
        voiceMessage,
        params,
        coreType,
        _path!.isEmpty ? apiPath : _path!,
      );

      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).join().then((String str) async {
          // Handle success
          var respJson = jsonDecode(str);
          if (respJson != null &&
              respJson["result"] != null &&
              respJson["result"]["overall"] != null) {
            _score = respJson["result"]["overall"].toString();
            // updateScore(_score);
            await updateAPIScore(
              chats: chats,
              conversationId: conversationId,
              messageId: messageId,
              score: _score,
            );

            // context.read<VocabularyViewModel>().record(false);
          } else {
            // context.read<VocabularyViewModel>().record(false);
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
        // context.read<VocabularyViewModel>().record(false);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Please try again",
          ),
        );
      }
    } catch (e) {
      print("Error : ${e.toString()}");
    }
  }

  Future updateAPIScore(
      {required int conversationId,
      required int messageId,
      required String score,
      required List<ChatModel> chats}) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.updateScore(
      conversationId: conversationId,
      messageId: messageId,
      token: token!,
      score: score,
    );

    if (response.result!) {
      checkMessageId(
        chats,
        messageId,
        response.data!.message!.score!,
        response.data!.message!.sound!,
      );
    } else {
      // Some code
      checkMessageId(
        chats,
        messageId,
        82,
        "example.sound",
      );
    }
  }

  void checkMessageId(
      List<ChatModel> chats, int messageId, int score, String sound) {
    for (var chat in chats) {
      if (chat.id == messageId) {
        chat.score = score;
        chat.sound = sound;
        soundUrl = "";
        // notifyListeners();
        // Eğer başka işlemler de yapmak isterseniz, bu blok içerisine ekleyebilirsiniz.
        break; // Eşleşme bulduktan sonra döngüden çıkılır.
      } else {}
    }
  }

  void updateScore(String score) {
    _score = score;

    notifyListeners();
  }
}
