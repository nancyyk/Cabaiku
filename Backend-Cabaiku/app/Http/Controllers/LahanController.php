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

    public function update(Request $request, $id)
    {
        $lahan = Lahan::where('id', $id)->where('user_id', Auth::id())->firstOrFail();

        $validated = $request->validateWithBag('updateLahan', [
            'nama_lahan' => 'nullable|string|max:255',
            'lokasi'     => 'nullable|string|max:255',
            'luas'       => 'nullable|numeric|min:0',
            'keterangan' => 'nullable|string|max:500',
        ]);

        $changes = [];

        foreach (['nama_lahan', 'lokasi', 'luas', 'keterangan'] as $field) {
            $newValue = $validated[$field] ?? null;
            $currentValue = $lahan->{$field};

            if (in_array($field, ['nama_lahan', 'lokasi'], true) && $newValue === null) {
                continue;
            }

            if ($field === 'luas') {
                $newComparable = $newValue !== null ? (float) $newValue : null;
                $currentComparable = $currentValue !== null ? (float) $currentValue : null;
            } else {
                $newComparable = $newValue !== null ? trim((string) $newValue) : null;
                $currentComparable = $currentValue !== null ? trim((string) $currentValue) : null;
            }

            if ($newComparable !== $currentComparable) {
                $changes[$field] = $newValue;
            }
        }

        if (empty($changes)) {
            return redirect()->route('beranda')->with('info', 'Tidak ada yang ter-update.');
        }

        $lahan->update($changes);

        return redirect()->route('beranda')->with('success', 'Lahan berhasil diperbarui!');
    }
}
