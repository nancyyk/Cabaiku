<?php

namespace App\Http\Controllers;

use App\Models\Artikel;
use App\Models\Deteksi;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        $totalDeteksi    = Deteksi::where('user_id', $user->id)->count();
        $tanamanSehat    = Deteksi::where('user_id', $user->id)->where('hasil', 'Sehat')->count();
        $perluPerhatian  = Deteksi::where('user_id', $user->id)->where('hasil', '!=', 'Sehat')->count();
        $lahans          = $user->lahans()->withCount('deteksis')->latest()->get();
        $artikelTerbaru  = Artikel::published()->latest('published_at')->take(4)->get();

        $tips = [
            'Siram tanaman cabai secukupnya, jangan sampai tanah terlalu basah atau terlalu kering.',
            'Berikan pupuk NPK setiap 2 minggu sekali untuk pertumbuhan optimal.',
            'Periksa bagian bawah daun secara rutin untuk mendeteksi hama sejak dini.',
            'Pangkas cabang yang tidak produktif agar nutrisi fokus ke buah.',
            'Semprotkan pestisida organik saat pagi hari untuk efektivitas maksimal.',
            'Pasang mulsa plastik untuk menjaga kelembaban tanah dan mencegah gulma.',
            'Lakukan rotasi tanaman setiap musim untuk memutus siklus hama.',
        ];
        $tipHariIni = $tips[date('N') % count($tips)];

        return view('pages.beranda', compact(
            'totalDeteksi', 'tanamanSehat', 'perluPerhatian',
            'lahans', 'artikelTerbaru', 'tipHariIni'
        ));
    }
}
