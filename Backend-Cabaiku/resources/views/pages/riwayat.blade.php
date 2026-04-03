@extends('layouts.app')
@section('title','Riwayat Deteksi')
@section('styles')
<style>
.stat-row{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:28px;}
.sb{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:18px 14px;text-align:center;box-shadow:var(--shadow-sm);}
.sb-num{font-size:2rem;font-weight:800;color:var(--text);line-height:1;margin-bottom:4px;}
.sb-num.g{color:var(--success);} .sb-num.r{color:var(--danger);}
.sb-label{font-size:.72rem;color:var(--text-muted);font-weight:500;}
.rlist{display:flex;flex-direction:column;gap:10px;margin-bottom:28px;}
.ritem{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:16px 18px;display:flex;align-items:center;gap:14px;box-shadow:var(--shadow-sm);transition:all .2s;}
.ritem:hover{box-shadow:var(--shadow);border-color:#D1D5DB;}
.ricon{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;}
.ricon.sehat{background:#ECFDF5;} .ricon.sakit{background:#FEF3C7;} .ricon.berat{background:#FEF2F2;}
.rcontent{flex:1;min-width:0;}
.rhasil{font-weight:700;font-size:.9rem;color:var(--text);margin-bottom:4px;}
.rmeta{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
.rmeta-item{font-size:.73rem;color:var(--text-muted);display:flex;align-items:center;gap:4px;}
.del-btn{width:34px;height:34px;border-radius:10px;background:#FEF2F2;border:1px solid #FECACA;display:flex;align-items:center;justify-content:center;color:var(--danger);cursor:pointer;font-size:.85rem;transition:all .2s;flex-shrink:0;}
.del-btn:hover{background:#FEE2E2;transform:scale(1.05);}
.empty{text-align:center;padding:60px 20px;}
</style>
@endsection
@section('content')
<div class="page-header"><h1>🗂️ Riwayat Deteksi</h1><p>Lihat semua hasil deteksi penyakit tanaman cabai Anda</p></div>
<div class="stat-row">
    <div class="sb"><div class="sb-num">{{ $totalDeteksi }}</div><div class="sb-label">Total Deteksi</div></div>
    <div class="sb"><div class="sb-num g"><i class="fa-solid fa-circle-check" style="font-size:1.2rem;"></i> {{ $tanamanSehat }}</div><div class="sb-label">Tanaman Sehat</div></div>
    <div class="sb"><div class="sb-num r"><i class="fa-solid fa-circle-exclamation" style="font-size:1.2rem;"></i> {{ $terdeteksiPenyakit }}</div><div class="sb-label">Terdeteksi Penyakit</div></div>
</div>
@if($riwayats->isEmpty())
<div class="empty"><div style="font-size:3rem;margin-bottom:16px;opacity:.4;">📷</div><h3 style="font-weight:700;margin-bottom:8px;">Belum Ada Riwayat</h3><p style="color:var(--text-muted);margin-bottom:20px;">Anda belum melakukan deteksi penyakit.</p><a href="{{ route('deteksi') }}" class="btn btn-primary"><i class="fa-solid fa-camera"></i> Mulai Deteksi</a></div>
@else
<div class="rlist">
    @foreach($riwayats as $r)
    @php $isS=$r->hasil==='Sehat'; $isB=$r->tingkat_keparahan==='Berat'; $ic=$isS?'sehat':($isB?'berat':'sakit'); $em=$isS?'✅':($isB?'🚨':'⚠️'); @endphp
    <div class="ritem">
        <div class="ricon {{ $ic }}">{{ $em }}</div>
        <div class="rcontent">
            <div class="rhasil">{{ $r->hasil }}</div>
            <div class="rmeta">
                <span class="badge badge-{{ strtolower($r->tingkat_keparahan) }}">{{ $r->tingkat_keparahan }}</span>
                <div class="rmeta-item"><i class="fa-solid fa-bullseye"></i> {{ $r->akurasi }}%</div>
                <div class="rmeta-item"><i class="fa-regular fa-calendar"></i> {{ $r->created_at->translatedFormat('d M Y') }}</div>
                <div class="rmeta-item"><i class="fa-regular fa-clock"></i> {{ $r->created_at->format('H:i') }}</div>
                @if($r->lahan)<div class="rmeta-item"><i class="fa-solid fa-location-dot"></i> {{ $r->lahan->nama_lahan }}</div>@endif
            </div>
        </div>
        <form method="POST" action="{{ route('riwayat.destroy',$r->id) }}" onsubmit="return confirm('Hapus riwayat ini?')">
            @csrf @method('DELETE')
            <button type="submit" class="del-btn"><i class="fa-solid fa-trash"></i></button>
        </form>
    </div>
    @endforeach
</div>
@if($riwayats->hasPages())
<div style="display:flex;justify-content:center;gap:6px;margin-bottom:32px;">
    @if(!$riwayats->onFirstPage())<a href="{{ $riwayats->previousPageUrl() }}" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-left"></i></a>@endif
    <span style="display:flex;align-items:center;font-size:.875rem;color:var(--text-muted);padding:0 12px;">Hal {{ $riwayats->currentPage() }} / {{ $riwayats->lastPage() }}</span>
    @if($riwayats->hasMorePages())<a href="{{ $riwayats->nextPageUrl() }}" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-right"></i></a>@endif
</div>
@endif
@endif
@endsection
