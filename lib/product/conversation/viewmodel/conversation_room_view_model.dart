// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_field, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/sound_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/conversation/conversation_service.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/suggest_model.dart';
import 'package:talkios/product/conversation/model/task_model.dart';
import 'package:talkios/product/conversation/model/translation_model.dart';
import 'package:talkios/product/home/view/home_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/constant/config_constant.dart';
import '../../../core/util/provider/sound/dubbing_provider.dart';
import '../../../core/util/provider/sound/sound_recorder_service.dart';

class ConversationRoomViewModel extends ChangeNotifier {
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

  List<ChatModel> chats = [];
  SendMessageModel sendModel = SendMessageModel();

  SuggestModel suggestModel = SuggestModel();
  TranslationModel translationModel = TranslationModel();
  TaskModel taskModel = TaskModel();

  final SoundRecorderService _soundService = SoundRecorderService();
  String? _path = '';
  String get path => _path!;

  // Function
  Future<void> startRecording() async {
    await _soundService.init();
    _path = await _soundService.startRecording();
    notifyListeners();
  }

  // void newScoreLoad() {
  //   _isNewScoreLoading = !_isNewScoreLoading;
  //   notifyListeners();
  // }

  void practiceRecord() {
    _isPracticeRecord = !_isPracticeRecord;
    notifyListeners();
  }

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

  void firstConversationInfo(BuildContext context) {
    bool? _isFirst = CacheManager()
        .getBool(PreferencesKeys.IS_FIRST_CONVERSATION.toString());
    DubbingProvider _dubbingProvider = DubbingProvider();

    if (_isFirst != null) {
      if (_isFirst) {
        _isFirstConversation = true;
        _dubbingProvider.stop();
        context.read<DubbingProvider>().stop();
        notifyListeners();
      } else {
        _isFirstConversation = false;
        notifyListeners();
      }
    }
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

  void typing() {
    _isTyping = !_isTyping;
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

  void addToChatList(String message, String messageId) {
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

  // Future sendMessage(
  //   BuildContext context, {
  //   required String message,
  //   required int conversationId,
  //   String? path,
  // }) async {
  //   typing();
  //   String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
  //   final response = await _service.sendMessage(
  //     token!,
  //     conversationId,
  //     message,
  //     path ?? "",
  //   );

  //   if (response.last.endConversation == 0) {
  //     _endChat = true;
  //     notifyListeners();
  //   }

  //   chats.removeWhere((element) => element.message == "Loading");

  //   for (var item in response.reversed) {
  //     await player.play(AssetSource(SoundConstant.instance.chatBubble));
  //     chats.insert(0, item);
  //   }

  //   typing();
  //   context
  //       .read<DubbingProvider>()
  //       .speak(chats[0].message, 0); // Message Dubbing

  //   notifyListeners();
  // }

  Future sendMessage(
    BuildContext context, {
    required String message,
    required int conversationId,
    String? path,
  }) async {
    typing();
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    SendMessageModel? responseModel;
    try {
      responseModel = await _service.sendMessage(
        token!,
        conversationId,
        message,
        path ?? "",
      );
    } catch (error) {
      print("Error sending message: $error");
      return;
    }

    if (responseModel.result!) {
      sendModel = responseModel;
      if (responseModel.data?.chatModel != null) {
        if (responseModel.data!.sound != null) {
          _soundUrl = responseModel.data!.sound!;
          notifyListeners();
        }
        if (responseModel.data!.chatModel!.last.endConversation == 0) {
          _endChat = true;
          notifyListeners();
        }

        chats.removeWhere((element) => element.message == "Loading");

        for (var item in responseModel.data!.chatModel!.reversed) {
          await player.play(AssetSource(SoundConstant.instance.chatBubble));
          chats.insert(0, item);
        }

        typing();
        context
            .read<DubbingProvider>()
            .speak(chats[0].message!, 0); // Message Dubbing

        notifyListeners();
      }
    }
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
        MaterialPageRoute(builder: (context) => HomeView()),
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
            score: score,
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
      checkMessageId(chats, messageId, response.data!.message!.score!);
    }
  }

  void checkMessageId(List<ChatModel> chats, int messageId, int score) {
    for (var chat in chats) {
      if (chat.id == messageId) {
        chat.score = score;
        notifyListeners();
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
