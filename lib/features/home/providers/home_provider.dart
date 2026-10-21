import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTab(int index) {
    if (index < 0 || index > 3 || index == _selectedIndex) {
      return;
    }

    _selectedIndex = index;
    notifyListeners();
  }
}
