import 'package:flutter/material.dart';

class Board with ChangeNotifier{

bool _islastpage= false;
bool get  islastpage=> _islastpage;

set islastpage(bool value) {
    if (_islastpage != value) {
      _islastpage = value;
      notifyListeners(); 
    }
  }


}