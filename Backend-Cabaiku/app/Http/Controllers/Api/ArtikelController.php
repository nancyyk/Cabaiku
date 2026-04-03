<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Artikel;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ArtikelController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Artikel::query();

        if ($request->boolean('published_only', true)) {
            $query->published();
        }

        if ($request->filled('q')) {
            $query->search($request->string('q')->toString());
        }

        if ($request->filled('kategori')) {
            $query->byKategori($request->string('kategori')->toString());
        }

        $artikels = $query->latest('published_at')->latest('id')->paginate(10);

        return response()->json($artikels);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'judul' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255|unique:artikels,slug',
            'konten' => 'required|string',
            'ringkasan' => 'nullable|string',
            'gambar' => 'nullable|string|max:255',
            'kategori' => 'nullable|string|max:100',
            'waktu_baca' => 'nullable|integer|min:1',
            'penulis' => 'nullable|string|max:255',
            'is_published' => 'nullable|boolean',
            'published_at' => 'nullable|date',
        ]);

        if (empty($validated['slug'])) {
            $baseSlug = Str::slug($validated['judul']);
            $slug = $baseSlug;
            $counter = 1;

            while (Artikel::where('slug', $slug)->exists()) {
                $slug = $baseSlug . '-' . $counter;
                $counter++;
            }

            $validated['slug'] = $slug;
        }

        $artikel = Artikel::create($validated);

        return response()->json($artikel, 201);
    }

    public function show(Artikel $artikel): JsonResponse
    {
        return response()->json($artikel);
    }

    public function update(Request $request, Artikel $artikel): JsonResponse
    {
        $validated = $request->validate([
            'judul' => 'sometimes|required|string|max:255',
            'slug' => 'sometimes|nullable|string|max:255|unique:artikels,slug,' . $artikel->id,
            'konten' => 'sometimes|required|string',
            'ringkasan' => 'sometimes|nullable|string',
            'gambar' => 'sometimes|nullable|string|max:255',
            'kategori' => 'sometimes|nullable|string|max:100',
            'waktu_baca' => 'sometimes|nullable|integer|min:1',
            'penulis' => 'sometimes|nullable|string|max:255',
            'is_published' => 'sometimes|boolean',
            'published_at' => 'sometimes|nullable|date',
        ]);

        $artikel->update($validated);

        return response()->json($artikel);
    }

    public function destroy(Artikel $artikel): JsonResponse
    {
        $artikel->delete();

        return response()->json([
            'message' => 'Artikel berhasil dihapus.',
        ]);
    }
}
