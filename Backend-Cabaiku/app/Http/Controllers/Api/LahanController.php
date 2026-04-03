<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Lahan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LahanController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $lahans = $request->user()->lahans()->latest()->paginate(10);

        return response()->json($lahans);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'nama_lahan' => 'required|string|max:255',
            'lokasi' => 'required|string|max:255',
            'luas' => 'nullable|numeric|min:0',
            'keterangan' => 'nullable|string|max:500',
        ]);

        $lahan = $request->user()->lahans()->create($validated);

        return response()->json($lahan, 201);
    }

    public function show(Request $request, Lahan $lahan): JsonResponse
    {
        if ($lahan->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke lahan ini.');
        }

        return response()->json($lahan);
    }

    public function update(Request $request, Lahan $lahan): JsonResponse
    {
        if ($lahan->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke lahan ini.');
        }

        $validated = $request->validate([
            'nama_lahan' => 'sometimes|required|string|max:255',
            'lokasi' => 'sometimes|required|string|max:255',
            'luas' => 'sometimes|nullable|numeric|min:0',
            'keterangan' => 'sometimes|nullable|string|max:500',
        ]);

        $lahan->update($validated);

        return response()->json($lahan);
    }

    public function destroy(Request $request, Lahan $lahan): JsonResponse
    {
        if ($lahan->user_id !== $request->user()->id) {
            abort(403, 'Anda tidak memiliki akses ke lahan ini.');
        }

        $lahan->delete();

        return response()->json([
            'message' => 'Lahan berhasil dihapus.',
        ]);
    }
}
