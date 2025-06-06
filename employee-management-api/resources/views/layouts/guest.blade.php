<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'Laravel') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    {{-- Tambahkan background image pada body --}}
    <body class="font-sans text-gray-900 antialiased"
          style="background-image: url('{{ asset('images/background-login.jpg') }}'); background-size: cover; background-position: center; background-repeat: no-repeat; background-attachment: fixed;">

        {{-- Modifikasi div utama untuk efek overlay dan blur --}}
        <div class="min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-white bg-opacity-80 dark:bg-gray-900 dark:bg-opacity-70 backdrop-blur-sm">
            {{-- Bagian Logo --}}
            <div>
                <a href="/">
                    {{-- Ganti <x-application-logo /> dengan tag <img> Anda --}}
                    <img src="{{ asset('images/logo1.png') }}" alt="Your Company Logo" class="w-32 h-32 sm:w-34 sm:h-34 object-contain">
                    {{-- Sesuaikan kelas 'w-24 h-24 sm:w-32 sm:h-32' sesuai ukuran dan responsivitas yang Anda inginkan --}}
                </a>
            </div>

            {{-- Modifikasi div kotak form untuk efek overlay dan blur --}}
            <div class="w-full sm:max-w-md mt-6 px-6 py-8 bg-white bg-opacity-90 dark:bg-gray-800 dark:bg-opacity-90 shadow-md overflow-hidden sm:rounded-lg backdrop-blur">
                {{ $slot }}
            </div>
        </div>
    </body>
</html>