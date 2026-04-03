<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Deteksi;
use App\Models\Lahan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DeteksiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $deteksis = Deteksi::with('lahan')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(10);

        return response()->json($deteksis);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'lahan_id' => 'required|exists:lahans,id',
            'gambar' => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',
            'hasil' => 'required|string|max:255',
            'penyakit' => 'nullable|string|max:255',
            'tingkat_keparahan' => 'nullable|in:Ringan,Sedang,Berat',
            'akurasi' => 'nullable|integer|min:0|max:100',
            'catatan' => 'nullable|string|max:500',
            'rekomendasi' => 'nullable|string',
        ]);

        $lahan = Lahan::where('id', $validated['lahan_id'])
            ->where('user_id', $request->user()->id)
            ->firstOrFail();

        $file = $request->file('gambar');
        $filename = 'deteksi_' . $request->user()->id . '_' . time() . '.' . $file->getClientOriginalExtension();
        $path = $file->storeAs('deteksi', $filename, 'public');

        $deteksi = Deteksi::create([
            'user_id' => $request->user()->id,
            'lahan_id' => $lahan->id,
            'gambar' => $path,
            'hasil' => $validated['hasil'],
            'penyakit' => $validated['penyakit'] ?? null,
            'tingkat_keparahan' => $validated['tingkat_keparahan'] ?? 'Ringan',
            'akurasi' => $validated['akurasi'] ?? 0,
            'catatan' => $validated['catatan'] ?? null,
            'rekomendasi' => $validated['rekomendasi'] ?? null,
        ]);

        return response()->json($deteksi->load('lahan'), 201);
    }

    public function show(Request $request, Deteksi $deteksi): JsonResponse
    {
        if ($deteksi->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke data deteksi ini.');
        }

        return response()->json($deteksi->load('lahan'));
    }

    public function update(Request $request, Deteksi $deteksi): JsonResponse
    {
        if ($deteksi->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke data deteksi ini.');
        }

        $validated = $request->validate([
            'lahan_id' => 'sometimes|required|exists:lahans,id',
            'gambar' => 'sometimes|image|mimes:jpg,jpeg,png,webp|max:5120',
            'hasil' => 'sometimes|required|string|max:255',
            'penyakit' => 'sometimes|nullable|string|max:255',
            'tingkat_keparahan' => 'sometimes|nullable|in:Ringan,Sedang,Berat',
            'akurasi' => 'sometimes|nullable|integer|min:0|max:100',
            'catatan' => 'sometimes|nullable|string|max:500',
            'rekomendasi' => 'sometimes|nullable|string',
        ]);

        if (isset($validated['lahan_id'])) {
            Lahan::where('id', $validated['lahan_id'])
                ->where('user_id', $request->user()->id)
                ->firstOrFail();
        }

        if ($request->hasFile('gambar')) {
            if ($deteksi->gambar && Storage::disk('public')->exists($deteksi->gambar)) {
                Storage::disk('public')->delete($deteksi->gambar);
            }

            $file = $request->file('gambar');
            $filename = 'deteksi_' . $request->user()->id . '_' . time() . '.' . $file->getClientOriginalExtension();
            $validated['gambar'] = $file->storeAs('deteksi', $filename, 'public');
        }

        $deteksi->update($validated);

        return response()->json($deteksi->load('lahan'));
    }

    public function destroy(Request $request, Deteksi $deteksi): JsonResponse
    {
        if ($deteksi->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke data deteksi ini.');
        }

        if ($deteksi->gambar && Storage::disk('public')->exists($deteksi->gambar)) {
            Storage::disk('public')->delete($deteksi->gambar);
        }

        $deteksi->delete();

        return response()->json([
            'message' => 'Data deteksi berhasil dihapus.',
        ]);
    }
}
