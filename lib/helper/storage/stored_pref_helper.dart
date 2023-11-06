import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveImage(List<int> imageBytes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String base64Image = base64Encode(imageBytes);
  return prefs.setString("image", base64Image);
}

Future<Image> getImage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var image = prefs.getString("image") ?? "";
  Uint8List bytes;
  bytes = base64Decode(image);
  return Image.memory(bytes);
}
