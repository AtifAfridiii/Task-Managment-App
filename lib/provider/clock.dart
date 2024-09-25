import 'package:flutter/cupertino.dart';

class SelectTime with ChangeNotifier {
  int _hour = DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour;
  int _minute = DateTime.now().minute;
  String _period = DateTime.now().hour >= 12 ? "PM" : "AM";

  int get hour => _hour;
  int get minute => _minute;
  String get period => _period;

  void incrementHour() {
    if (_hour == 12) {
      _hour = 1;
    } else {
      _hour++;
    }
    notifyListeners();
  }

  void decrementHour() {
    if (_hour == 1) {
      _hour = 12;
    } else {
      _hour--;
    }
    notifyListeners();
  }

  void incrementMinute() {
    if (_minute == 59) {
      _minute = 0;
      incrementHour();
    } else {
      _minute++;
    }
    notifyListeners();
  }

  void decrementMinute() {
    if (_minute == 0) {
      _minute = 59;
      decrementHour();
    } else {
      _minute--;
    }
    notifyListeners();
  }

  void togglePeriod() {
    _period = _period == "AM" ? "PM" : "AM";
    notifyListeners();
  }

void reset() {
    _hour = DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour;
    _minute =DateTime.now().minute ;
    _period =  DateTime.now().hour >= 12 ? "PM" : "AM" ;
    notifyListeners();
  }

  SelectTime copyWith() {
    final copy = SelectTime();
    copy._hour = _hour;
    copy._minute = _minute;
    copy._period = _period;
    return copy;
  }

}