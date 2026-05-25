import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class WhiteSpotPage extends StatelessWidget {
  const WhiteSpotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(content: diseaseCareLibrary['white_spot']!);
  }
}
