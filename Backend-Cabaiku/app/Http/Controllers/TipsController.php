<?php

namespace App\Http\Controllers;

use App\Models\Artikel;
use Illuminate\Http\Request;

class TipsController extends Controller
{
    public function index(Request $request)
    {
        $query = Artikel::published();

        if ($request->filled('q')) {
            $query->search($request->q);
        }
        if ($request->filled('kategori')) {
            $query->byKategori($request->kategori);
        }

        $artikels  = $query->latest('published_at')->paginate(8)->withQueryString();
        $kategoris = Artikel::published()->distinct()->pluck('kategori')->filter()->values();

        return view('pages.tips', compact('artikels', 'kategoris'));
    }

    public function show($id)
    {
        $artikel = Artikel::published()->findOrFail($id);
        $related = Artikel::published()
                          ->where('id', '!=', $id)
                          ->where('kategori', $artikel->kategori)
                          ->take(3)->get();

        return view('pages.tips-detail', compact('artikel', 'related'));
    }
}
