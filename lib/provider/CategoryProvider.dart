import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _categories = [
    {'icon': CupertinoIcons.headphones, 'name': 'Music'},
    {'icon': CupertinoIcons.layers, 'name': 'Layers'},
    {'icon': CupertinoIcons.game_controller, 'name': 'Games'},
    {'icon': CupertinoIcons.doc_text, 'name': 'Documents'},
    {'icon': CupertinoIcons.archivebox, 'name': 'Archive'},
    {'icon': CupertinoIcons.airplane, 'name': 'Travel'},
    {'icon': CupertinoIcons.alarm, 'name': 'Alarm'},
    {'icon': CupertinoIcons.bell, 'name': 'Notifications'},
    {'icon': CupertinoIcons.book, 'name': 'Books'},
    {'icon': CupertinoIcons.bookmark, 'name': 'Bookmarks'},
    {'icon': CupertinoIcons.calendar, 'name': 'Calendar'},
    {'icon': CupertinoIcons.camera, 'name': 'Camera'},
    {'icon': CupertinoIcons.chat_bubble, 'name': 'Chat'},
    {'icon': CupertinoIcons.rectangle_stack_badge_minus, 'name': 'Minus Badge'},
  ];

  List<Map<String, dynamic>> get categories => _categories;

  void addCategory(Map<String, dynamic> category) {
    _categories.add(category);
    notifyListeners();
  }
}
