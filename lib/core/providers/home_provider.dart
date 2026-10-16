import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _navIndex = 0;

  int get navIndex => _navIndex;

  void changeTab(int index) {
    if (index < 0 || index > 3 || index == _navIndex) {
      return;
    }

    _navIndex = index;
    notifyListeners();
  }
}
