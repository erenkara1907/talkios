import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';

import '../../../../product/profile/model/profile_model.dart';

class ImageService {
  Future<ProfileModel> uploadFile(String token, File file) async {
    final req = http.MultipartRequest(
        "POST", Uri.parse(ApiConstant.instance.profilUrl));
    req.headers.addAll(
        {"Accept": "application/json", "Authorization": "Bearer $token"});
    req.files.add(http.MultipartFile(
      'profile_photo',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last,
    ));

    var res = await req.send();
    var response = await http.Response.fromStream(res);

    return ProfileModel.fromJson(jsonDecode(response.body));
  }
}
