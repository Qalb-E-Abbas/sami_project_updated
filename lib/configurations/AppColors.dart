import 'package:flutter/material.dart';

class AppColors {

  static const Color scaffoldBackgroundColor = Colors.white;


  Color colorFromHex(BuildContext context, String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }


}



