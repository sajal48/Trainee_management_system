import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserDataTable extends StatefulWidget {
  final List<User> userList;

  const UserDataTable({Key? key, required this.userList}) : super(key: key);

  @override
  UserDataTableState createState() => UserDataTableState();
}

class UserDataTableState extends State<UserDataTable> {
  List<User> _editedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Table'),
      ),
      body: ListView(
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Actions')),
            ],
            rows: [
              ...widget.userList.map((user) {
                bool isEditing = _editedUsers.contains(user);
                log(isEditing.toString());
                return DataRow(
                  cells: [
                    DataCell(
                      isEditing
                          ? TextFormField(
                              initialValue: user.fullName ?? '',
                              onChanged: (value) {
                                setState(() {
                                  user.fullName = value;
                                });
                              },
                            )
                          : Text(user.fullName ?? ''),
                    ),
                    DataCell(
                      isEditing
                          ? TextFormField(
                              initialValue: user.presentAddress ?? '',
                              onChanged: (value) {
                                setState(() {
                                  user.presentAddress = value;
                                });
                              },
                            )
                          : Text(user.presentAddress ?? ''),
                    ),
                    DataCell(
                      isEditing
                          ? TextFormField(
                              initialValue: user.email ?? '',
                              onChanged: (value) {
                                setState(() {
                                  user.email = value;
                                });
                              },
                            )
                          : Text(user.email ?? ''),
                    ),
                    DataCell(
                      isEditing
                          ? IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () {
                                setState(() {
                                  _editedUsers.remove(user);
                                });
                              },
                            )
                          : Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _editedUsers.add(user);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      widget.userList.remove(user);
                                    });
                                  },
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            widget.userList.add(User());
          });
        },
      ),
    );
  }
}
