<?php

namespace Tests\Feature\Api;

use App\Models\Department;
use App\Models\Employee;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class EmployeeTest extends TestCase
{
    use RefreshDatabase;

    protected $token;

    public function setUp(): void
    {
        parent::setUp();

        // Create user and get token
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => bcrypt('password'),
        ]);

        $response = $this->post('/api/login', [
            'email' => 'test@example.com',
            'password' => 'password',
        ]);

        $this->token = $response->json('token');

        // Create department
        Department::create([
            'name' => 'Test Department',
            'description' => 'Test Description',
        ]);
    }

    public function test_can_get_all_employees()
    {
        // Create test employee
        Employee::create([
            'name' => 'Test Employee',
            'email' => 'employee@test.com',
            'position' => 'Tester',
            'department_id' => 1,
            'salary' => 10000000,
            'phone_number' => '123456789',
            'address' => 'Test Address',
            'joining_date' => now()->format('Y-m-d'),
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->get('/api/employees');

        $response->assertStatus(200)
            ->assertJsonCount(1)
            ->assertJsonPath('0.name', 'Test Employee');
    }

    public function test_can_create_employee()
    {
        $employeeData = [
            'name' => 'New Employee',
            'email' => 'new.employee@test.com',
            'position' => 'Developer',
            'department_id' => 1,
            'salary' => 15000000,
            'phone_number' => '987654321',
            'address' => 'New Address',
            'joining_date' => now()->format('Y-m-d'),
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->post('/api/employees', $employeeData);

        $response->assertStatus(201)
            ->assertJsonPath('name', 'New Employee');

        $this->assertDatabaseHas('employees', [
            'email' => 'new.employee@test.com',
        ]);
    }

    public function test_can_update_employee()
    {
        // Create test employee
        $employee = Employee::create([
            'name' => 'Test Employee',
            'email' => 'employee@test.com',
            'position' => 'Tester',
            'department_id' => 1,
            'salary' => 10000000,
            'phone_number' => '123456789',
            'address' => 'Test Address',
            'joining_date' => now()->format('Y-m-d'),
        ]);

        $updateData = [
            'name' => 'Updated Employee',
            'position' => 'Senior Tester',
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->put("/api/employees/{$employee->id}", $updateData);

        $response->assertStatus(200)
            ->assertJsonPath('name', 'Updated Employee')
            ->assertJsonPath('position', 'Senior Tester');

        $this->assertDatabaseHas('employees', [
            'id' => $employee->id,
            'name' => 'Updated Employee',
            'position' => 'Senior Tester',
        ]);
    }

    public function test_can_delete_employee()
    {
        // Create test employee
        $employee = Employee::create([
            'name' => 'Test Employee',
            'email' => 'employee@test.com',
            'position' => 'Tester',
            'department_id' => 1,
            'salary' => 10000000,
            'phone_number' => '123456789',
            'address' => 'Test Address',
            'joining_date' => now()->format('Y-m-d'),
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->delete("/api/employees/{$employee->id}");

        $response->assertStatus(200)
            ->assertJsonPath('message', 'Employee deleted successfully');

        $this->assertDatabaseMissing('employees', [
            'id' => $employee->id,
        ]);
    }
}
