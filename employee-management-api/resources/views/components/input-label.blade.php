@props(['value'])

<label {{ $attributes->merge(['class' => 'block font-medium text-sm text-white dark:text-white']) }}>
    {{ $value ?? $slot }}
</label>