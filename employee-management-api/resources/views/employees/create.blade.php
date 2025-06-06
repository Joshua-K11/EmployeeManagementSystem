<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Tambah Karyawan Baru') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <form method="POST" action="{{ route('employees.store') }}" enctype="multipart/form-data">
                        @csrf

                        <div>
                            <x-input-label for="name" :value="__('Nama')" />
                            {{-- Keterangan untuk Nama --}}
                            <small class="text-xs text-gray-500 block mt-1">Masukkan nama lengkap karyawan.</small>
                            <x-text-input id="name" class="block mt-1 w-full" type="text" name="name" :value="old('name')" required autofocus />
                            <x-input-error :messages="$errors->get('name')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="email" :value="__('Email')" />
                            {{-- Keterangan untuk Email --}}
                            <small class="text-xs text-gray-500 block mt-1">Alamat Email karyawan</small>
                            <x-text-input id="email" class="block mt-1 w-full" type="email" name="email" :value="old('email')" required />
                            <x-input-error :messages="$errors->get('email')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="position" :value="__('Posisi')" />
                            {{-- Keterangan untuk Posisi --}}
                            <small class="text-xs text-gray-500 block mt-1">Posisi karyawan</small>
                            <x-text-input id="position" class="block mt-1 w-full" type="text" name="position" :value="old('position')" required />
                            <x-input-error :messages="$errors->get('position')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="department_id" :value="__('Departemen')" />
                            {{-- Keterangan untuk Departemen --}}
                            <small class="text-xs text-gray-500 block mt-1">Departement karyawan</small>
                            <select id="department_id" name="department_id" class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm block mt-1 w-full" required>
                                <option value="">Pilih Departemen</option>
                                @foreach ($departments as $department)
                                    <option value="{{ $department->id }}" {{ old('department_id') == $department->id ? 'selected' : '' }}>
                                        {{ $department->name }}
                                    </option>
                                @endforeach
                            </select>
                            <x-input-error :messages="$errors->get('department_id')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="salary" :value="__('Gaji')" />
                            {{-- Keterangan untuk Gaji --}}
                            <small class="text-xs text-gray-500 block mt-1">Gaji pokok karyawan</small>
                            <x-text-input id="salary" class="block mt-1 w-full" type="number" step="0.01" name="salary" :value="old('salary')" required />
                            <x-input-error :messages="$errors->get('salary')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="phone_number" :value="__('Nomor Telepon')" />
                            {{-- Keterangan untuk Nomor Telepon --}}
                            <small class="text-xs text-gray-500 block mt-1">Nomor telepon karyawan</small>
                            <x-text-input id="phone_number" class="block mt-1 w-full" type="text" name="phone_number" :value="old('phone_number')" required />
                            <x-input-error :messages="$errors->get('phone_number')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="address" :value="__('Alamat')" />
                            {{-- Keterangan untuk Alamat --}}
                            <small class="text-xs text-gray-500 block mt-1">Alamat tempat tinggal karyawan</small>
                            <textarea id="address" name="address" rows="3" class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm block mt-1 w-full" required>{{ old('address') }}</textarea>
                            <x-input-error :messages="$errors->get('address')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="joining_date" :value="__('Tanggal Bergabung')" />
                            {{-- Keterangan untuk Tanggal Bergabung --}}
                            <small class="text-xs text-gray-500 block mt-1">Tanggal bergabung karyawan</small>
                            <x-text-input id="joining_date" class="block mt-1 w-full" type="date" name="joining_date" :value="old('joining_date')" required />
                            <x-input-error :messages="$errors->get('joining_date')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="profile_image" :value="__('Gambar Profil')" />
                            {{-- Keterangan untuk Gambar Profil --}}
                            <small class="text-xs text-gray-500 block mt-1">Unggah gambar profil karyawan (opsional).</small>
                            <input id="profile_image" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="file" name="profile_image" accept="image/*" />
                            <x-input-error :messages="$errors->get('profile_image')" class="mt-2" />
                        </div>

                        <div class="flex items-center justify-end mt-4">
                            <x-primary-button>
                                {{ __('Simpan') }}
                            </x-primary-button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>