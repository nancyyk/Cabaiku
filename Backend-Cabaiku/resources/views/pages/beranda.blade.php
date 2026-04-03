@extends('layouts.app')
@section('title','Beranda')
@section('styles')
<style>
.hero{background:linear-gradient(135deg,#922B21 0%,#C0392B 55%,#E74C3C 100%);border-radius:20px;padding:32px 28px;color:#fff;position:relative;overflow:hidden;margin-bottom:24px;}
.hero::before{content:'🌶️';position:absolute;right:16px;bottom:-14px;font-size:7rem;opacity:.12;transform:rotate(-15deg);pointer-events:none;}
.hero-greeting{font-size:.82rem;color:rgba(255,255,255,.72);margin-bottom:4px;font-weight:500;}
.hero-title{font-family:var(--font-display);font-size:1.85rem;font-weight:700;margin-bottom:6px;line-height:1.2;}
.hero-sub{font-size:.875rem;color:rgba(255,255,255,.8);margin-bottom:20px;}
.btn-hero{display:inline-flex;align-items:center;gap:8px;background:#fff;color:var(--primary);padding:10px 20px;border-radius:10px;font-weight:700;font-size:.875rem;text-decoration:none;transition:all .2s;box-shadow:0 4px 12px rgba(0,0,0,.15);}
.btn-hero:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(0,0,0,.2);}
/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:28px;}
.stat-card{background:var(--surface);border-radius:var(--radius);padding:16px;border:1px solid var(--border);display:flex;flex-direction:column;gap:10px;box-shadow:var(--shadow-sm);transition:all .2s;}
.stat-card:hover{transform:translateY(-2px);box-shadow:var(--shadow);}
.stat-icon{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;}
.si-blue{background:#EFF6FF;color:#2563EB;} .si-green{background:#ECFDF5;color:#059669;} .si-orange{background:#FFFBEB;color:#D97706;}
.stat-num{font-size:1.6rem;font-weight:800;color:var(--text);line-height:1;}
.stat-label{font-size:.72rem;color:var(--text-muted);font-weight:500;}
/* Section */
.sec-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;}
.sec-title{font-family:var(--font-display);font-size:1.2rem;font-weight:700;}
.sec-link{font-size:.8rem;color:var(--primary);font-weight:600;text-decoration:none;}
.sec-link:hover{text-decoration:underline;}
/* Lahan */
.lahan-empty{background:var(--surface);border-radius:var(--radius);border:1.5px dashed var(--border);padding:40px 20px;text-align:center;margin-bottom:28px;}
.lahan-empty-icon{font-size:2.5rem;margin-bottom:12px;opacity:.4;}
.lahan-empty p{color:var(--text-muted);margin-bottom:16px;font-size:.875rem;}
.lahan-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:14px;margin-bottom:28px;}
.lahan-card{background:var(--surface);border-radius:var(--radius);padding:18px;border:1px solid var(--border);box-shadow:var(--shadow-sm);transition:all .2s;position:relative;overflow:hidden;}
.lahan-card:hover{transform:translateY(-2px);box-shadow:var(--shadow);}
.lahan-card::before{content:'';position:absolute;left:0;top:0;bottom:0;width:4px;background:var(--primary);}
.lahan-name{font-weight:700;font-size:.95rem;}
.lahan-loc{font-size:.76rem;color:var(--text-muted);margin-top:2px;display:flex;align-items:center;gap:4px;}
.lahan-footer{display:flex;align-items:center;justify-content:space-between;margin-top:12px;padding-top:12px;border-top:1px solid var(--border);}
.lahan-count{font-size:.78rem;color:var(--text-muted);}
.lahan-count strong{color:var(--text);}
.del-lahan{width:28px;height:28px;border-radius:8px;background:#FEF2F2;border:1px solid #FECACA;display:flex;align-items:center;justify-content:center;color:var(--danger);cursor:pointer;font-size:.8rem;transition:all .2s;}
.del-lahan:hover{background:#FEE2E2;}
/* Quick */
.quick-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:28px;}
.quick-card{background:var(--surface);border-radius:var(--radius);padding:18px;border:1px solid var(--border);display:flex;align-items:center;gap:14px;text-decoration:none;transition:all .2s;box-shadow:var(--shadow-sm);}
.quick-card:hover{transform:translateY(-2px);box-shadow:var(--shadow);border-color:var(--primary-light);}
.quick-icon{width:46px;height:46px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0;}
.qi-red{background:var(--primary-bg);color:var(--primary);} .qi-blue{background:#EFF6FF;color:#2563EB;}
.quick-label{font-weight:700;font-size:.875rem;color:var(--text);margin-bottom:2px;}
.quick-sub{font-size:.75rem;color:var(--text-muted);}
/* Tip */
.tip-card{background:linear-gradient(135deg,#FFFBEB,#FEF3C7);border:1px solid #FDE68A;border-radius:var(--radius);padding:18px 20px;display:flex;align-items:flex-start;gap:14px;margin-bottom:28px;}
.tip-icon{font-size:1.6rem;flex-shrink:0;margin-top:2px;}
.tip-title{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:#92400E;margin-bottom:4px;}
.tip-text{font-size:.875rem;color:#78350F;line-height:1.55;}
/* Artikel */
.artikel-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:16px;margin-bottom:32px;}
.a-card{background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);overflow:hidden;box-shadow:var(--shadow-sm);transition:all .2s;text-decoration:none;display:block;}
.a-card:hover{transform:translateY(-3px);box-shadow:var(--shadow);}
.a-img{width:100%;height:155px;object-fit:cover;}
.a-body{padding:14px 16px;}
.a-meta{display:flex;align-items:center;gap:8px;margin-bottom:8px;}
.a-kat{background:var(--primary-bg);color:var(--primary);font-size:.7rem;font-weight:700;padding:2px 8px;border-radius:20px;}
.a-waktu{font-size:.7rem;color:var(--text-muted);}
.a-judul{font-weight:700;font-size:.875rem;color:var(--text);margin-bottom:4px;line-height:1.35;}
.a-ring{font-size:.76rem;color:var(--text-muted);line-height:1.5;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;}
@media(max-width:600px){.stats-grid{gap:8px;}.stat-num{font-size:1.3rem;}.hero-title{font-size:1.5rem;}.artikel-grid{grid-template-columns:1fr;}}
</style>
@endsection
@section('content')
<div class="hero">
    <div class="hero-greeting">👋 Halo,</div>
    <h1 class="hero-title">Selamat Datang,<br>{{ auth()->user()->name }}!</h1>
    <p class="hero-sub">Mari pantau & jaga kesehatan tanaman cabai Anda</p>
    <a href="{{ route('deteksi') }}" class="btn-hero"><i class="fa-solid fa-camera"></i> Deteksi Penyakit Sekarang</a>
</div>

<div class="stats-grid">
    <div class="stat-card"><div class="stat-icon si-blue"><i class="fa-solid fa-camera"></i></div><div><div class="stat-num">{{ $totalDeteksi }}</div><div class="stat-label">Total Deteksi</div></div></div>
    <div class="stat-card"><div class="stat-icon si-green"><i class="fa-solid fa-circle-check"></i></div><div><div class="stat-num">{{ $tanamanSehat }}</div><div class="stat-label">Tanaman Sehat</div></div></div>
    <div class="stat-card"><div class="stat-icon si-orange"><i class="fa-solid fa-circle-exclamation"></i></div><div><div class="stat-num">{{ $perluPerhatian }}</div><div class="stat-label">Perlu Perhatian</div></div></div>
</div>

<div class="sec-header">
    <span class="sec-title">🌿 Lahan Saya</span>
    <button class="btn btn-primary btn-sm" onclick="openModal('m-lahan')"><i class="fa-solid fa-plus"></i> Tambah Lahan</button>
</div>

@if($lahans->isEmpty())
<div class="lahan-empty">
    <div class="lahan-empty-icon">📍</div>
    <p>Belum ada lahan terdaftar.<br>Tambahkan lahan pertama Anda!</p>
    <button class="btn btn-primary" onclick="openModal('m-lahan')"><i class="fa-solid fa-plus"></i> Tambah Lahan Pertama</button>
</div>
@else
<div class="lahan-grid">
    @foreach($lahans as $lahan)
    <div class="lahan-card">
        <div class="lahan-name">{{ $lahan->nama_lahan }}</div>
        <div class="lahan-loc"><i class="fa-solid fa-location-dot"></i> {{ $lahan->lokasi }}</div>
        @if($lahan->luas)<div style="font-size:.74rem;color:var(--text-muted);margin-top:4px;"><i class="fa-solid fa-expand"></i> {{ $lahan->luas }} Ha</div>@endif
        <div class="lahan-footer">
            <div class="lahan-count"><strong>{{ $lahan->deteksis_count }}</strong> deteksi</div>
            <form method="POST" action="{{ route('lahan.destroy',$lahan->id) }}" onsubmit="return confirm('Hapus lahan ini?')">
                @csrf @method('DELETE')
                <button type="submit" class="del-lahan"><i class="fa-solid fa-trash"></i></button>
            </form>
        </div>
    </div>
    @endforeach
</div>
@endif

<div class="quick-grid">
    <a href="{{ route('deteksi') }}" class="quick-card">
        <div class="quick-icon qi-red"><i class="fa-solid fa-camera"></i></div>
        <div><div class="quick-label">Deteksi Penyakit</div><div class="quick-sub">Scan tanaman cabai Anda</div></div>
    </a>
    <a href="{{ route('tips') }}" class="quick-card">
        <div class="quick-icon qi-blue"><i class="fa-solid fa-book-open"></i></div>
        <div><div class="quick-label">Tips Perawatan</div><div class="quick-sub">Artikel & panduan lengkap</div></div>
    </a>
</div>

<div class="tip-card">
    <div class="tip-icon">💡</div>
    <div>
        <div class="tip-title">Tips Hari Ini untuk Merawat Tanaman Cabai</div>
        <div class="tip-text">{{ $tipHariIni }}</div>
    </div>
</div>

<div class="sec-header">
    <span class="sec-title">📰 Artikel Terbaru</span>
    <a href="{{ route('tips') }}" class="sec-link">Lihat Semua →</a>
</div>
<div class="artikel-grid">
    @foreach($artikelTerbaru as $ar)
    <a href="{{ route('tips.show',$ar->id) }}" class="a-card">
        <img src="{{ $ar->gambar ?? 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=500' }}" alt="{{ $ar->judul }}" class="a-img">
        <div class="a-body">
            <div class="a-meta"><span class="a-kat">{{ $ar->kategori }}</span><span class="a-waktu"><i class="fa-regular fa-clock"></i> {{ $ar->waktu_baca }} mnt</span></div>
            <div class="a-judul">{{ $ar->judul }}</div>
            <div class="a-ring">{{ $ar->ringkasan }}</div>
        </div>
    </a>
    @endforeach
</div>

<!-- Modal Tambah Lahan -->
<div class="modal-overlay" id="m-lahan">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Tambah Lahan Baru</span>
            <button class="modal-close" onclick="closeModal('m-lahan')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form method="POST" action="{{ route('lahan.store') }}">
            @csrf
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Nama Lahan <span style="color:#EF4444">*</span></label>
                    <input type="text" name="nama_lahan" class="form-control @error('nama_lahan') is-invalid @enderror" placeholder="cth: Lahan Utama Blok A" value="{{ old('nama_lahan') }}" required>
                    @error('nama_lahan')<span class="invalid-feedback">{{ $message }}</span>@enderror
                </div>
                <div class="form-group">
                    <label class="form-label">Lokasi <span style="color:#EF4444">*</span></label>
                    <input type="text" name="lokasi" class="form-control @error('lokasi') is-invalid @enderror" placeholder="cth: Brebes, Jawa Tengah" value="{{ old('lokasi') }}" required>
                    @error('lokasi')<span class="invalid-feedback">{{ $message }}</span>@enderror
                </div>
                <div class="form-group">
                    <label class="form-label">Luas Lahan (Ha)</label>
                    <input type="number" name="luas" class="form-control" step="0.01" min="0" placeholder="cth: 0.5" value="{{ old('luas') }}">
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label class="form-label">Keterangan</label>
                    <textarea name="keterangan" class="form-control" placeholder="Keterangan tambahan...">{{ old('keterangan') }}</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('m-lahan')">Batal</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Simpan</button>
            </div>
        </form>
    </div>
</div>
@endsection
@section('scripts')
<script>
function openModal(id){document.getElementById(id).classList.add('active');document.body.style.overflow='hidden';}
function closeModal(id){document.getElementById(id).classList.remove('active');document.body.style.overflow='';}
document.querySelectorAll('.modal-overlay').forEach(o=>o.addEventListener('click',function(e){if(e.target===this)closeModal(this.id);}));
@if($errors->has('nama_lahan')||$errors->has('lokasi')) openModal('m-lahan'); @endif
</script>
@endsection
