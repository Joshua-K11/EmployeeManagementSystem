import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/employee.dart';
import '../../providers/employee_provider.dart';
import '../../providers/department_provider.dart';

class EmployeeFormScreen extends StatefulWidget {
  static const routeName = '/employee-form';

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _joiningDateController = TextEditingController();

  int? _departmentId;
  DateTime? _selectedDate;
  var _isLoading = false;
  var _isInit = true;
  var _isEditing = false;
  late Employee _editedEmployee;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final employeeId = ModalRoute.of(context)?.settings.arguments as int?;

      if (employeeId != null) {
        _isEditing = true;
        _editedEmployee = Provider.of<EmployeeProvider>(
          context,
          listen: false,
        ).findById(employeeId);

        _nameController.text = _editedEmployee.name;
        _emailController.text = _editedEmployee.email;
        _positionController.text = _editedEmployee.position;
        _salaryController.text = _editedEmployee.salary.toString();
        _phoneController.text = _editedEmployee.phoneNumber;
        _addressController.text = _editedEmployee.address;
        _joiningDateController.text = _editedEmployee.joiningDate;
        _departmentId = _editedEmployee.departmentId;
        _selectedDate = DateTime.parse(_editedEmployee.joiningDate);
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _joiningDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _departmentId == null || _selectedDate == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final employee = Employee(
      id: _isEditing ? _editedEmployee.id : 0,
      name: _nameController.text,
      email: _emailController.text,
      position: _positionController.text,
      departmentId: _departmentId!,
      departmentName: '', // This will be set by the API
      salary: double.parse(_salaryController.text),
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      joiningDate: _joiningDateController.text,
    );

    try {
      if (_isEditing) {
        await Provider.of<EmployeeProvider>(
          context,
          listen: false,
        ).updateEmployee(_editedEmployee.id, employee);
      } else {
        await Provider.of<EmployeeProvider>(
          context,
          listen: false,
        ).addEmployee(employee);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = Provider.of<DepartmentProvider>(context).departments;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Employee' : 'Add Employee'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(),
                          ),
                          value: _departmentId,
                          items:
                              departments.map((department) {
                                return DropdownMenuItem(
                                  value: department.id,
                                  child: Text(department.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _departmentId = value as int;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _positionController,
                          decoration: InputDecoration(
                            labelText: 'Position',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a position';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _salaryController,
                          decoration: InputDecoration(
                            labelText: 'Salary',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a salary';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a salary greater than zero';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _joiningDateController,
                          decoration: InputDecoration(
                            labelText: 'Joining Date',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a joining date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saveForm,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            child: Text(
                              _isEditing ? 'UPDATE' : 'SAVE',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
