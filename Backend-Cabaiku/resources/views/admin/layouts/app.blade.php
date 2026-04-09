<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Admin Cabaiku')</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root{--primary:#1f2937;--accent:#0ea5e9;--bg:#f3f4f6;--surface:#ffffff;--border:#e5e7eb;--text:#111827;--muted:#6b7280;--danger:#b91c1c;}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:Segoe UI,Tahoma,sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1150px;margin:0 auto;padding:24px}
        .nav{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:14px 18px;display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
        .brand{font-weight:800;text-decoration:none;color:var(--text)}
        .menu{display:flex;gap:10px;align-items:center}
        .menu a{text-decoration:none;color:var(--text);padding:8px 12px;border-radius:8px}
        .menu a.active,.menu a:hover{background:#e0f2fe;color:#0369a1}
        .btn{border:none;border-radius:8px;padding:8px 12px;cursor:pointer;font-weight:600}
        .btn-dark{background:#111827;color:#fff}
        .btn-danger{background:#fee2e2;color:var(--danger);border:1px solid #fecaca}
        .card{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:18px}
        .title{font-size:1.2rem;font-weight:800;margin-bottom:12px}
        .alert{padding:10px 12px;border-radius:8px;margin-bottom:14px;font-size:.9rem}
        .alert-success{background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46}
        .alert-error{background:#fef2f2;border:1px solid #fecaca;color:#991b1b}
        table{width:100%;border-collapse:collapse}
        th,td{text-align:left;padding:10px;border-bottom:1px solid var(--border);font-size:.9rem}
        th{color:var(--muted);font-size:.8rem;text-transform:uppercase;letter-spacing:.04em}
        .grid{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-bottom:16px}
        .stat{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:14px}
        .stat .n{font-size:1.6rem;font-weight:800}
        .field{margin-bottom:12px}
        .field label{display:block;font-size:.85rem;font-weight:600;margin-bottom:5px}
        .field input,.field textarea,.field select{width:100%;border:1px solid #d1d5db;border-radius:8px;padding:10px;font:inherit}
        .field textarea{min-height:130px;resize:vertical}
        .actions{display:flex;gap:8px;align-items:center}
        .pagination{margin-top:14px}
        .pagination svg{width:14px;height:14px}
        @media(max-width:760px){.wrap{padding:12px}.grid{grid-template-columns:1fr}.nav{flex-direction:column;align-items:flex-start;gap:10px}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="nav">
        <a href="{{ route('admin.dashboard') }}" class="brand">Admin Cabaiku</a>
        <div class="menu">
            <a href="{{ route('admin.dashboard') }}" class="{{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">Dashboard</a>
            <a href="{{ route('admin.artikels.index') }}" class="{{ request()->routeIs('admin.artikels.*') ? 'active' : '' }}">Artikel</a>
            <form method="POST" action="{{ route('admin.logout') }}">@csrf<button type="submit" class="btn btn-danger">Logout</button></form>
        </div>
    </div>

    @if(session('success'))<div class="alert alert-success">{{ session('success') }}</div>@endif
    @if($errors->any())<div class="alert alert-error">{{ $errors->first() }}</div>@endif

    @yield('content')
</div>
</body>
</html>
