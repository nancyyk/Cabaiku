<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin</title>
    <style>
        *{box-sizing:border-box} body{margin:0;font-family:Segoe UI,Tahoma,sans-serif;background:linear-gradient(135deg,#111827,#1f2937);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:16px}
        .card{width:100%;max-width:420px;background:#fff;border-radius:14px;padding:22px}
        h1{margin:0 0 6px;font-size:1.4rem} p{margin:0 0 16px;color:#6b7280}
        .field{margin-bottom:12px} label{display:block;font-size:.85rem;font-weight:600;margin-bottom:5px}
        input{width:100%;padding:10px;border:1px solid #d1d5db;border-radius:8px}
        .btn{width:100%;padding:10px;border:none;border-radius:8px;background:#111827;color:#fff;font-weight:700;cursor:pointer}
        .err{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:10px;border-radius:8px;margin-bottom:12px;font-size:.9rem}
    </style>
</head>
<body>
    <form class="card" method="POST" action="{{ route('admin.login.post') }}">
        @csrf
        <h1>Login Admin</h1>
        <p>Panel khusus pengelolaan aplikasi.</p>
        @if($errors->any())<div class="err">{{ $errors->first() }}</div>@endif
        @if(session('success'))<div class="err" style="background:#ecfdf5;border-color:#a7f3d0;color:#065f46">{{ session('success') }}</div>@endif
        <div class="field"><label>Email</label><input type="email" name="email" value="{{ old('email') }}" required></div>
        <div class="field"><label>Password</label><input type="password" name="password" required></div>
        <div class="field"><label><input type="checkbox" name="remember"> Ingat saya</label></div>
        <button type="submit" class="btn">Masuk Admin</button>
    </form>
</body>
</html>
