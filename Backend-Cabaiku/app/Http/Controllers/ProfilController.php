<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class ProfilController extends Controller
{
    public function index()
    {
        $user         = Auth::user();
        $totalDeteksi = $user->deteksis()->count();
        $artikelDibaca = 15;
        $hariAktif    = (int) $user->created_at->diffInDays(now()) + 1;

        return view('pages.profil', compact('user', 'totalDeteksi', 'artikelDibaca', 'hariAktif'));
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $request->validate([
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email,' . $user->id,
            'phone'    => 'nullable|string|max:20',
            'location' => 'nullable|string|max:255',
        ], [
            'name.required'  => 'Nama wajib diisi',
            'email.required' => 'Email wajib diisi',
            'email.unique'   => 'Email sudah digunakan',
        ]);

        $user->update($request->only('name', 'email', 'phone', 'location'));
        return redirect()->route('profil')->with('success', 'Profil berhasil diperbarui!');
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'password'         => ['required', 'confirmed', Password::min(8)],
        ], [
            'current_password.required' => 'Password saat ini wajib diisi',
            'password.required'         => 'Password baru wajib diisi',
            'password.confirmed'        => 'Konfirmasi password tidak cocok',
        ]);

        $user = Auth::user();
        if (!Hash::check($request->current_password, $user->password)) {
            return back()->withErrors(['current_password' => 'Password saat ini tidak sesuai']);
        }

        $user->update(['password' => Hash::make($request->password)]);
        return redirect()->route('profil')->with('success', 'Password berhasil diubah!');
    }

    public function updateBahasa(Request $request)
    {
        $request->validate(['bahasa' => 'required|in:id,en']);
        Auth::user()->update(['bahasa' => $request->bahasa]);
        return redirect()->route('profil')->with('success', 'Bahasa berhasil diubah!');
    }
}
