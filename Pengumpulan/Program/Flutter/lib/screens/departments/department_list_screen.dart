import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/department_provider.dart';
import '../../widgets/app_drawer.dart';
import 'department_form_screen.dart';

class DepartmentListScreen extends StatefulWidget {
  static const routeName = '/department-list';

  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DepartmentProvider>(context).fetchDepartments().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final departments = departmentProvider.departments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(DepartmentFormScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : departments.isEmpty
              ? Center(
                child: Text(
                  'No departments found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: departments.length,
                itemBuilder:
                    (ctx, i) => Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(departments[i].name[0]),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        title: Text(departments[i].name),
                        subtitle: Text(departments[i].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  DepartmentFormScreen.routeName,
                                  arguments: departments[i].id,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: Text('Delete Department'),
                                        content: Text(
                                          'Are you sure you want to delete ${departments[i].name}?',
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
                                              departmentProvider
                                                  .deleteDepartment(
                                                    departments[i].id,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(DepartmentFormScreen.routeName);
        },
      ),
    );
  }
}
