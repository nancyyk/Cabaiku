# Cabaiku

Dokumentasi setup dan REST API untuk aplikasi Cabaiku.

## 1. Setup Project

1. Masuk ke folder project.

```bash
cd cabaiku
```

2. Install dependency.

```bash
composer install
```

3. Buat file environment.

```bash
cp .env.example .env
```

4. Buat database MySQL bernama cabaiku.

5. Generate app key.

```bash
php artisan key:generate
```

6. Jalankan migration dan seeder.

```bash
php artisan migrate --seed
```

7. Buat symbolic link storage.

```bash
php artisan storage:link
```

8. Jalankan aplikasi.

```bash
php artisan serve
```

## 2. REST API Sanctum

Base URL default lokal:

```text
http://127.0.0.1:8000/api
```

Autentikasi menggunakan Bearer Token dari Laravel Sanctum.

Header untuk endpoint private:

```text
Authorization: Bearer {token}
Accept: application/json
```

### Public Endpoint

- POST /register
- POST /login
- GET /artikels
- GET /artikels/{artikel}

### Protected Endpoint (auth:sanctum)

- GET /me
- POST /logout
- POST /logout-all
- Resource lahans: index, store, show, update, destroy
- Resource deteksis: index, store, show, update, destroy
- POST /artikels
- PUT/PATCH /artikels/{artikel}
- DELETE /artikels/{artikel}

## 3. Postman Collection (Poin 1)

File koleksi Postman tersedia di:

- docs/postman/Cabaiku-Sanctum.postman_collection.json

Isi koleksi mencakup request utama:

- Register
- Login
- Me
- Logout
- Artikel List/Store
- Lahan List/Store
- Deteksi List

Cara pakai cepat:

1. Import file collection di Postman.
2. Pastikan variable base_url bernilai http://127.0.0.1:8000.
3. Jalankan request Login.
4. Salin token dari response login ke variable token.
5. Jalankan endpoint private.

## 4. Standar Response API (Poin 2)

Saat ini response masih mengikuti return controller langsung Laravel (model/pagination standar). Untuk konsistensi tim, gunakan standar berikut pada pengembangan selanjutnya:

### Success Response (disarankan)

```json
{
  "success": true,
  "message": "Operasi berhasil",
  "data": {
    "id": 1
  }
}
```

### Error Response (disarankan)

```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    "email": [
      "Email wajib diisi"
    ]
  }
}
```

### Catatan Implementasi

- Gunakan Laravel API Resource untuk membentuk struktur response data.
- Gunakan helper response bersama agar format sukses/gagal seragam.
- Gunakan kode HTTP sesuai konteks: 200, 201, 401, 403, 404, 422, 500.

## 5. Role Admin/User (Poin 3)

Role belum diaktifkan di code saat ini. Rekomendasi kebijakan akses:

### Matriks Akses

- User: register, login, me, logout, CRUD lahan milik sendiri, CRUD deteksi milik sendiri, baca artikel.
- Admin: semua hak user + CRUD artikel.

### Rencana Teknis

1. Tambahkan kolom role pada tabel users (contoh: admin, user).
2. Tambahkan middleware role (misal role:admin).
3. Pasang middleware role:admin pada endpoint artikel tulis (POST/PUT/PATCH/DELETE).
4. Pertahankan endpoint artikel baca (GET) agar tetap public.
