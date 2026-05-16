import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class CercosporaLeafSpotPage extends StatelessWidget {
  const CercosporaLeafSpotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(
      content: diseaseCareLibrary['cercospora_leaf_spot']!,
    );
  }
}
