{{-- FILE: resources/views/pages/deteksi-hasil.blade.php --}}
@extends('layouts.app')
@section('title','Hasil Deteksi')
@section('styles')
<style>
@php $isSehat=$deteksi->hasil==='Sehat'; $isBerat=$deteksi->tingkat_keparahan==='Berat'; @endphp
.res-header{border-radius:var(--radius-lg);padding:28px 24px;margin-bottom:20px;display:flex;align-items:center;gap:20px;}
.res-header.sehat{background:linear-gradient(135deg,#ECFDF5,#D1FAE5);border:1px solid #6EE7B7;}
.res-header.sakit{background:linear-gradient(135deg,#FEF3C7,#FDE68A);border:1px solid #FCD34D;}
.res-header.berat{background:linear-gradient(135deg,#FEF2F2,#FECACA);border:1px solid #FCA5A5;}
.res-icon{font-size:3.5rem;flex-shrink:0;}
.res-label{font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;margin-bottom:4px;}
.res-nama{font-family:var(--font-display);font-size:1.55rem;font-weight:700;line-height:1.2;margin-bottom:8px;}
.res-nama.sehat{color:#065F46;} .res-nama.sakit{color:#92400E;} .res-nama.berat{color:#7F1D1D;}
.acc-chip{display:inline-flex;align-items:center;gap:8px;background:rgba(0,0,0,.06);padding:6px 14px;border-radius:20px;font-size:.83rem;font-weight:700;}
.info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px;}
.info-item{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:14px 16px;}
.info-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);margin-bottom:4px;}
.info-val{font-size:.9rem;font-weight:600;color:var(--text);}
.rek-box{background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);padding:20px;margin-bottom:20px;}
.rek-title{font-weight:700;font-size:1rem;margin-bottom:12px;display:flex;align-items:center;gap:8px;}
.rek-text{font-size:.875rem;color:var(--text);line-height:1.7;}
.hasil-img{width:100%;max-height:240px;object-fit:cover;border-radius:var(--radius);border:1px solid var(--border);margin-bottom:20px;}
.act-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:32px;}
</style>
@endsection
@section('content')
@php $isSehat=$deteksi->hasil==='Sehat'; $isBerat=$deteksi->tingkat_keparahan==='Berat'; $hc=$isSehat?'sehat':($isBerat?'berat':'sakit'); $emoji=$isSehat?'✅':($isBerat?'🚨':'⚠️'); @endphp
<div style="display:flex;align-items:center;gap:12px;margin-bottom:24px;">
    <a href="{{ route('deteksi') }}" class="btn btn-secondary btn-sm"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="page-header" style="margin-bottom:0;"><h1>Hasil Deteksi</h1><p>{{ $deteksi->created_at->translatedFormat('d F Y, H:i') }}</p></div>
</div>
@if($deteksi->gambar && \Illuminate\Support\Facades\Storage::disk('public')->exists($deteksi->gambar))
<img src="{{ asset('storage/'.$deteksi->gambar) }}" alt="Foto Deteksi" class="hasil-img">
@else
<div style="background:var(--surface3);border-radius:var(--radius);height:140px;display:flex;align-items:center;justify-content:center;color:var(--text-muted);margin-bottom:20px;"><i class="fa-solid fa-image" style="font-size:2rem;"></i></div>
@endif
<div class="res-header {{ $hc }}">
    <div class="res-icon">{{ $emoji }}</div>
    <div style="flex:1;">
        <div class="res-label" style="color:{{ $isSehat?'#065F46':($isBerat?'#7F1D1D':'#92400E') }}">Hasil Deteksi</div>
        <div class="res-nama {{ $hc }}">{{ $deteksi->hasil }}</div>
        @if($deteksi->penyakit)<div style="font-size:.78rem;color:{{ $isBerat?'#991B1B':'#92400E' }};font-style:italic;margin-bottom:8px;">{{ $deteksi->penyakit }}</div>@endif
        <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
            <div class="acc-chip" style="color:{{ $isSehat?'#065F46':($isBerat?'#7F1D1D':'#92400E') }}"><i class="fa-solid fa-bullseye"></i> {{ $deteksi->akurasi }}% Akurasi</div>
            <span class="badge badge-{{ strtolower($deteksi->tingkat_keparahan) }}">{{ $deteksi->tingkat_keparahan }}</span>
        </div>
    </div>
</div>
<div class="info-grid">
    <div class="info-item"><div class="info-label">Lahan</div><div class="info-val">{{ $deteksi->lahan->nama_lahan ?? '-' }}</div></div>
    <div class="info-item"><div class="info-label">Tanggal</div><div class="info-val">{{ $deteksi->created_at->translatedFormat('d M Y') }}</div></div>
    <div class="info-item"><div class="info-label">Waktu</div><div class="info-val">{{ $deteksi->created_at->format('H:i') }} WIB</div></div>
    <div class="info-item"><div class="info-label">Keparahan</div><div class="info-val"><span class="badge badge-{{ strtolower($deteksi->tingkat_keparahan) }}">{{ $deteksi->tingkat_keparahan }}</span></div></div>
</div>
@if($deteksi->catatan)<div class="card" style="margin-bottom:20px;"><div class="card-body"><div style="font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);margin-bottom:6px;">Catatan Anda</div><div style="font-size:.875rem;line-height:1.6;">{{ $deteksi->catatan }}</div></div></div>@endif
<div class="rek-box"><div class="rek-title"><span style="font-size:1.2rem;">💊</span> Rekomendasi Penanganan</div><div class="rek-text">{{ $deteksi->rekomendasi }}</div></div>
<div class="act-row">
    <a href="{{ route('deteksi') }}" class="btn btn-outline"><i class="fa-solid fa-camera"></i> Deteksi Lagi</a>
    <a href="{{ route('riwayat') }}" class="btn btn-secondary"><i class="fa-solid fa-clock-rotate-left"></i> Lihat Riwayat</a>
</div>
@endsection
