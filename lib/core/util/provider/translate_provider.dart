// ignore_for_file: unused_field, prefer_final_fields, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:talkios/core/util/service/translate_service.dart';

import '../../cache/cache_manager.dart';
import '../../enum/preference_keys.dart';

class TranslateProvider extends ChangeNotifier {
  // Service
  TranslateService _service = TranslateService();

  String _translatedText = "";
  String get translatedText => _translatedText;

  bool _isTapTranslate = false;
  bool get isTapTranslate => _isTapTranslate;

  set isTapTranslate(bool value) {
    _isTapTranslate = value;
    notifyListeners();
  }

  Future<void> translate({required String text, String? language}) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    String? _language =
        CacheManager().getString(PreferencesKeys.LANGUAGE.toString());

    final response = await _service.translate(
        token: _token!, text: text, language: language ?? _language!);

    if (response.result != null && response.result!) {
      _translatedText = response.data!.message!;
    }
  }
}
