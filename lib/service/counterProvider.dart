import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int counter;

  CounterProvider({this.counter = 0});

  void increment() {
    counter++;
    notifyListeners();
  }
}
