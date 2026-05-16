import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class HealthyLeafPage extends StatelessWidget {
  const HealthyLeafPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(content: diseaseCareLibrary['healthy_leaf']!);
  }
}
