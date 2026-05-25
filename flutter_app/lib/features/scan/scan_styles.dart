import 'package:flutter/material.dart';

import '../../core/utils/colors.dart';

class ScanStyles {
  static const headerTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const headerSubtitle = TextStyle(
    color: AppColors.textMuted,
    fontSize: 14,
  );

  static const sectionLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );

  static const sectionTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: AppColors.text,
  );

  static const optionTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.text,
  );

  static const optionSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static const tipTitle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF1E40AF),
    fontSize: 14,
  );

  static const tipText = TextStyle(
    fontSize: 13,
    color: Color(0xFF1E3A8A),
    height: 1.4,
  );

  static const detectionDetailTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
    color: Color(0xFF0F172A),
  );

  static const detectionResultLabel = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const summaryTitle = TextStyle(
    fontWeight: FontWeight.w700,
    color: Color(0xFF92400E),
    fontSize: 12,
  );

  static const summaryText = TextStyle(
    color: Color(0xFF78350F),
    fontSize: 12,
    height: 1.3,
  );

  static const tipBulletText = TextStyle(
    fontSize: 13,
    color: Color(0xFF1E3A8A),
    height: 1.4,
  );

  static const headerSpacing = SizedBox(height: 6);
  static const sectionSpacing = SizedBox(height: 20);
}
