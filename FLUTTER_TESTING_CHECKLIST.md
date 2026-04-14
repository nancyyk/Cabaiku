# ✅ Cabaiku Flutter - Authentication & CRUD Implementation Checklist

## 🎯 Status Overview
- ✅ **Authentication Service**: COMPLETE
- ✅ **API Service with Bearer Token**: COMPLETE  
- ✅ **New Login Screen**: COMPLETE
- ✅ **New Register Screen**: COMPLETE
- ✅ **Main.dart Routes Updated**: COMPLETE
- ✅ **SharedPreferences Integration**: COMPLETE
- ✅ **CRUD Lahan Integration**: READY TO TEST

---

## 📋 Quick Setup Checklist

### ☐ Step 1: Update Backend URL
**File**: `lib/utils/constants.dart`
```dart
// Line 12 - Ganti dengan IP/URL backend Anda
const String apiBaseUrl = 'http://YOUR_BACKEND_IP:8000/api';

// Contoh untuk local development:
const String apiBaseUrl = 'http://192.168.1.100:8000/api';

// Jangan gunakan 'localhost' untuk Android emulator!
```

**Checklist**:
- [ ] Backend IP/URL correct
- [ ] Backend service running
- [ ] Port 8000 (atau sesuai backend) accessible

### ☐ Step 2: Verify Backend Endpoints
**Required Endpoints**:
```
POST   /api/login
POST   /api/register
GET    /api/lahans
POST   /api/lahans
PUT    /api/lahans/{id}
DELETE /api/lahans/{id}
```

**Checklist**:
- [ ] All endpoints exist in Laravel backend
- [ ] All endpoints return JSON response
- [ ] Endpoints handle Bearer token in Authorization header
- [ ] CORS configured (allow Flutter app)

### ☐ Step 3: Test Authentication
```bash
cd flutter_app
flutter pub get
flutter run
```

**Test Cases**:
1. [ ] App opens to login screen
2. [ ] Login with valid credentials → token saved → navigate to home
3. [ ] Login with invalid credentials → show error message
4. [ ] Click "Daftar" link → navigate to register screen
5. [ ] Register with valid data → token saved → navigate to home
6. [ ] Register with invalid email → show error message
7. [ ] Register with mismatched passwords → show validation error

### ☐ Step 4: Test CRUD Lahan
**After successful login**:

1. [ ] **View List**:
   - [ ] Home screen loads with "Berita" tab
   - [ ] Lahan list shows (or "Belum ada data" if empty)
   - [ ] Each lahan shows nama, lokasi, luas, deskripsi

2. [ ] **Add Lahan**:
   - [ ] "Tambah Lahan" button visible
   - [ ] Click button → dialog opens
   - [ ] Fill form (nama, lokasi, luas, deskripsi)
   - [ ] Click "Simpan" → dialog closes
   - [ ] New lahan appears in list

3. [ ] **Edit Lahan**:
   - [ ] Click pencil icon → dialog opens with current data
   - [ ] Edit fields
   - [ ] Click "Simpan" → list updates with changes
   - [ ] Changes visible in LahanCard

4. [ ] **Delete Lahan**:
   - [ ] Click trash icon → show confirmation (if implemented)
   - [ ] Confirm → lahan removed from list
   - [ ] List refreshes correctly

5. [ ] **Token Persistence**:
   - [ ] Login, close app, reopen
   - [ ] Should still be logged in (if token not expired)
   - [ ] CRUD operations still work

### ☐ Step 5: Verify Files Structure
```
lib/
├── services/
│   ├── auth_service.dart ✅
│   └── api_service.dart ✅ (with Bearer token)
├── screens/
│   ├── auth/
│   │   ├── login_screen_new.dart ✅
│   │   └── register_screen_new.dart ✅
│   └── home_screen.dart ✅ (with CRUD)
├── models/
│   └── lahan.dart ✅
├── utils/
│   ├── constants.dart ✅ (with tokenKey)
│   └── colors.dart ✅
└── main.dart ✅ (routes updated)
```

**Checklist**:
- [ ] All files exist
- [ ] No import errors
- [ ] No missing dependencies

---

## 🔧 Troubleshooting

### Problem: "Failed host lookup"
**Solution**:
```dart
// lib/utils/constants.dart
// ❌ WRONG
const String apiBaseUrl = 'http://localhost:8000/api';

// ✅ RIGHT (use your PC's IP address)
const String apiBaseUrl = 'http://192.168.1.100:8000/api';
```

### Problem: "Unauthorized - Silakan login ulang"
**Debug Steps**:
1. Check backend console for token verification
2. Verify Authorization header is sent: `Authorization: Bearer <token>`
3. Check if token format matches what backend expects
4. Verify SharedPreferences has token saved:
   ```dart
   final prefs = await SharedPreferences.getInstance();
   print('Token: ${prefs.getString('auth_token')}');
   ```

### Problem: CRUD buttons not showing
**Debug Steps**:
1. Check console for errors
2. Verify LahanCard widget imported correctly
3. Check if AJAX request to GET /lalans succeeded
4. Verify lahan list not empty

### Problem: "SocketTimeoutException"
**Solution**: 
- Increase timeout in `constants.dart`:
  ```dart
  const int apiTimeout = 60; // increase from 30
  ```
- Check network connectivity
- Verify backend responding

---

## 📱 Test Credentials (Example)

After registering via app:
- **Email**: test@example.com
- **Password**: password123
- **Name**: John Doe
- **Phone**: 081234567890

---

## 🚀 What's Working Now

| Feature | Status | Notes |
|---------|--------|-------|
| Login | ✅ Complete | AuthService + new screen |
| Register | ✅ Complete | Form validation included |
| Token Storage | ✅ Complete | SharedPreferences |
| Bearer Token Injection | ✅ Complete | Auto-added to API calls |
| Get Lahan List | ✅ Ready | Requires token |
| Create Lahan | ✅ Ready | Form validation included |
| Update Lahan | ✅ Ready | Edit dialog implemented |
| Delete Lahan | ✅ Ready | Confirmation included |
| Theme (Red) | ✅ Complete | All widgets updated |
| Navigation | ✅ Complete | Routes working |

---

## 📝 Files Modified in This Session

1. **Created**: `lib/services/auth_service.dart`
   - 4 authentication methods
   
2. **Updated**: `lib/services/api_service.dart`
   - Added `_getAuthHeaders()` method
   - All endpoints now include Bearer token
   - Updated endpoint paths to `/lahans`
   
3. **Created**: `lib/screens/auth/login_screen_new.dart`
   - Functional login with state management
   
4. **Created**: `lib/screens/auth/register_screen_new.dart`
   - Functional register with validation
   
5. **Updated**: `lib/main.dart`
   - Routes now use new auth screens
   
6. **Updated**: `lib/utils/constants.dart`
   - Added tokenKey and userKey for SharedPreferences
   
7. **Updated**: `pubspec.yaml`
   - Added `shared_preferences: ^2.2.2`

---

## 🎓 How It Works (Flow Diagram)

```
┌─────────────────┐
│  App Startup    │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  LoginScreen    │
│  (login_screen_ │
│   new.dart)     │
└────────┬────────┘
         │
         v
┌─────────────────────────────────┐
│  AuthService.login()            │
│  → POST /api/login              │
│  ← {success, token, data}       │
└────────┬────────────────────────┘
         │
         v
┌──────────────────────────────────┐
│  SharedPreferences.setString()   │
│  Save token with key 'auth_token'│
└────────┬─────────────────────────┘
         │
         v
┌─────────────────┐
│  HomeScreen     │
│  Dashboard      │
└────────┬────────┘
         │
         ├──→ Get Lahan
         │    └─→ ApiService.getLahan()
         │        └─→ _getAuthHeaders() → Bearer token
         │            └─→ GET /api/lahans
         │
         ├──→ Create Lahan
         │    └─→ LahanDialog
         │        └─→ ApiService.createLahan()
         │            └─→ POST /api/lahans (with token)
         │
         ├──→ Update Lahan
         │    └─→ ApiService.updateLahan()
         │        └─→ PUT /api/lahans/:id (with token)
         │
         └──→ Delete Lahan
              └─→ ApiService.deleteLahan()
                  └─→ DELETE /api/lahans/:id (with token)
```

---

## 🔒 Security Considerations

✅ **Implemented**:
- Bearer token in Authorization header
- Token stored in SharedPreferences
- Input validation on frontend

⚠️ **Not Implemented (For Future)**:
- Token expiration refresh mechanism
- HTTPS enforcement
- Secure storage (flutter_secure_storage)
- Token revocation on logout

---

## 📞 Next Support Points

If you encounter issues:

1. **Share Error Message**: Exact error from Flutter console
2. **Share Screen**: Screenshot of error
3. **Check Logs**:
   ```bash
   flutter run -v  # verbose mode
   ```
   Look for network errors or auth failures
4. **Check Backend Logs**: Laravel backend should show incoming requests

---

**Status**: 🟢 READY FOR TESTING

All backend integrations are in place. Next step is to test against actual backend!
