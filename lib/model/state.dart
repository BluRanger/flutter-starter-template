import 'package:flutter/material.dart';
import 'package:resume/model/model.dart';

class StateClass extends ChangeNotifier {
  String state = "app state";

  void UpdateState(String currentState) {
    state = currentState;
    notifyListeners();
  }
}
