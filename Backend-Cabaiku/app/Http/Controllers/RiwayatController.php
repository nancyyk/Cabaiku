<?php

namespace App\Http\Controllers;

use App\Models\Deteksi;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class RiwayatController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        $totalDeteksi        = Deteksi::where('user_id', $user->id)->count();
        $tanamanSehat        = Deteksi::where('user_id', $user->id)->where('hasil', 'Sehat')->count();
        $terdeteksiPenyakit  = Deteksi::where('user_id', $user->id)->where('hasil', '!=', 'Sehat')->count();
        $riwayats            = Deteksi::where('user_id', $user->id)->with('lahan')->latest()->paginate(10);

        return view('pages.riwayat', compact('totalDeteksi', 'tanamanSehat', 'terdeteksiPenyakit', 'riwayats'));
    }

    public function destroy($id)
    {
        $deteksi = Deteksi::where('id', $id)->where('user_id', Auth::id())->firstOrFail();

        if ($deteksi->gambar && Storage::disk('public')->exists($deteksi->gambar)) {
            Storage::disk('public')->delete($deteksi->gambar);
        }

        $deteksi->delete();
        return redirect()->route('riwayat')->with('success', 'Riwayat berhasil dihapus!');
    }
}
