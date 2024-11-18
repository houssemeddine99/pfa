<?php
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use Illuminate\Support\Facades\Auth;  
use App\Models\User;  

// Authentication Routes
Route::get('/register', [AuthController::class, 'showRegistrationForm'])->name('register');
Route::post('/register', [AuthController::class, 'register'])->name('register.post');
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.post');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout'); // Fixed logout route

// Protected Routes
Route::middleware(['auth'])->group(function () {
    // Root route
    Route::get('/', [ProductController::class, 'index'])->name('product.index');
    
    // Product Routes
    Route::prefix('product')->group(function () {
        Route::get('/', [ProductController::class, 'index'])->name('product.index');
        Route::get('/create', [ProductController::class, 'create'])->name('product.create');
        Route::post('/', [ProductController::class, 'store'])->name('product.store');
        Route::get('/{product}/edit', [ProductController::class, 'edit'])->name('product.edit');
        Route::put('/{product}/update', [ProductController::class, 'update'])->name('product.update');
        Route::delete('/{product}/destroy', [ProductController::class, 'destroy'])->name('product.destroy');
    });

    // Home route
    Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
});

// Remove duplicate Auth::routes() - only need one
Auth::routes();