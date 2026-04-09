@extends('admin.layouts.app')
@section('title', 'Tambah Artikel')

@section('content')
<div class="card">
    <div class="title">Tambah Artikel</div>
    <form method="POST" action="{{ route('admin.artikels.store') }}">
        @csrf
        @include('admin.artikels.partials.form', ['artikel' => null])
        <button type="submit" class="btn btn-dark">Simpan Artikel</button>
    </form>
</div>
@endsection
