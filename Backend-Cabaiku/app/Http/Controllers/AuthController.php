<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // Register user
    public function regiter(Request $request){
        $validator = Validator::make($request->all(),[
            'nama' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:4',
            'no_wa' => 'required',
            'lokasi' => 'required',
        ]);

        if($validator->fails()){
            return response()->json([
                'status' => 'error',
                'message' => 'validation error',
                'errors' => $validator->errors()
            ], 422);
        }
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'no_wa' => $request->no_wa,
            'lokasi' => $request->lokasi,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'user registered successfully',
            'data' => $user,
            'token' => $token
        ], 201);

    }

    // Login user
    public function Login(Request $request){
        $validator = Validator::make($request->all(),[
            'email' => 'required|email',
            'password' => 'required|min:4',
        ]);

        if($validator->fails()){
            return response()->json([
                'status' => 'error',
                'message' => 'validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if(!$user || !Hash::check($request->password, $user->password)){
            return response()->json([
                'status' => 'error',
                'message' => 'invalid email or password'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'user logged in successfully',
            'data' => $user,
            'token' => $token
        ], 200);
    }

    // Logout user
    public function Logout(){
        try {
            auth()->user()->tokens()->delete();
            return response()->json([
                'status' => 'success',
                'message' => 'user logged out successfully'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'failed to logout user',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
