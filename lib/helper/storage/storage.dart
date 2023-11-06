import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/model.dart';

class Storage {
  // Static method to store the object locally
  Future<void> storeObjectLocally(Model object) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('state', jsonEncode(object.toJson()));
  }

  Future<void> clearObjectLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('state');
  }

  // Static method to retrieve the object from local storage
  Future<Model?> getObjectLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString;
    try {
      jsonString = prefs.getString('state');
    } catch (e) {
      return null;
    }

    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      return Model.fromJson(map);
    }
    return null;
  }
}
