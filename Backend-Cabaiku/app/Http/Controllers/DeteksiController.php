<?php

namespace App\Http\Controllers;

use App\Models\Deteksi;
use App\Models\Lahan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class DeteksiController extends Controller
{
    private array $penyakitList = [
        ['hasil' => 'Sehat',                    'penyakit' => null,                      'tingkat' => 'Ringan', 'akurasi' => [90, 98]],
        ['hasil' => 'Bercak Daun (Leaf Spot)',  'penyakit' => 'Cercospora capsici',      'tingkat' => 'Sedang', 'akurasi' => [80, 92]],
        ['hasil' => 'Keriting Daun (Leaf Curl)','penyakit' => 'Virus CMV',               'tingkat' => 'Sedang', 'akurasi' => [78, 90]],
        ['hasil' => 'Antraknosa',               'penyakit' => 'Colletotrichum acutatum', 'tingkat' => 'Berat',  'akurasi' => [85, 95]],
        ['hasil' => 'Layu Fusarium',            'penyakit' => 'Fusarium oxysporum',      'tingkat' => 'Berat',  'akurasi' => [82, 94]],
        ['hasil' => 'Bercak Bakteri',           'penyakit' => 'Xanthomonas campestris',  'tingkat' => 'Sedang', 'akurasi' => [76, 88]],
    ];

    private array $rekomendasiList = [
        'Sehat'                     => 'Tanaman Anda dalam kondisi sehat! Pertahankan perawatan rutin: penyiraman teratur, pemupukan setiap 2 minggu, dan pemeriksaan berkala.',
        'Bercak Daun (Leaf Spot)'  => 'Aplikasikan fungisida berbahan aktif mankozeb atau klorotalonil. Kurangi kelembaban dengan mengatur jarak tanam. Buang dan musnahkan daun yang terinfeksi.',
        'Keriting Daun (Leaf Curl)' => 'Kendalikan kutu daun (vektor virus) dengan insektisida sistemik. Cabut dan musnahkan tanaman yang terinfeksi parah. Gunakan mulsa untuk mencegah penyebaran.',
        'Antraknosa'                => 'Semprotkan fungisida berbahan aktif azoksistrobin atau mankozeb. Hindari luka mekanis saat panen. Perbaiki drainase lahan dan kurangi kelembaban.',
        'Layu Fusarium'             => 'Tidak ada obat efektif untuk tanaman terinfeksi parah. Cabut dan musnahkan. Sterilisasi tanah dengan solarisasi atau fumigasi. Gunakan varietas tahan penyakit.',
        'Bercak Bakteri'            => 'Semprot bakterisida berbahan aktif tembaga hidroksida. Hindari penyiraman dari atas. Rotasi tanaman dengan tanaman bukan famili Solanaceae.',
    ];

    public function index()
    {
        $lahans = Auth::user()->lahans()->get();
        return view('pages.deteksi', compact('lahans'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'gambar'   => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',
            'lahan_id' => 'required|exists:lahans,id',
            'catatan'  => 'nullable|string|max:500',
        ], [
            'gambar.required' => 'Gambar wajib diunggah',
            'gambar.image'    => 'File harus berupa gambar',
            'gambar.mimes'    => 'Format gambar: JPG, JPEG, PNG, atau WEBP',
            'gambar.max'      => 'Ukuran gambar maksimal 5MB',
            'lahan_id.required' => 'Pilih lahan terlebih dahulu',
            'lahan_id.exists'   => 'Lahan tidak ditemukan',
        ]);

        // Validasi lahan milik user
        $lahan = Lahan::where('id', $request->lahan_id)
                      ->where('user_id', Auth::id())
                      ->firstOrFail();

        // Simpan gambar
        $gambar  = $request->file('gambar');
        $namaFile = 'deteksi_' . Auth::id() . '_' . time() . '.' . $gambar->getClientOriginalExtension();
        $path = $gambar->storeAs('deteksi', $namaFile, 'public');

        // Simulasi AI detection
        $random      = $this->penyakitList[array_rand($this->penyakitList)];
        $akurasi     = rand($random['akurasi'][0], $random['akurasi'][1]);
        $rekomendasi = $this->rekomendasiList[$random['hasil']] ?? $this->rekomendasiList['Sehat'];

        $deteksi = Deteksi::create([
            'user_id'           => Auth::id(),
            'lahan_id'          => $lahan->id,
            'gambar'            => $path,
            'hasil'             => $random['hasil'],
            'penyakit'          => $random['penyakit'],
            'tingkat_keparahan' => $random['tingkat'],
            'akurasi'           => $akurasi,
            'catatan'           => $request->catatan,
            'rekomendasi'       => $rekomendasi,
        ]);

        return redirect()->route('deteksi.show', $deteksi->id)->with('success', 'Deteksi berhasil!');
    }

    public function show($id)
    {
        $deteksi = Deteksi::where('id', $id)
                          ->where('user_id', Auth::id())
                          ->with('lahan')
                          ->firstOrFail();

        return view('pages.deteksi-hasil', compact('deteksi'));
    }
}
