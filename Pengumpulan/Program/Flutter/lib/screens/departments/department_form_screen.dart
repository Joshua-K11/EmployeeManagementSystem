import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/department.dart';
import '../../providers/department_provider.dart';

class DepartmentFormScreen extends StatefulWidget {
  static const routeName = '/department-form';

  @override
  _DepartmentFormScreenState createState() => _DepartmentFormScreenState();
}

class _DepartmentFormScreenState extends State<DepartmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  var _isLoading = false;
  var _isInit = true;
  var _isEditing = false;
  late Department _editedDepartment;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final departmentId = ModalRoute.of(context)?.settings.arguments as int?;
      
      if (departmentId != null) {
        _isEditing = true;
        _editedDepartment = Provider.of<DepartmentProvider>(context, listen: false)
            .findById(departmentId);
            
        _nameController.text = _editedDepartment.name;
        _descriptionController.text = _editedDepartment.description;
      }
      
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final department = Department(
      id: _isEditing ? _editedDepartment.id : 0,
      name: _nameController.text,
      description: _descriptionController.text,
    );

    try {
      if (_isEditing) {
        await Provider.of<DepartmentProvider>(context, listen: false)
            .updateDepartment(_editedDepartment.id, department);
      } else {
        await Provider.of<DepartmentProvider>(context, listen: false)
            .addDepartment(department);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Department' : 'Add Department'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Department Name',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a department name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
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
    );
  }
}