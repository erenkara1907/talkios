import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/conversation_model.dart';
import 'package:talkios/product/conversation/model/conversation_store_model.dart';
import 'package:talkios/product/conversation/model/conversation_update_model.dart';
import 'package:talkios/product/conversation/model/message_update_model.dart';
import 'package:talkios/product/conversation/model/suggest_model.dart';
import 'package:talkios/product/conversation/model/task_model.dart';
import 'package:talkios/product/conversation/model/translation_model.dart';

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

  Future<TaskModel> getAllTasks(String token, int conversationId) async {
    final response = await http.get(
        Uri.parse("${ApiConstant.instance.conversationUrl}/$conversationId"),
        headers: {
          "Authorization": "Bearer $token",
        });

    return TaskModel.fromJson(jsonDecode(response.body));
  }

  Future<TranslationModel> translate(
    String token, {
    required int conversationId,
    required int messageId,
    required String translateLanguage,
  }) async {
    final response = await http.get(
        Uri.parse(
            "${ApiConstant.instance.conversationUrl}/$conversationId/message/$messageId?translate=$translateLanguage"),
        headers: {
          "Authorization": "Bearer $token",
        });

    return TranslationModel.fromJson(jsonDecode(response.body));
  }

  final String baseHOST = "api.speechsuper.com";

  Future<http.StreamedResponse> sendPronunciationCheckRequest(
      String voiceMessage,
      Map<String, dynamic> params,
      String coreType,
      String path) async {
    var request = http.MultipartRequest("POST", Uri.https(baseHOST, coreType))
      ..fields["text"] = jsonEncode(params)
      ..headers["Request-Index"] = "0";

    if (path.startsWith("http://") || path.startsWith("https://")) {
      // Eğer path bir URL ise dosyayı önce indir
      var response = await http.get(Uri.parse(path));
      var fileName = path.split('/').last;
      var fileBytes = response.bodyBytes;
      request.files.add(
          http.MultipartFile.fromBytes("audio", fileBytes, filename: fileName));
    } else {
      // Eğer path bir dosya yoluysa dosyayı oku
      ByteData data = await rootBundle.load(path);
      request.files.add(
          http.MultipartFile.fromBytes("audio", data.buffer.asUint8List()));
    }

    var streamedResponse = await request.send();

    return streamedResponse;
  }

  Future<MessageUpdateModel> updateScore({
    required int conversationId,
    required int messageId,
    required String token,
    required String score,
  }) async {
    final response = await http.put(
        Uri.parse(
            "${ApiConstant.instance.conversationUrl}/$conversationId/message/$messageId"),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "score": score,
        });

    print("response : ${response.body}");

    return MessageUpdateModel.fromJson(jsonDecode(response.body));
  }

  // Future<List<ChatModel>> sendMessage(
  //   String token,
  //   int conversationId,
  //   String message,
  //   String path,
  // ) async {
  //   // MultipartRequest oluştur
  //   var uri = Uri.parse(
  //       '${ApiConstant.instance.conversationUrl}/$conversationId/message');
  //   var request = http.MultipartRequest('POST', uri);
  //   if (path.isNotEmpty) {
  //     request
  //       ..headers['Authorization'] = 'Bearer $token'
  //       ..fields['message'] = message
  //       ..files.add(
  //         await http.MultipartFile.fromPath(
  //           'sound_file', // Sunucunun kabul ettiği dosya adı
  //           path,
  //           contentType:
  //               MediaType('audio', 'wav'), // Formatınıza göre değiştirin
  //         ),
  //       );
  //   } else {
  //     request
  //       ..headers['Authorization'] = 'Bearer $token'
  //       ..fields['message'] = message;
  //   }

  //   // İsteği gönder
  //   var streamedResponse = await request.send();
  //   var response = await http.Response.fromStream(streamedResponse);

  //   Map<String, dynamic> jsonResponse = json.decode(response.body);

  //   List<ChatModel> chatList = [];

  //   if (jsonResponse['data']['message'].length > 0) {
  //     chatList = List.generate(
  //       jsonResponse['data']['message'].length,
  //       (index) => ChatModel(
  //         message: jsonResponse['data']['message'][index]['message'],
  //         role: 'assistant',
  //         id: jsonResponse['data']['message'][index]['id'],
  //         conversationCompletionCount: jsonResponse['data']['message'][index]
  //             ['conversation_completion_count'],
  //         endConversation: jsonResponse['data']['message'][index]
  //             ['end_conversation'],
  //         betterSentence: jsonResponse['data']['message'][index]
  //             ['better_sentence'],
  //         correctSentence: jsonResponse['data']['message'][index]
  //             ['correct_sentence'],
  //         sound: jsonResponse['data']['message'][index]['sound'],
  //         soundRatio: jsonResponse['data']['message'][index]['sound_ratio'],
  //       ),
  //     );
  //   }

  //   return chatList;
  // }

  Future<SendMessageModel> sendMessage(
    String token,
    int conversationId,
    String message,
    String path,
  ) async {
    // MultipartRequest oluştur
    var uri = Uri.parse(
        '${ApiConstant.instance.conversationUrl}/$conversationId/message');
    var request = http.MultipartRequest('POST', uri);
    if (path.isNotEmpty) {
      request
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['message'] = message
        ..files.add(
          await http.MultipartFile.fromPath(
            'sound_file', // Sunucunun kabul ettiği dosya adı
            path,
            contentType:
                MediaType('audio', 'wav'), // Formatınıza göre değiştirin
          ),
        );
    } else {
      request
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['message'] = message;
    }

    // İsteği gönder
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("response : ${response.body}");

    Map<String, dynamic> jsonResponse = json.decode(response.body);

    // JsonResponse'u modelinize dönüştürün
    return SendMessageModel.fromJson(jsonResponse);
  }

  Future<SuggestModel> suggestResponse(String token, int conversationId) async {
    final response = await http.get(
        Uri.parse(
            "${ApiConstant.instance.conversationUrl}/$conversationId/suggest-response"),
        headers: {
          "Authorization": "Bearer $token",
        });

    return SuggestModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationUpdateModel> conversationUpdate(
    String token,
    int conversationId,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConstant.instance.conversationUrl}/$conversationId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("ressponse : ${response.body}");

    return ConversationUpdateModel.fromJson(jsonDecode(response.body));
  }
}
