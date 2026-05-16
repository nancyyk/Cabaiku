class DiseaseCareContent {
  final String id;
  final String title;
  final String scientificName;
  final String overview;
  final List<String> handling;
  final List<String> prevention;

  const DiseaseCareContent({
    required this.id,
    required this.title,
    required this.scientificName,
    required this.overview,
    required this.handling,
    required this.prevention,
  });
}

const Map<String, DiseaseCareContent> diseaseCareLibrary = {
  'bacterial_spot': DiseaseCareContent(
    id: 'bacterial_spot',
    title: 'Bacterial Spot',
    scientificName: 'Xanthomonas spp.',
    overview:
        'Bacterial spot menyebabkan bercak kecil gelap pada daun dan buah. Kondisi lembap dan percikan air mempercepat penyebaran penyakit.',
    handling: [
      'Buang daun atau bagian tanaman yang sudah terinfeksi berat.',
      'Kurangi penyiraman dari atas daun agar bakteri tidak mudah menyebar.',
      'Gunakan bakterisida berbahan aktif tembaga sesuai dosis anjuran.',
      'Lakukan sanitasi alat setelah digunakan di lahan terinfeksi.',
    ],
    prevention: [
      'Gunakan benih sehat dan bebas patogen.',
      'Atur jarak tanam agar sirkulasi udara baik.',
      'Hindari genangan air dan perbaiki drainase lahan.',
      'Lakukan rotasi tanaman dengan komoditas non-solanaceae.',
    ],
  ),
  'cercospora_leaf_spot': DiseaseCareContent(
    id: 'cercospora_leaf_spot',
    title: 'Cercospora Leaf Spot',
    scientificName: 'Cercospora capsici',
    overview:
        'Cercospora leaf spot ditandai bercak bulat cokelat keabu-abuan pada daun. Serangan berat menurunkan luas daun efektif dan hasil panen.',
    handling: [
      'Pangkas daun yang bercak parah untuk menekan sumber inokulum.',
      'Gunakan fungisida kontak atau sistemik secara bergilir sesuai rekomendasi.',
      'Hindari kelembapan tinggi berkepanjangan di kanopi tanaman.',
      'Kumpulkan sisa tanaman sakit dan musnahkan di luar area tanam.',
    ],
    prevention: [
      'Pilih lahan dengan aerasi baik dan tidak terlalu lembap.',
      'Lakukan pemupukan berimbang untuk menjaga ketahanan tanaman.',
      'Gunakan mulsa untuk mengurangi percikan tanah ke daun.',
      'Rutin inspeksi daun bagian bawah sejak fase vegetatif.',
    ],
  ),
  'curl_virus': DiseaseCareContent(
    id: 'curl_virus',
    title: 'Curl Virus',
    scientificName: 'Chili Leaf Curl Virus (CLCV)',
    overview:
        'Curl virus menyebabkan daun keriting, mengecil, dan pertumbuhan tanaman terhambat. Penyakit ini umumnya ditularkan oleh vektor seperti whitefly.',
    handling: [
      'Cabut tanaman yang gejalanya sudah parah untuk memutus sumber virus.',
      'Kendalikan populasi whitefly dengan perangkap kuning atau insektisida selektif.',
      'Bersihkan gulma inang di sekitar lahan karena bisa menjadi reservoir virus.',
      'Lakukan monitoring rutin terutama pada musim panas dan kering.',
    ],
    prevention: [
      'Gunakan benih atau bibit sehat dan terverifikasi.',
      'Pasang mulsa reflektif untuk menekan kedatangan vektor.',
      'Terapkan rotasi tanaman dan sanitasi kebun secara berkala.',
      'Gunakan varietas toleran jika tersedia.',
    ],
  ),
  'healthy_leaf': DiseaseCareContent(
    id: 'healthy_leaf',
    title: 'Healthy Leaf',
    scientificName: 'Healthy Plant Condition',
    overview:
        'Daun dalam kondisi sehat, hijau merata, dan tidak menunjukkan gejala penyakit spesifik. Fokus utama adalah menjaga stabilitas pertumbuhan tanaman.',
    handling: [
      'Pertahankan jadwal penyiraman teratur pagi atau sore.',
      'Lanjutkan pemupukan berimbang sesuai fase pertumbuhan cabai.',
      'Lakukan pemangkasan ringan pada daun tua atau rusak mekanis.',
      'Pantau hama dan penyakit secara preventif setiap beberapa hari.',
    ],
    prevention: [
      'Jaga kebersihan lahan dari gulma dan sisa tanaman sakit.',
      'Pastikan drainase berfungsi baik saat hujan.',
      'Gunakan mulsa untuk menjaga kelembapan tanah stabil.',
      'Lakukan rotasi pestisida bila diperlukan agar tidak terjadi resistensi.',
    ],
  ),
  'nutrition_deficiency': DiseaseCareContent(
    id: 'nutrition_deficiency',
    title: 'Nutrition Deficiency',
    scientificName: 'Nutrient Imbalance Disorder',
    overview:
        'Nutrition deficiency muncul sebagai klorosis, bercak, atau pertumbuhan yang tidak normal akibat kekurangan unsur hara makro maupun mikro.',
    handling: [
      'Identifikasi gejala dominan lalu sesuaikan jenis pupuk yang diberikan.',
      'Berikan pupuk daun untuk koreksi cepat pada gejala akut.',
      'Perbaiki pH tanah agar penyerapan unsur hara lebih optimal.',
      'Gunakan pupuk dasar dan susulan secara bertahap, jangan berlebihan sekaligus.',
    ],
    prevention: [
      'Lakukan uji tanah berkala untuk memantau status hara.',
      'Susun program pemupukan berbasis fase pertumbuhan.',
      'Tambahkan bahan organik untuk memperbaiki struktur tanah.',
      'Hindari overwatering yang bisa mencuci unsur hara penting.',
    ],
  ),
  'white_spot': DiseaseCareContent(
    id: 'white_spot',
    title: 'White Spot',
    scientificName: 'White Spot-like Symptom',
    overview:
        'White spot ditandai bintik pucat atau keputihan pada permukaan daun. Gejala dapat dipicu patogen, hama, atau stres lingkungan.',
    handling: [
      'Pisahkan daun yang gejalanya berat untuk mencegah perluasan area serangan.',
      'Cek bagian bawah daun untuk memastikan ada atau tidaknya hama kecil.',
      'Gunakan fungisida atau insektisida setelah penyebab dominan teridentifikasi.',
      'Optimalkan sirkulasi udara agar daun cepat kering setelah penyiraman.',
    ],
    prevention: [
      'Jaga kebersihan lahan dan hindari penumpukan kelembapan.',
      'Atur jarak tanam agar kanopi tidak terlalu rapat.',
      'Lakukan inspeksi rutin pada daun muda dan daun tua.',
      'Lakukan karantina bibit baru sebelum ditanam di lahan utama.',
    ],
  ),
};
