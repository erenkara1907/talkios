import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/constant/sound_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/conversation/conversation_service.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/menu_card_model.dart';

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
  bool _isOpenTasks = false;
  bool get isOpenTasks => _isOpenTasks;

  bool _isEmptyText = true;
  bool get isEmptyText => _isEmptyText;

  bool _isShowWarning = false;
  bool get isShowWarning => _isShowWarning;

  // Model
  List<MenuCardModel> menuCards = [
    MenuCardModel(
      id: 1,
      text: "Tasks",
      svgIcon: IconConstant.instance.task,
    ),
    MenuCardModel(
      id: 2,
      text: "Translate",
      svgIcon: IconConstant.instance.translate,
    ),
    MenuCardModel(
      id: 3,
      text: "Clue",
      svgIcon: IconConstant.instance.clue,
    ),
  ];

  List<ChatModel> chats = [];

  // Function

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

  Future sendMessage({
    required String message,
    required int conversationId,
  }) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.sendMessage(
      token!,
      conversationId,
      message,
    );

    chats.removeWhere((element) => element.message == "Loading");

    for (var item in response.reversed) {
      await player.play(AssetSource(SoundConstant.instance.chatBubble));
      chats.insert(0, item);
    }

    notifyListeners();
  }

  Future getAllMessages(int conversationId) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response =
        await _service.getAllMessages(token!, conversationId: conversationId);

    if (response.result!) {
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

  void openTask() {
    _isOpenTasks = !_isOpenTasks;
    notifyListeners();
  }

  void voiceText(String text) {
    askController.text = text;
    notifyListeners();
  }
}
