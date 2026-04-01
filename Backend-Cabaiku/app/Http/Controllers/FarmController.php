<?php

namespace App\Http\Controllers;
use App\Models\Farm;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

use Illuminate\Http\Request;

class FarmController extends Controller
{
    public function index()
    {
        $token = request()->bearerToken();
        $farms = Farm::where('user_id', Auth::id())->get();
        return response()->json([
            'status' => 'success',
            'message' => 'List of farms',
            'data' => $farms
        ], 200);
    }

    // membuat lahan baru
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_lahan' => 'required|string|max:255',
            'lokasi_lahan' => 'required|string|max:255',
            'luas_lahan' => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $farm = Farm::create([
            'user_id' => Auth::id(),
            'nama_lahan' => $request->nama_lahan,
            'lokasi_lahan' => $request->lokasi_lahan,
            'luas_lahan' => $request->luas_lahan,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'lahan berhasil dibuat',
            'data' => $farm
        ], 201);
    }

    public function show($id)
    {
        $farm = Farm::where('id', $id)->where('user_id', Auth::id())->first();

        if (!$farm) {
            return response()->json([
                'status' => 'error',
                'message' => 'lahan tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'detail lahan',
            'data' => $farm
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $farm = Farm::where('id', $id)->where('user_id', Auth::id())->first();

        if (!$farm) {
            return response()->json([
                'status' => 'error',
                'message' => 'lahan tidak ditemukan'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'nama_lahan' => 'required|string|max:255',
            'lokasi_lahan' => 'required|string|max:255',
            'luas_lahan' => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $farm->update([
            'nama_lahan' => $request->nama_lahan,
            'lokasi_lahan' => $request->lokasi_lahan,
            'luas_lahan' => $request->luas_lahan,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'lahan berhasil diperbarui',
            'data' => $farm
        ], 200);
    }

    public function destroy($id)
    {
        $farm = Farm::where('id', $id)->where('user_id', Auth::id())->first();

        if (!$farm) {
            return response()->json([
                'status' => 'error',
                'message' => 'lahan tidak ditemukan'
            ], 404);
        }

        $farm->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'lahan berhasil dihapus'
        ], 200);
    }


}
