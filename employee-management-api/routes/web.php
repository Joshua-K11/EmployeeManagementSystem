<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test-session', function () {
    session(['key' => 'value']);
    return session('key');
});
