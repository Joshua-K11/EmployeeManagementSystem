{{-- Di bagian navigasi desktop (sekitar baris 26-30): --}}
<div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
    <x-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
        {{ __('Dashboard') }}
    </x-nav-link>

    <x-nav-link :href="route('employees.index')" :active="request()->routeIs('employees.*')">
        {{ __('Karyawan') }}
    </x-nav-link>

    <x-nav-link :href="route('departments.index')" :active="request()->routeIs('departments.*')">
        {{ __('Departemen') }}
    </x-nav-link>

    {{-- Tambahkan tautan ini untuk Analisis (Desktop) --}}
    <x-nav-link :href="route('analytics.index')" :active="request()->routeIs('analytics.*')">
        {{ __('Analisis') }}
    </x-nav-link>
</div>


{{-- Di bagian navigasi responsif (sekitar baris 90-95): --}}
<div :class="{'block': open, 'hidden': ! open}" class="hidden sm:hidden">
    <div class="pt-2 pb-3 space-y-1">
        <x-responsive-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
            {{ __('Dashboard') }}
        </x-responsive-nav-link>

        <x-responsive-nav-link :href="route('employees.index')" :active="request()->routeIs('employees.*')">
            {{ __('Karyawan') }}
        </x-responsive-nav-link>

        <x-responsive-nav-link :href="route('departments.index')" :active="request()->routeIs('departments.*')">
            {{ __('Departemen') }}
        </x-responsive-nav-link>

        {{-- Tambahkan tautan ini untuk Analisis (Responsive) --}}
        <x-responsive-nav-link :href="route('analytics.index')" :active="request()->routeIs('analytics.*')">
            {{ __('Analisis') }}
        </x-responsive-nav-link>
    </div>
    </div>