import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class NutritionDeficiencyPage extends StatelessWidget {
  const NutritionDeficiencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(
      content: diseaseCareLibrary['nutrition_deficiency']!,
    );
  }
}
