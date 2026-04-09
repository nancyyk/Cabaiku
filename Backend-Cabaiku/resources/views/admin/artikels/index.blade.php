@extends('admin.layouts.app')
@section('title', 'Manajemen Artikel')

@section('content')
<div class="card">
    <div class="actions" style="justify-content:space-between;margin-bottom:12px;">
        <div class="title" style="margin-bottom:0">Daftar Artikel</div>
        <a href="{{ route('admin.artikels.create') }}" class="btn btn-dark" style="text-decoration:none">+ Tambah Artikel</a>
    </div>

    <table>
        <thead>
        <tr>
            <th>Judul</th>
            <th>Kategori</th>
            <th>Status</th>
            <th>Dipublish</th>
            <th>Aksi</th>
        </tr>
        </thead>
        <tbody>
        @forelse($artikels as $artikel)
            <tr>
                <td>{{ $artikel->judul }}</td>
                <td>{{ $artikel->kategori }}</td>
                <td>{{ $artikel->is_published ? 'Publish' : 'Draft' }}</td>
                <td>{{ optional($artikel->published_at)->format('d M Y H:i') ?? '-' }}</td>
                <td>
                    <div class="actions">
                        <a href="{{ route('admin.artikels.edit', $artikel->id) }}" class="btn" style="text-decoration:none">Edit</a>
                        <form method="POST" action="{{ route('admin.artikels.destroy', $artikel->id) }}" onsubmit="return confirm('Hapus artikel ini?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-danger">Hapus</button>
                        </form>
                    </div>
                </td>
            </tr>
        @empty
            <tr><td colspan="5">Belum ada artikel.</td></tr>
        @endforelse
        </tbody>
    </table>

    <div class="pagination">{{ $artikels->links() }}</div>
</div>
@endsection
