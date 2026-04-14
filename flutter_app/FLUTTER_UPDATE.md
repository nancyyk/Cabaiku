# Cabaiku Flutter App - Update Documentation

## 🎨 Perubahan Tema
Aplikasi Flutter telah diperbarui untuk sesuai dengan tema web yang menggunakan palet warna merah:

### Warna Utama
- **Primary**: #C0392B (Merah)
- **Primary Dark**: #922B21 (Merah Gelap)
- **Primary Light**: #F1948A (Merah Muda)
- **Accent**: #E74C3C (Merah Accent)

Semua warna telah diupdate di file `lib/utils/colors.dart`.

## 📋 CRUD Lahan - Fitur Baru

### Fitur yang Ditambahkan
1. **Read**: Tampilkan daftar lahan di halaman beranda
2. **Create**: Tambah lahan baru melalui dialog
3. **Update**: Edit informasi lahan yang sudah ada
4. **Delete**: Hapus lahan dengan konfirmasi

### Lokasi File
```
lib/
├── models/
│   └── lahan.dart              # Model data Lahan
├── services/
│   └── api_service.dart        # Service untuk API calls
├── widgets/
│   ├── cards/
│   │   └── lahan_card.dart     # Card untuk tampilkan lahan
│   └── dialogs/
│       └── lahan_dialog.dart   # Dialog untuk add/edit lahan
└── screens/
    └── home_screen.dart        # Updated dengan CRUD lahan
```

## 🔌 Library yang Ditambahkan
```yaml
dependencies:
  http: ^1.1.0           # HTTP client untuk API calls
  intl: ^0.19.0          # Untuk formatting tanggal
```

### Instalasi
```bash
cd flutter_app
flutter pub get
```

## ⚙️ Konfigurasi API

### Setup Backend URL
Edit file `lib/utils/constants.dart`:

```dart
// Untuk development lokal
const String apiBaseUrl = 'http://localhost:8000/api';

// Untuk testing di local network
const String apiBaseUrl = 'http://192.168.1.100:8000/api';

// Untuk production
const String apiBaseUrl = 'https://api.cabaiku.com/api';
```

### Android Development
Untuk mengakses backend di local network dari Android emulator:
```dart
// Edit constants.dart
const String apiBaseUrl = 'http://10.0.2.2:8000/api';
```

## 📱 UI Components

### LahanCard
Menampilkan informasi lahan dengan action edit dan delete:
- Nama lahan
- Lokasi
- Luas lahan (opsional)
- Deskripsi (opsional)
- Tombol edit dan delete

### LahanDialog
Dialog untuk menambah atau edit lahan dengan fields:
- Nama Lahan (required)
- Lokasi (required)  
- Luas Lahan (optional)
- Deskripsi (optional)

### Empty State
Tampilan ketika belum ada lahan, dengan tombol untuk tambah lahan pertama.

## 🎯 Integrasi di Home Screen

### Section Lahan
Ditampilkan di halaman beranda setelah stats card dan menu cards:
```
1. Header "🌾 Lahan Saya" dengan tombol "+ Tambah"
2. FutureBuilder untuk load data dengan loading indicator
3. List LahanCard untuk setiap lahan
4. Empty state jika belum ada lahan
```

## 🔄 API Endpoints

Aplikasi mengharapkan endpoint berikut di backend:

```
GET    /api/lahan              # Get all lahan
GET    /api/lahan/:id          # Get single lahan
POST   /api/lahan              # Create lahan
PUT    /api/lahan/:id          # Update lahan
DELETE /api/lahan/:id          # Delete lahan
```

### Request/Response Format
```json
// Create/Update request
{
  "nama_lahan": "Lahan Utama",
  "lokasi": "Jl. Raya No. 123",
  "luas_lahan": 0.5,
  "deskripsi": "Catatan lahan"
}

// Response
{
  "data": {
    "id": 1,
    "nama_lahan": "Lahan Utama",
    "lokasi": "Jl. Raya No. 123",
    "luas_lahan": 0.5,
    "deskripsi": "Catatan lahan",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

## 📝 Backwards Compatibility
Warna hijau lama masih tersimpan di `AppColors` untuk backward compatibility:
- `AppColors.primaryGreen`
- `AppColors.bgLightGreen`
- `AppColors.textGrey`

## 🚀 Langkah Selanjutnya

1. **Setup Backend**: Pastikan backend memiliki endpoint `/api/lahan` yang sesuai
2. **Test API Connection**: Update URL di `constants.dart` dan test
3. **Error Handling**: Tambahkan custom error messages untuk user
4. **Offline Support**: Pertimbangkan menambahkan local database
5. **Image Upload**: Tambahkan fitur upload foto lahan jika diperlukan

## 🐛 Troubleshooting

### API Connection Error
- Periksa URL di `constants.dart`
- Pastikan backend sedang running
- Cek network permissions di `AndroidManifest.xml`

### CORS Error (jika API di domain berbeda)
- Setup CORS di backend Laravel:
  ```php
  // config/cors.php
  'paths' => ['api/*'],
  'allowed_origins' => ['*'],
  'allowed_methods' => ['*'],
  ```

### Timeout Error
- Tingkatkan `apiTimeout` di `constants.dart`
- Periksa koneksi jaringan

## 📚 Referensi
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Flutter Form Validation](https://flutter.dev/docs/cookbook/forms/validation)
- [FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
