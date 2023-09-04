import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  var _data;
  bool _isFetched = false;

  get data => _data;

  bool get isFetched => _isFetched;

  Future<void> fetchData(Future<dynamic> dataFunction) async {
    if (!_isFetched) {
      // Verinizi burada çekin. Örnek olarak dummy bir Future kullanıldı.
      await dataFunction;
      _data =
          await Future.delayed(const Duration(seconds: 2), () => 'Veri geldi');
      _isFetched = true;
      notifyListeners();
    }
  }
}
