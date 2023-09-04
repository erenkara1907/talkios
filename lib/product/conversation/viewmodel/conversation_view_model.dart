import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/conversation/conversation_service.dart';
import 'package:talkios/product/conversation/model/conversation_model.dart';

class ConversationViewModel {
  // Service
  final ConversationService _service = ConversationService();

  // Variable
  List<Conversations> conversations = [];

  // Function
  Future getAllConversation() async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.getAllConversation(token!);

    if (response.result!) {
      conversations.clear();
      conversations.addAll(response.data!.conversations!);
    } else {
      // Not okay
    }
  }
}
