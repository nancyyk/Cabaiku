# Panduan Implementasi Authentication dan CRUD Lahan - Cabaiku Flutter

## ✅ Yang Sudah Selesai

### 1. Authentication Service (`lib/services/auth_service.dart`)
- ✅ Created dengan 4 methods:
  - `login(email, password)` - Login dengan email/password
  - `register(name, email, phone, password, passwordConfirmation)` - Register user baru
  - `getMe(token)` - Get kurren user info
  - `logout(token)` - Logout dan clear token

### 2. Updated API Service (`lib/services/api_service.dart`)
- ✅ Added Bearer token authentication
- ✅ Method `_getAuthHeaders()` untuk automatic token injection
- ✅ Semua CRUD methods sekarang include Authorization header:
  - `getLahan()` - GET /lahans
  - `getLahanById(id)` - GET /lahans/:id
  - `createLahan(lahan)` - POST /lahans
  - `updateLahan(id, lahan)` - PUT /lahans/:id
  - `deleteLahan(id)` - DELETE /lahans/:id

### 3. Functional Auth Screens (NEW)
- ✅ `lib/screens/auth/login_screen_new.dart`
  - Complete login form dengan validation
  - TextEditingControllers untuk email/password
  - Loading state dan error display
  - Token auto-save ke SharedPreferences
  - Auto-navigate ke /home pada success

- ✅ `lib/screens/auth/register_screen_new.dart`
  - Complete registration form dengan 5 fields
  - Client-side validation (empty check, password match, min 6 chars)
  - Token saving dan navigation
  - Error handling dan loading state

### 4. Updated main.dart
- ✅ Routes updated untuk menggunakan screen baru:
  - `/login` → `LoginScreenNew()`
  - `/register` → `RegisterScreenNew()`
- ✅ All existing routes tetap berfungsi normal

### 5. Dependencies
- ✅ `shared_preferences: ^2.2.2` - untuk token storage
- ✅ `http: ^1.1.0` - API calls
- ✅ `intl: ^0.19.0` - date formatting

---

## 🔧 Langkah Selanjutnya untuk Testing

### Step 1: Update Backend URL (CRITICAL!)
Edit `lib/utils/constants.dart`:
```dart
const String apiBaseUrl = 'http://YOUR_BACKEND_IP:8000/api';
// Contoh: 'http://192.168.1.100:8000/api' atau 'http://localhost:8000/api'
const int apiTimeout = 30;
```

**PENTING**: Ganti `YOUR_BACKEND_IP` dengan IP/domain Laravel backend Anda!

### Step 2: Pastikan Backend Laravel Endpoints Ready
Backend harus punya endpoints:
```
POST   /api/login         - accept: {email, password}
POST   /api/register      - accept: {name, email, phone, password, password_confirmation}
GET    /api/lahans        - require: Bearer token
POST   /api/lahans        - require: Bearer token
PUT    /api/lahans/:id    - require: Bearer token
DELETE /api/lahans/:id    - require: Bearer token
```

Response format yang diexpect:
```json
{
  "success": true,
  "data": {...},
  "token": "Bearer token (untuk login/register)",
  "message": "Success message",
  "errors": [] // untuk error cases
}
```

### Step 3: Run Flutter App
```bash
cd flutter_app
flutter doctor  # pastikan environment OK
flutter pub get # install dependencies
flutter run     # run app
```

### Step 4: Test Login Flow
1. Open app - akan landing di login screen
2. Input email dan password dari backend
3. Click "Masuk" button
4. **Expected**: Token saved ke SharedPreferences, navigate ke home
5. **If error**: Check:
   - Backend URL correct di constants.dart
   - Backend login endpoint respond dengan {success: true, token: "..."}
   - Network connectivity

### Step 5: Test Register Flow
1. Go ke /register
2. Fill all fields:
   - Name: Nama lengkap
   - Email: valid email
   - Phone: nomor telepon
   - Password: min 6 chars
   - Password Confirmation: match dengan password
3. Click "Daftar"
4. **Expected**: Token saved dan navigate ke home
5. **If error**: Check:
   - Email belum terdaftar
   - Validation message muncul dengan jelas

### Step 6: Test CRUD Lahan
1. Login successfully (token ada di SharedPreferences)
2. Go ke home screen (tab "Berita" atau default)
3. Should see list of lahan (or empty message jika belum ada)
4. **Add Lahan**:
   - Click "Tambah Lahan" button
   - Fill form (nama, lokasi, luas, deskripsi)
   - Click "Simpan"
   - **Expected**: Dialog close, list refresh dengan lahan baru
5. **Edit Lahan**:
   - Click pencil icon pada lahan card
   - Edit fields
   - Click "Simpan"
   - **Expected**: Dialog close, list refresh dengan changes
6. **Delete Lahan**:
   - Click trash icon pada lahan card
   - Confirm delete
   - **Expected**: Lahan hilang dari list

---

## 🐛 Common Issues & Solutions

### Issue 1: "SocketException: Failed host lookup"
**Cause**: Backend URL di constants.dart salah atau backend tidak running
**Solution**:
```dart
// Edit lib/utils/constants.dart
// WRONG: const String apiBaseUrl = 'http://localhost:8000/api';
// RIGHT: const String apiBaseUrl = 'http://192.168.1.100:8000/api'; // IP lokal
```
Untuk emulator: gunakan IP fisik PC, bukan localhost

### Issue 2: "Unauthorized - Silakan login ulang"
**Cause**: Token belum dikirim, atau format Bearer token salah
**Check**:
- Pastikan login success dan token saved ke SharedPreferences
- Verify backend check `Authorization: Bearer <token>` header
- Console log di backend untuk trace request

### Issue 3: "PasswordConfirmation mismatch" saat Register
**Cause**: Password tidak match dengan password confirmation
**Solution**: Pastikan password fields match sebelum click Daftar

### Issue 4: CRUD buttons tidak visible
**Cause**: Theme atau widget hierarchy issue
**Check**: 
- `lib/screens/home_screen.dart` - pastikan LahanCard section terupdate
- `lib/widgets/cards/lahan_card.dart` - pastikan button colors OK
- No errors di Flutter console

### Issue 5: "Null exception" saat buka dialog
**Cause**: Data model structure tidak match API response
**Check**:
- Verify backend response format match Lahan.fromJson() di `lib/models/lahan.dart`
- Add debug print untuk trace response: `print(jsonDecode(response.body));`

---

## 📝 Architecture Summary

```
lib/
├── services/
│   ├── auth_service.dart        # Authentication (login, register, logout)
│   └── api_service.dart         # CRUD operations (+ Bearer token)
├── models/
│   └── lahan.dart               # Lahan data model
├── screens/
│   ├── auth/
│   │   ├── login_screen_new.dart    # ✨ NEW functional login
│   │   └── register_screen_new.dart # ✨ NEW functional register
│   ├── home_screen.dart         # Dashboard with CRUD Lahan
│   └── [other screens...]
├── widgets/
│   ├── cards/
│   │   └── lahan_card.dart      # Display + edit/delete buttons
│   ├── dialogs/
│   │   └── lahan_dialog.dart    # Add/edit lahan form
│   └── [other widgets...]
├── utils/
│   ├── constants.dart           # API config, token keys
│   └── colors.dart              # Red theme colors
└── main.dart                    # Routes + theme setup
```

### Data Flow
1. **Login** → AuthService.login() → Save token → Navigate /home
2. **CRUD** → ApiService (auto-adds Bearer token) → Update UI
3. **Logout** → Clear token from SharedPreferences → Navigate /login

---

## 🔐 Security Notes

⚠️ **Current Implementation**:
- Token stored di SharedPreferences (accessible via app)
- No automatic token refresh (token lama akan invalid)
- No logout endpoint call before clearing token

✅ **For Production, Add**:
1. Token expiration check + refresh mechanism
2. HTTPS only (not HTTP)
3. Secure storage package (flutter_secure_storage)
4. Call logout endpoint sebelum clear token

---

## 📦 Expected Backend Response Formats

### Login Success
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "081234567890"
  }
}
```

### Register Success
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "data": {
    "id": 2,
    "name": "Jane Doe",
    "email": "jane@example.com",
    "phone": "082345678901"
  }
}
```

### Get Lahans
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nama_lahan": "Lahan A",
      "lokasi": "Jl. Merpati",
      "luas_lahan": 500,
      "deskripsi": "Lahan padi",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Error Response
```json
{
  "success": false,
  "message": "Invalid credentials",
  "errors": {
    "email": ["Email not found"]
  }
}
```

---

## ✨ Next Feature Ideas (Future)

1. **Token Refresh**: Auto-refresh token sebelum expired
2. **Logout**: Clear token + API call
3. **Profile Screen**: Show user data, edit profile
4. **Image Upload**: Upload foto untuk lahan
5. **Notifications**: Real-time updates
6. **Offline Mode**: Cache dengan local database

---

**Siap untuk testing! 🚀**

Jika ada error atau issue, share error message dan saya bantu troubleshoot.
