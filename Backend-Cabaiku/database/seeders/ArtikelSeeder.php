<?php

namespace Database\Seeders;

use App\Models\Artikel;
use Illuminate\Database\Seeder;

class ArtikelSeeder extends Seeder
{
    public function run(): void
    {
        $artikels = [
            [
                'judul'        => 'Cara Mencegah Hama pada Tanaman Cabai',
                'slug'         => 'cara-mencegah-hama-tanaman-cabai',
                'kategori'     => 'Hama & Penyakit',
                'waktu_baca'   => 5,
                'ringkasan'    => 'Hama merupakan salah satu musuh utama petani cabai. Pelajari cara efektif untuk mencegah dan mengendalikan hama.',
                'konten'       => '<h2>Pengenalan Hama Cabai</h2><p>Tanaman cabai rentan terhadap berbagai jenis hama yang dapat merusak hasil panen. Hama utama yang sering menyerang antara lain kutu daun (aphid), thrips, tungau merah, dan ulat grayak.</p><h2>Cara Pencegahan</h2><p><strong>1. Penggunaan Mulsa</strong><br>Pasang mulsa plastik hitam-perak untuk mencegah hama tanah dan memantulkan sinar matahari yang mengganggu thrips.</p><p><strong>2. Rotasi Tanaman</strong><br>Lakukan rotasi tanaman setiap musim untuk memutus siklus hidup hama yang spesifik pada tanaman cabai.</p><p><strong>3. Pestisida Nabati</strong><br>Gunakan ekstrak bawang putih, daun mimba, atau lengkuas sebagai pestisida alami yang aman bagi lingkungan.</p><h2>Pengendalian Kimiawi</h2><p>Jika populasi hama sudah tinggi, gunakan insektisida berbahan aktif imidakloprid atau abamektin sesuai dosis anjuran. Semprotkan pada pagi hari saat hama aktif.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=800',
                'penulis'      => 'Dr. Agus Widodo',
                'published_at' => now()->subDays(21),
            ],
            [
                'judul'        => 'Pupuk Terbaik untuk Pertumbuhan Cabai',
                'slug'         => 'pupuk-terbaik-pertumbuhan-cabai',
                'kategori'     => 'Perawatan',
                'waktu_baca'   => 6,
                'ringkasan'    => 'Pemupukan yang tepat adalah kunci sukses budidaya cabai. Kenali jenis pupuk yang cocok untuk tanaman Anda.',
                'konten'       => '<h2>Kebutuhan Nutrisi Tanaman Cabai</h2><p>Tanaman cabai membutuhkan unsur hara makro (N, P, K) dan mikro (Ca, Mg, S, Fe) untuk tumbuh optimal.</p><h2>Pupuk Dasar</h2><p><strong>Kompos/Pupuk Kandang:</strong> Berikan 20-30 ton/ha saat pengolahan tanah untuk memperbaiki struktur dan kesuburan tanah.</p><h2>Pupuk Susulan</h2><p><strong>NPK 16-16-16:</strong> Aplikasikan 200 kg/ha pada umur 2 MST, 4 MST, dan 6 MST.<br><strong>KCl:</strong> Tambahkan 150 kg/ha saat pembungaan untuk meningkatkan kualitas buah.</p><h2>Pupuk Organik Cair</h2><p>Siram dengan MOL buatan sendiri dari bonggol pisang setiap 2 minggu untuk merangsang pertumbuhan akar.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800',
                'penulis'      => 'Ir. Sari Pertiwi',
                'published_at' => now()->subDays(23),
            ],
            [
                'judul'        => 'Teknik Panen Cabai yang Benar',
                'slug'         => 'teknik-panen-cabai-benar',
                'kategori'     => 'Panen',
                'waktu_baca'   => 4,
                'ringkasan'    => 'Mengetahui waktu dan teknik panen yang tepat dapat meningkatkan kualitas dan kuantitas hasil panen cabai Anda.',
                'konten'       => '<h2>Menentukan Waktu Panen</h2><p>Cabai siap dipanen pada umur 70-90 hari setelah tanam tergantung varietas. Petik cabai beserta tangkainya menggunakan gunting bersih.</p><h2>Frekuensi Panen</h2><p>Panen dilakukan setiap 3-5 hari sekali. Jangan terlalu lama membiarkan buah masak di pohon.</p><h2>Penanganan Pasca Panen</h2><p>Simpan cabai di tempat sejuk dan berventilasi baik. Jangan dicuci sebelum disimpan.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800',
                'penulis'      => 'Tim Cabaiku',
                'published_at' => now()->subDays(28),
            ],
            [
                'judul'        => 'Mengenal Penyakit Antraknosa pada Cabai',
                'slug'         => 'penyakit-antraknosa-cabai',
                'kategori'     => 'Hama & Penyakit',
                'waktu_baca'   => 7,
                'ringkasan'    => 'Antraknosa adalah penyakit paling merugikan pada cabai. Kenali gejala dan cara penanganannya.',
                'konten'       => '<h2>Apa itu Antraknosa?</h2><p>Antraknosa atau patek disebabkan oleh Colletotrichum acutatum dan C. gloeosporioides. Penyakit ini menyebabkan kerugian hingga 100% jika tidak ditangani.</p><h2>Gejala</h2><p>Buah yang terinfeksi menunjukkan bercak coklat kehitaman dengan tepi yang jelas, melekuk ke dalam. Pada kondisi lembab muncul massa spora berwarna jingga.</p><h2>Pengendalian</h2><p><strong>Preventif:</strong> Gunakan benih sehat bersertifikat, bersihkan sisa tanaman sakit.<br><strong>Kuratif:</strong> Semprot fungisida berbahan aktif azoksistrobin atau mankozeb. Interval semprot 7 hari.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1560806175-b85b7cf5b1b2?w=800',
                'penulis'      => 'Prof. Hendra Kusuma',
                'published_at' => now()->subDays(35),
            ],
            [
                'judul'        => 'Panduan Lengkap Budidaya Cabai Rawit',
                'slug'         => 'panduan-budidaya-cabai-rawit',
                'kategori'     => 'Tips Budidaya',
                'waktu_baca'   => 10,
                'ringkasan'    => 'Panduan lengkap dari persiapan lahan hingga panen untuk budidaya cabai rawit yang menguntungkan.',
                'konten'       => '<h2>Persiapan Benih</h2><p>Pilih benih cabai rawit varietas unggul. Rendam benih dalam air hangat 50°C selama 30 menit sebelum semai.</p><h2>Persemaian</h2><p>Semai benih dalam tray berisi campuran tanah, kompos, dan pasir (1:1:1). Bibit siap pindah setelah 25-30 hari atau memiliki 4-5 daun sejati.</p><h2>Persiapan Lahan</h2><p>Bajak tanah sedalam 30 cm, tambahkan kapur jika pH kurang dari 6. Buat bedengan lebar 1 m, tinggi 30 cm, pasang mulsa plastik.</p><h2>Pemeliharaan</h2><p>Penyiraman 2x sehari di musim kemarau. Pemupukan NPK setiap 2 minggu. Pasang ajir saat tanaman setinggi 30 cm.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=800',
                'penulis'      => 'Ir. Bambang Setiawan',
                'published_at' => now()->subDays(42),
            ],
            [
                'judul'        => 'Strategi Menghadapi Musim Hujan untuk Petani Cabai',
                'slug'         => 'strategi-musim-hujan-petani-cabai',
                'kategori'     => 'Tips Budidaya',
                'waktu_baca'   => 8,
                'ringkasan'    => 'Musim hujan membawa tantangan tersendiri. Persiapkan strategi yang tepat agar tanaman cabai tetap sehat.',
                'konten'       => '<h2>Tantangan Musim Hujan</h2><p>Curah hujan tinggi meningkatkan kelembaban yang memicu ledakan penyakit jamur dan bakteri. Genangan air menyebabkan busuk akar.</p><h2>Persiapan Lahan</h2><p>Tinggikan bedengan minimal 40 cm. Buat saluran drainase yang baik di sekeliling lahan.</p><h2>Perlindungan Tanaman</h2><p>Semprot fungisida preventif berbahan tembaga setiap 7 hari. Pasang naungan plastik UV jika memungkinkan.</p><h2>Monitoring Intensif</h2><p>Periksa tanaman setiap hari. Cabut segera tanaman yang menunjukkan gejala penyakit sistemik.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1495107334309-fcf20504a5ab?w=800',
                'penulis'      => 'Ir. Fajar Nugroho',
                'published_at' => now()->subDays(49),
            ],
            [
                'judul'        => 'Cara Membuat Pupuk Organik Cair dari Sampah Dapur',
                'slug'         => 'pupuk-organik-cair-sampah-dapur',
                'kategori'     => 'Perawatan',
                'waktu_baca'   => 5,
                'ringkasan'    => 'Manfaatkan sampah dapur menjadi pupuk organik cair berkualitas tinggi untuk tanaman cabai Anda.',
                'konten'       => '<h2>Bahan-Bahan</h2><p>Sisa sayuran dan buah, air cucian beras, gula merah 200g, EM4 200ml, air 10 liter.</p><h2>Cara Pembuatan</h2><p>1. Cincang halus sisa sayuran<br>2. Campurkan semua bahan dalam wadah tertutup<br>3. Fermentasi 14 hari, aduk setiap 2-3 hari<br>4. Saring dan simpan dalam botol</p><h2>Cara Penggunaan</h2><p>Encerkan 1:10 untuk penyiraman, 1:20 untuk semprot daun. Aplikasikan seminggu sekali pagi hari.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1599639668273-3d86d4e5a6a3?w=800',
                'penulis'      => 'Tim Cabaiku',
                'published_at' => now()->subDays(56),
            ],
            [
                'judul'        => 'Penyakit Layu Fusarium: Deteksi Dini dan Penanganan',
                'slug'         => 'penyakit-layu-fusarium-cabai',
                'kategori'     => 'Hama & Penyakit',
                'waktu_baca'   => 6,
                'ringkasan'    => 'Layu fusarium dapat menghancurkan seluruh tanaman. Kenali tandanya sejak awal untuk mencegah kerugian besar.',
                'konten'       => '<h2>Mengenal Layu Fusarium</h2><p>Disebabkan oleh jamur tular tanah Fusarium oxysporum f.sp. capsici. Patogen ini dapat bertahan di tanah selama bertahun-tahun.</p><h2>Gejala Awal</h2><p>Daun menguning dari bawah ke atas. Tanaman layu di siang hari namun segar kembali di malam hari. Belah batang: tampak perubahan warna coklat pada jaringan pembuluh.</p><h2>Pengendalian Terpadu</h2><p>Fokus pada pencegahan: solarisasi tanah, aplikasi Trichoderma sp., penggunaan varietas tahan, dan rotasi tanaman 2-3 musim.</p>',
                'gambar'       => 'https://images.unsplash.com/photo-1598512752271-33f913a5af13?w=800',
                'penulis'      => 'Dr. Rina Wulandari',
                'published_at' => now()->subDays(63),
            ],
        ];

        foreach ($artikels as $data) {
            Artikel::create($data);
        }
    }
}
