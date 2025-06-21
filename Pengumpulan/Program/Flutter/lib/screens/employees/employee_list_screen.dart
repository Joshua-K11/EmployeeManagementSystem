// lib/screens/employees/employee_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/employee_provider.dart';
import '../../providers/department_provider.dart';
import '../../widgets/app_drawer.dart';
import 'employee_detail_screen.dart';
import 'employee_form_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  static const routeName = '/employee-list';

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  var _isInit = true;
  var _isLoading = false;
  final _searchController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<EmployeeProvider>(
        context,
        listen: false,
      ).setSearchQuery(_searchController.text);
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<EmployeeProvider>(context).fetchEmployees().then((_) {
        Provider.of<DepartmentProvider>(
          context,
          listen: false,
        ).fetchDepartments().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final employees = employeeProvider.employees;
    final departments = departmentProvider.departments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EmployeeFormScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search employees',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          decoration: InputDecoration(
                            labelText: 'Filter by Department',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value:
                              employeeProvider
                                  .filterDepartmentId, // Use public getter here
                          items: [
                            DropdownMenuItem<int?>(
                              value: null,
                              child: Text('All Departments'),
                            ),
                            ...departments.map(
                              (dept) => DropdownMenuItem<int?>(
                                value: dept.id,
                                child: Text(dept.name),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            employeeProvider.setFilterDepartment(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        employees.isEmpty
                            ? Center(
                              child: Text(
                                'No employees found.',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                            : ListView.builder(
                              itemCount: employees.length,
                              itemBuilder:
                                  (ctx, i) => Card(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    elevation: 2,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child:
                                            employees[i].profileImage == null
                                                ? Text(employees[i].name[0])
                                                : null,
                                        backgroundImage:
                                            employees[i].profileImage != null
                                                ? NetworkImage(
                                                  employees[i].profileImage!,
                                                )
                                                : null,
                                      ),
                                      title: Text(employees[i].name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(employees[i].position),
                                          Text(employees[i].departmentName),
                                          Text(
                                            currencyFormatter.format(
                                              employees[i].salary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (ctx) => AlertDialog(
                                                  title: Text(
                                                    'Delete Employee',
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete ${employees[i].name}?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                        employeeProvider
                                                            .deleteEmployee(
                                                              employees[i].id,
                                                            );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          EmployeeDetailScreen.routeName,
                                          arguments: employees[i].id,
                                        );
                                      },
                                    ),
                                  ),
                            ),
                  ),
                ],
              ),
    );
  }
}
