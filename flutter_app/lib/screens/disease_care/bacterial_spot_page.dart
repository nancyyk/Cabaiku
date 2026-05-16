import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class BacterialSpotPage extends StatelessWidget {
  const BacterialSpotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(content: diseaseCareLibrary['bacterial_spot']!);
  }
}
