import 'package:flutter/material.dart';

class SelectedIcon with ChangeNotifier{

 IconData? _selectedIcon;

IconData? get selectedIcon => _selectedIcon;

void SetIcon(IconData data){

_selectedIcon=data;
notifyListeners();
}

void RemoveIcon (){

if(_selectedIcon!=null){
_selectedIcon=null;

}

}

}