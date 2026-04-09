<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Artikel;
use App\Models\User;
use Illuminate\View\View;

class DashboardController extends Controller
{
    public function index(): View
    {
        $users = User::query()
            ->select(['id', 'name', 'email', 'created_at'])
            ->latest('created_at')
            ->paginate(15);

        $totalUsers = User::count();
        $totalArticles = Artikel::count();

        return view('admin.dashboard', compact('users', 'totalUsers', 'totalArticles'));
    }
}
