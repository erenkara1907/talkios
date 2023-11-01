import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/home/model/purchase_api_model.dart';

class PremiumService {
  Future<PurchaseAPIModel> purchaseUpdate(String token) async {
    final response = await http
        .post(Uri.parse(ApiConstant.instance.purchasePostUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "purchased": "1"
    });

    return PurchaseAPIModel.fromJson(jsonDecode(response.body));
  }
}
