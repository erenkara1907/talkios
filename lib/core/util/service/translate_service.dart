import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/core/util/model/global_translate_model.dart';

class TranslateService {
  Future<GlobalTranslateModel> translate(
      {required String token,
      required String text,
      required String language}) async {
    // language parametresinin ilk harfini büyük yapma
    String capitalizedLanguage =
        language[0].toUpperCase() + language.substring(1);

    final response = await http.post(
      Uri.parse(
        ApiConstant.instance.translateUrl,
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        "text": text,
        "language": capitalizedLanguage, // Güncellenen değişkeni kullanma
      },
    );

    return GlobalTranslateModel.fromJson(jsonDecode(response.body));
  }
}
