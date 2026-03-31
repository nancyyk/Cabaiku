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
}
