<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Models\detections;

use Illuminate\Http\Request;

class DetectionsController extends Controller
{
    public function index()
    {
        $detections = detections::where('user_id', Auth::id())->get();
        if ($detections->isEmpty()) {
            return response()->json([
                'status' => 'success',
                'message' => 'No detections found',
                'data' => []
            ], 200);
        }
        return response()->json([
            'status' => 'success',
            'message' => 'List of detections',
            'data' => $detections
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'farm_id' => 'required|exists:farms,id',
            'image_path' => 'required|string',
            'lokasi_foto' => 'required|string',
            'hasil' => 'required|string',
            'status' => 'nullable|string|in:pending,success,failed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $detection = detections::create([
            'user_id' => Auth::id(),
            'farm_id' => $request->farm_id,
            'image_path' => $request->image_path,
            'lokasi_foto' => $request->lokasi_foto,
            'hasil' => $request->hasil,
            'status' => $request->status,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Detection created successfully',
            'data' => $detection
        ], 201);
    }

    public function show($id)
    {
        $detection = detections::where('id', $id)->where('user_id', Auth::id())->first();

        if (!$detection) {
            return response()->json([
                'status' => 'error',
                'message' => 'Detection not found',
                'data' => null
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Detection details',
            'data' => $detection
        ], 200);
    }

}
