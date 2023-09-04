import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager extends ChangeNotifier {
  static final CacheManager _instance = CacheManager._internal();
  SharedPreferences? _preferences;

  factory CacheManager() {
    return _instance;
  }

  CacheManager._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return _preferences!.setString(key, json.encode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    String? jsonString = _preferences!.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> remove(String key) async {
    return _preferences!.remove(key);
  }

  Future<bool> clear() async {
    return _preferences!.clear();
  }
}
