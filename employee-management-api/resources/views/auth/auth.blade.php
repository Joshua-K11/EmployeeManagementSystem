@extends('layouts.app')

@section('content')
<div class="container mt-5" style="max-width: 500px;">
    <ul class="nav nav-tabs mb-4" id="authTab" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="login-tab" data-bs-toggle="tab" href="#login" role="tab">Login</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="register-tab" data-bs-toggle="tab" href="#register" role="tab">Register</a>
        </li>
    </ul>

    <div class="tab-content">
        {{-- Login Tab --}}
        <div class="tab-pane fade show active" id="login" role="tabpanel">
            <div id="login-error" class="alert alert-danger d-none"></div>
            <form id="loginForm">
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>
        </div>

        {{-- Register Tab --}}
        <div class="tab-pane fade" id="register" role="tabpanel">
            <div id="register-error" class="alert alert-danger d-none"></div>
            <form id="registerForm">
                <div class="mb-3">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="password_confirmation" class="form-control" required />
                </div>
                <button type="submit" class="btn btn-success w-100">Register</button>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const form = e.target;
    const email = form.email.value;
    const password = form.password.value;

    try {
        const res = await fetch('/api/login', {
            method: 'POST',
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: JSON.stringify({ email, password })
        });

        const data = await res.json();

        if (!res.ok) throw new Error(data.message || 'Login failed');
        
        localStorage.setItem('auth_token', data.token);
        localStorage.setItem('user_name', data.user.name);
        window.location.href = '/analytics';
    } catch (err) {
        const errDiv = document.getElementById('login-error');
        errDiv.classList.remove('d-none');
        errDiv.innerText = err.message;
    }
});

document.getElementById('registerForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const form = e.target;

    const name = form.name.value;
    const email = form.email.value;
    const password = form.password.value;
    const password_confirmation = form.password_confirmation.value;

    try {
        const res = await fetch('/api/register', {
            method: 'POST',
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: JSON.stringify({ name, email, password, password_confirmation })
        });

        const data = await res.json();

        if (!res.ok) {
            const msg = Object.values(data.errors || {}).flat().join('\n') || data.message;
            throw new Error(msg);
        }

        localStorage.setItem('auth_token', data.token);
        localStorage.setItem('user_name', data.user.name);
        window.location.href = '/analytics';
    } catch (err) {
        const errDiv = document.getElementById('register-error');
        errDiv.classList.remove('d-none');
        errDiv.innerText = err.message;
    }
});
</script>
@endpush
