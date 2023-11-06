import 'package:flutter/material.dart';

void ShowWrongCredsSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Wrong credentials. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.red,
    ),
  );
}
