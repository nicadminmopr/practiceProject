import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading({Color color = Colors.black, double fontSize = 24}) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle body({Color color = Colors.black, double fontSize = 16}) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: fontSize,
    );
  }
}
