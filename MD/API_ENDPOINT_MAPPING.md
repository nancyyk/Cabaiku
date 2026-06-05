# 🔗 API Endpoint Mapping - Cabaiku Flutter ↔ Laravel Backend

## Authentication Endpoints

### Login
```
CLIENT REQUEST:
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "081234567890"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Login successful"
}

CODE: lib/services/auth_service.dart → login()
```

### Register
```
CLIENT REQUEST:
POST /api/register
Content-Type: application/json

{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone": "082345678901",
  "password": "password123",
  "password_confirmation": "password123"
}

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 2,
    "name": "Jane Doe",
    "email": "jane@example.com",
    "phone": "082345678901"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Register successful"
}

CODE: lib/services/auth_service.dart → register()
```

### Get Current User
```
CLIENT REQUEST:
GET /api/me
Authorization: Bearer <token>

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "081234567890"
  }
}

CODE: lib/services/auth_service.dart → getMe()
```

### Logout
```
CLIENT REQUEST:
POST /api/logout
Authorization: Bearer <token>

EXPECTED RESPONSE:
{
  "success": true,
  "message": "Logout successful"
}

CODE: lib/services/auth_service.dart → logout()
```

---

## CRUD Lahan Endpoints

### Get All Lahan
```
CLIENT REQUEST:
GET /api/lahans
Authorization: Bearer <token>

EXPECTED RESPONSE:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nama_lahan": "Lahan Padi A",
      "lokasi": "Jl. Merpati No. 123",
      "luas_lahan": 500,
      "deskripsi": "Lahan padi berkualitas baik",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": 2,
      "nama_lahan": "Lahan Cabai B",
      "lokasi": "Jl. Sawah No. 45",
      "luas_lahan": 300,
      "deskripsi": "Lahan cabai dengan drainase bagus",
      "created_at": "2024-01-16T08:15:00Z",
      "updated_at": "2024-01-16T08:15:00Z"
    }
  ]
}

CODE: lib/services/api_service.dart → getLahan()
CALLED FROM: lib/screens/home_screen.dart → _buildBerandaContent()
```

### Get Single Lahan
```
CLIENT REQUEST:
GET /api/lahans/1
Authorization: Bearer <token>

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 1,
    "nama_lahan": "Lahan Padi A",
    "lokasi": "Jl. Merpati No. 123",
    "luas_lahan": 500,
    "deskripsi": "Lahan padi berkualitas baik",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}

CODE: lib/services/api_service.dart → getLahanById()
```

### Create Lahan
```
CLIENT REQUEST:
POST /api/lahans
Authorization: Bearer <token>
Content-Type: application/json

{
  "nama_lahan": "Lahan Kebun Cabai",
  "lokasi": "Jl. Sawah No. 100",
  "luas_lahan": 250,
  "deskripsi": "Lahan cahabi dengan sistem irigasi modern"
}

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 3,
    "nama_lahan": "Lahan Kebun Cabai",
    "lokasi": "Jl. Sawah No. 100",
    "luas_lahan": 250,
    "deskripsi": "Lahan cahabi dengan sistem irigasi modern",
    "created_at": "2024-01-17T14:20:00Z",
    "updated_at": "2024-01-17T14:20:00Z"
  },
  "message": "Lahan created successfully"
}

CODE: lib/services/api_service.dart → createLahan()
CALLED FROM: lib/widgets/dialogs/lahan_dialog.dart → _saveLahan()
```

### Update Lahan
```
CLIENT REQUEST:
PUT /api/lahans/3
Authorization: Bearer <token>
Content-Type: application/json

{
  "nama_lahan": "Lahan Kebun Cabai Merah",
  "lokasi": "Jl. Sawah No. 100",
  "luas_lahan": 250,
  "deskripsi": "Lahan cahabi dengan sistem irigasi modern - updated"
}

EXPECTED RESPONSE:
{
  "success": true,
  "data": {
    "id": 3,
    "nama_lahan": "Lahan Kebun Cabai Merah",
    "lokasi": "Jl. Sawah No. 100",
    "luas_lahan": 250,
    "deskripsi": "Lahan cahabi dengan sistem irigasi modern - updated",
    "created_at": "2024-01-17T14:20:00Z",
    "updated_at": "2024-01-17T15:45:00Z"
  },
  "message": "Lahan updated successfully"
}

CODE: lib/services/api_service.dart → updateLahan()
CALLED FROM: lib/widgets/dialogs/lahan_dialog.dart → _saveLahan()
```

### Delete Lahan
```
CLIENT REQUEST:
DELETE /api/lahans/3
Authorization: Bearer <token>

EXPECTED RESPONSE:
{
  "success": true,
  "message": "Lahan deleted successfully"
}

ALTERNATE RESPONSE (204 No Content):
[Empty body, just 204 status code]

CODE: lib/services/api_service.dart → deleteLahan()
CALLED FROM: lib/widgets/cards/lahan_card.dart → _deleteLahan()
```

---

## Error Response Format

### Invalid Credentials (Login/Register)
```json
{
  "success": false,
  "message": "Invalid credentials",
  "errors": {
    "email": ["Email not found or password incorrect"]
  }
}
HTTP Status: 401
```

### Validation Error (Register)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["Email already registered"],
    "password": ["Password must be at least 8 characters"]
  }
}
HTTP Status: 422
```

### Unauthorized (Missing/Invalid Token)
```json
{
  "success": false,
  "message": "Unauthorized"
}
HTTP Status: 401
```

### Not Found (Get/Update/Delete non-existent lahan)
```json
{
  "success": false,
  "message": "Lahan not found"
}
HTTP Status: 404
```

### Server Error
```json
{
  "success": false,
  "message": "Internal server error"
}
HTTP Status: 500
```

---

## HTTP Header Requirements

### All Authenticated Requests
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### Auto-Injected by ApiService
```dart
// From lib/services/api_service.dart
static Future<Map<String, String>> _getAuthHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(tokenKey); // 'auth_token'

  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
```

All ApiService methods automatically call `_getAuthHeaders()` to include token.

---

## Database Model Reference

### User Model (Backend)
```
id (int, primary key)
name (string)
email (string, unique)
phone (string)
password (string, hashed)
created_at (timestamp)
updated_at (timestamp)
```

### Lahan Model (Backend)
```
id (int, primary key)
user_id (int, foreign key → users)
nama_lahan (string)
lokasi (string)
luas_lahan (float/int)
deskripsi (text)
created_at (timestamp)
updated_at (timestamp)
```

### Laravel Model Relationships
```php
// User model
public function lahans() {
  return $this->hasMany(Lahan::class);
}

// Lahan model
public function user() {
  return $this->belongsTo(User::class);
}
```

---

## Implementation Notes

### Token Storage (Flutter Side)
```dart
// After successful login/register
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', response['token']);
```

### Token Usage (Flutter Side)
```dart
// Automatically handled by ApiService._getAuthHeaders()
final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('auth_token');
// Token added to every authenticated request
```

### Token Clearing (On Logout)
```dart
// Should be called on logout
final prefs = await SharedPreferences.getInstance();
await prefs.remove('auth_token');
```

---

## Common Issues & Fixes

### Issue: "Unauthorized" on all CRUD requests
**Cause**: Token not being sent or invalid
**Fix**:
1. Verify token saved to SharedPreferences after login
2. Verify backend validates Bearer token correctly
3. Check token format: `Authorization: Bearer <token>`

### Issue: CORS Error
**Cause**: Backend not allowing Flutter app origin
**Fix in Laravel** (`config/cors.php`):
```php
'allowed_origins' => ['*'], // Allow all origins for dev
'allowed_origins_patterns' => ['*'],
```

### Issue: 422 Validation Error on Create/Update
**Cause**: Request body doesn't match expected format
**Fix**:
1. Check field names match backend expectations
2. Verify data types (string, int, float)
3. Ensure all required fields present

### Issue: 500 Internal Server Error
**Cause**: Backend error
**Fix**:
1. Check backend logs
2. Verify database connection
3. Check if middleware properly handling Bearer token

---

## Testing Tools

### cURL Examples
```bash
# Test Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Test Get Lahans (with token)
curl -X GET http://localhost:8000/api/lahans \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# Test Create Lahan
curl -X POST http://localhost:8000/api/lahans \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{"nama_lahan":"Test","lokasi":"Jl. Test","luas_lahan":100,"deskripsi":"Test"}'
```

### Postman Collection
Can be imported from `Backend-Cabaiku/docs/postman/`

---

## Version Control
- **Flutter App Version**: Based on pubspec.yaml
- **API Version**: Based on backend routes (api.php)
- **Last Updated**: This session
- **Tested Against**: Laravel 11+ (assumed)

---

**This document serves as the contract between Flutter frontend and Laravel backend.**

If backend response format differs, update accordingly and communicate changes.
