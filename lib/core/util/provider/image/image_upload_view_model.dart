// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'image_service.dart';

class ImageUploadViewModel with ChangeNotifier {
  final ImageService _imageService = ImageService();
  final ImagePicker _picker = ImagePicker();

  File? _uploadedImageUrl;

  File? get uploadedImageUrl => _uploadedImageUrl;

  Future uploadFile(BuildContext context) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      _uploadedImageUrl = file;
      notifyListeners();
      final response = await _imageService.uploadFile(token!, file);
      if (response.result!) {
        // Okay
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Please try again",
          ),
        );
      }
    }
  }
}
