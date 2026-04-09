@extends('admin.layouts.app')
@section('title', 'Dashboard Admin')

@section('content')
<div class="grid">
    <div class="stat"><div>Total User Terdaftar</div><div class="n">{{ $totalUsers }}</div></div>
    <div class="stat"><div>Total Artikel</div><div class="n">{{ $totalArticles }}</div></div>
</div>

<div class="card">
    <div class="title">Daftar User & Waktu Daftar</div>
    <table>
        <thead>
            <tr>
                <th>Nama</th>
                <th>Email</th>
                <th>Terdaftar Pada</th>
            </tr>
        </thead>
        <tbody>
            @forelse($users as $user)
                <tr>
                    <td>{{ $user->name }}</td>
                    <td>{{ $user->email }}</td>
                    <td>{{ $user->created_at->format('d M Y H:i') }}</td>
                </tr>
            @empty
                <tr><td colspan="3">Belum ada user terdaftar.</td></tr>
            @endforelse
        </tbody>
    </table>
    <div class="pagination">{{ $users->links() }}</div>
</div>
@endsection
