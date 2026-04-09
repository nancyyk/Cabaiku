@extends('admin.layouts.app')
@section('title', 'Edit Artikel')

@section('content')
<div class="card">
    <div class="title">Edit Artikel</div>
    <form method="POST" action="{{ route('admin.artikels.update', $artikel->id) }}">
        @csrf
        @method('PUT')
        @include('admin.artikels.partials.form', ['artikel' => $artikel])
        <button type="submit" class="btn btn-dark">Update Artikel</button>
    </form>
</div>
@endsection
