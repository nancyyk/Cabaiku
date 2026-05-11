const String appName = 'Cabaiku';
const String taglineLogin = 'Aplikasi Pintar untuk Petani Cabai';
const String taglineRegister = 'Bergabung dengan Komunitas Petani Cabai';
const double defaultPadding = 24.0;
const double fieldSpacing = 16.0;

// API Configuration
// Ganti baseUrl sesuai dengan URL backend Anda
// Contoh: http://192.168.1.100:8000/api (untuk development di local network)
// Contoh: http://localhost:8000/api (untuk development mode)
// Contoh: https://api.cabaiku.com/api (untuk production)
// const String apiBaseUrl = 'http://192.168.188.1:8001/api';
const String apiBaseUrl = 'http://10.253.131.98:8001/api';

const int apiTimeout = 30; // seconds
// Local Storage Keys
const String tokenKey = 'auth_token';
const String userKey = 'user_data';
