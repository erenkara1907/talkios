import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/vocabulary/update_score_model.dart';

class VocabularyService {
  final String baseHOST = "api.speechsuper.com";

  Future<http.StreamedResponse> sendPronunciationCheckRequest(
      String voiceMessage,
      Map<String, dynamic> params,
      String coreType,
      String path) async {
    ByteData data = await rootBundle.load(path);
    var request = http.MultipartRequest("POST", Uri.https(baseHOST, coreType))
      ..fields["text"] = jsonEncode(params)
      ..files
          .add(http.MultipartFile.fromBytes("audio", data.buffer.asUint8List()))
      ..headers["Request-Index"] = "0";

    return await request.send();
  }

  Future<UpdateScoreModel> updateScore(String token, String score, String wordId) async {
    final response =
        await http.post(Uri.parse(ApiConstant.instance.profilUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "score": score,
      "word_id": wordId,
    });

    return UpdateScoreModel.fromJson(jsonDecode(response.body));
  }
}
