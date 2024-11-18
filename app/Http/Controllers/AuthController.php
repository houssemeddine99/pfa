<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login');
    }
    public function register(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);
    
        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => Hash::make($validatedData['password']), // Ensure password is hashed
        ]);
    
        Auth::login($user);
        return redirect('/'); // Redirect to root which should be your product page
    }
    
    public function login(Request $request)
    {
        error_log("Login function called");
        $credentials = $request->only('email', 'password');
        error_log($credentials['email'] , $credentials['password']);
        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();
            return redirect('/'); // Redirect to root which should be your product page
        }
        error_log('Login failed for email: ' . $credentials['email']);
        return back()->withErrors([
            'email' => 'The provided credentials do not match our records.',
        ]);
    }

    public function showRegistrationForm()
    {
        return view('auth.register');
    }
    

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/'); // Redirect to root which should be your product page
    }
}