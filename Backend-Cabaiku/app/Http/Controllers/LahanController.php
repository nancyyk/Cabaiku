<?php

namespace App\Http\Controllers;

use App\Models\Lahan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LahanController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'nama_lahan' => 'required|string|max:255',
            'lokasi'     => 'required|string|max:255',
            'luas'       => 'nullable|numeric|min:0',
            'keterangan' => 'nullable|string|max:500',
        ], [
            'nama_lahan.required' => 'Nama lahan wajib diisi',
            'lokasi.required'     => 'Lokasi lahan wajib diisi',
        ]);

        Lahan::create([
            'user_id'    => Auth::id(),
            'nama_lahan' => $request->nama_lahan,
            'lokasi'     => $request->lokasi,
            'luas'       => $request->luas,
            'keterangan' => $request->keterangan,
        ]);

        return redirect()->route('beranda')->with('success', 'Lahan berhasil ditambahkan!');
    }

    public function destroy($id)
    {
        Lahan::where('id', $id)->where('user_id', Auth::id())->firstOrFail()->delete();
        return redirect()->route('beranda')->with('success', 'Lahan berhasil dihapus!');
    }
}
