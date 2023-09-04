import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/conversation_model.dart';
import 'package:talkios/product/conversation/model/conversation_store_model.dart';

import 'model/conversation_room_model.dart';

class ConversationService {
  Future<ConversationModel> getAllConversation(String token) async {
    final response = await http
        .get(Uri.parse(ApiConstant.instance.conversationUrl), headers: {
      "Authorization": "Bearer $token",
    });

    return ConversationModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationStoreModel> storeConversation(
      String token, String scenarioId) async {
    final response = await http.post(
        Uri.parse(
          ApiConstant.instance.conversationUrl,
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "scenario_id": scenarioId,
        });

    return ConversationStoreModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationRoomModel> getAllMessages(String token,
      {required int conversationId}) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstant.instance.conversationUrl}/$conversationId/message'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return ConversationRoomModel.fromJson(jsonDecode(response.body));
  }

  Future<List<ChatModel>> sendMessage(
      String token, int conversationId, String message) async {
    final response = await http.post(
        Uri.parse(
            '${ApiConstant.instance.conversationUrl}/$conversationId/message'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "message": message,
        });

    Map jsonResponse = json.decode(response.body);



    List<ChatModel> chatList = [];

    if (jsonResponse['data']['message'].length > 0) {
      chatList = List.generate(
        jsonResponse['data']['message'].length,
        (index) => ChatModel(
          message: jsonResponse['data']['message'][index]['message'],
          role: 'assistant',
          id: jsonResponse['data']['message'][index]['id'],
          conversationCompletionCount: jsonResponse['data']['message'][index]
              ['conversation_completion_count'],
          endConversation: jsonResponse['data']['message'][index]
              ['end_conversation'],
          betterSentence: jsonResponse['data']['message'][index]
              ['better_sentence'],
          correctSentence: jsonResponse['data']['message'][index]
              ['correct_sentence'],
          sound: jsonResponse['data']['message'][index]['sound'],
          soundRatio: jsonResponse['data']['message'][index]['sound_ratio'],
        ),
      );
    }

    return chatList;
  }
}
