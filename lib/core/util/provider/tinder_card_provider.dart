import 'package:flutter/material.dart';

class TinderCardProvider extends ChangeNotifier {
  final List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

  List<String> get items => _items;
}
