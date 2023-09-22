import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/profile/model/update_profile_model.dart';

class ProfileService {
  Future<void> uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        ApiConstant.instance.profilUrl,
      ),
    );

    request.files.add(http.MultipartFile(
        'image', image.readAsBytes().asStream(), image.lengthSync(),
        filename: image.path.split("/").last));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded!');
    } else {
      print('Failed to upload image.');
    }
  }

  Future<UpdateProfileModel> updateProfileInfo(
      String token, Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: info,
    );

    return UpdateProfileModel.fromJson(jsonDecode(response.body));
  }
}
