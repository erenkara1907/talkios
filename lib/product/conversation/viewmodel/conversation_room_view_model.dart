// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/constant/sound_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/conversation/conversation_service.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/menu_card_model.dart';
import 'package:talkios/product/conversation/model/suggest_model.dart';
import 'package:talkios/product/conversation/model/task_model.dart';
import 'package:talkios/product/conversation/model/translation_model.dart';
import 'package:talkios/product/home/view/home_view.dart';

import '../../../core/util/provider/sound/dubbing_provider.dart';

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
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  bool _isOpenTasks = false;
  bool get isOpenTasks => _isOpenTasks;

  bool _isOpenClue = false;
  bool get isOpenClue => _isOpenClue;

  bool _isEmptyText = true;
  bool get isEmptyText => _isEmptyText;

  bool _isShowWarning = false;
  bool get isShowWarning => _isShowWarning;

  bool _isSendAutomaticMessage = true;
  bool get isSendAutomaticMessage => _isSendAutomaticMessage;

  bool _endChat = false;
  bool get endChat => _endChat;

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

  // Model
  List<MenuCardModel> menuCards = [
    MenuCardModel(
      id: 1,
      text: "Tasks",
      svgIcon: IconConstant.instance.task,
    ),
    MenuCardModel(
      id: 3,
      text: "Clue",
      svgIcon: IconConstant.instance.clue,
    ),
  ];

  List<ChatModel> chats = [];

  SuggestModel suggestModel = SuggestModel();
  TranslationModel translationModel = TranslationModel();
  TaskModel taskModel = TaskModel();

  // Function
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

  void addToChatList(String message) {
    chats.insert(
      0,
      ChatModel(id: -1, message: message, role: "user"),
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
      translateLanguage: language!,
    );

    if (response.result!) {
      translationModel = response;
    }
  }

  Future sendMessage(
    BuildContext context, {
    required String message,
    required int conversationId,
  }) async {
    typing();
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.sendMessage(
      token!,
      conversationId,
      message,
    );

    if (response.last.endConversation == 0) {
      _endChat = true;
      notifyListeners();
    }

    chats.removeWhere((element) => element.message == "Loading");

    for (var item in response.reversed) {
      await player.play(AssetSource(SoundConstant.instance.chatBubble));
      chats.insert(0, item);
    }

    typing();
    context
        .read<DubbingProvider>()
        .speak(chats[0].message, 0); // Message Dubbing

    notifyListeners();
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

  Future getAllMessages(int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response =
        await _service.getAllMessages(token!, conversationId: conversationId);

    if (response.result!) {
      if (response.data!.conversation!.isActive == 0) {
        _isActiveChat = false;
        notifyListeners();
      }
      chats = List.generate(
        response.data!.messages!.length,
        (index) => ChatModel(
          message: response.data!.messages![index].message!,
          role: response.data!.messages![index].role!,
          id: response.data!.messages![index].id!,
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

  void openTask(bool value) {
    _isOpenTasks = value;
    notifyListeners();
  }

  void openClue(bool value) {
    _isOpenClue = value;
    notifyListeners();
  }

  void voiceText(String text) {
    askController.text = text;
    notifyListeners();
  }
}
