import 'dart:convert';
import 'package:flutter/material.dart';

// ... other imports

class Base64Image extends StatelessWidget {
  final String base64Image;

  const Base64Image({super.key, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      base64Decode(base64Image),
      fit: BoxFit.cover,
    );
  }
}