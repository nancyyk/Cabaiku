import 'package:flutter/material.dart';
import '../../core/utils/colors.dart';

class HomeStyles {
  static const titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const articleTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const articleDesc = TextStyle(fontSize: 13, color: Colors.black54);

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.black.withOpacity(0.05)),
  );
}
