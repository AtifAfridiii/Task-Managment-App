import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerService extends ChangeNotifier {
  final Stopwatch _watch = Stopwatch();
  Timer? _timer;
  Duration? _currentDuration;
  Duration get currentDuration => _currentDuration ?? Duration.zero;

  bool get isRunning => _watch.isRunning;
  void start() {
    _watch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDuration = _watch.elapsed;
      notifyListeners();
    });
  }

// This function Reset Our StopWatch
  void reset() {
    // Here we are checking our Stopwatch is in running mode
    // if false then stop
    if (!isRunning) _watch.stop();
    // here we are resetting our Stopwatch
    _watch.reset();
    // here we are canceling  our Timer to Prevent Memory Leaks
    _timer?.cancel();
    _currentDuration = Duration.zero;

    notifyListeners();
  }

  void stop() {
    _watch.stop();
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  @override
  notifyListeners();
}