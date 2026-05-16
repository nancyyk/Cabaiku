import 'package:flutter/material.dart';

import 'disease_care_data.dart';
import 'disease_care_page.dart';

class CurlVirusPage extends StatelessWidget {
  const CurlVirusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseCarePage(content: diseaseCareLibrary['curl_virus']!);
  }
}
