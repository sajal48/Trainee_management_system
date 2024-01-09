import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserData2Table extends StatefulWidget {
  final List<User> userList;

  const UserData2Table({Key? key, required this.userList}) : super(key: key);

  @override
  UserData2TableState createState() => UserData2TableState();
}

class UserData2TableState extends State<UserData2Table> {
  List<User> _editedUsers = [];
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (ascending) {
        widget.userList.sort((a, b) => getField(a).compareTo(getField(b) as T));
      } else {
        widget.userList.sort((a, b) => getField(b).compareTo(getField(a) as T));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Table'),
      ),
      body: DataTable2(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: [
          DataColumn2(
            label: Text('Name'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.fullName ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Address'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.presentAddress ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Email'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.email ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Actions'),
            size: ColumnSize.S,
          ),
        ],
        rows: [
          ...widget.userList.map((user) {
            bool isEditing = _editedUsers.contains(user);
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            User newUser = User(); // Create a new user
            _editedUsers.add(newUser); // Make the new row editable
            widget.userList.insert(0, newUser); // Insert the new user at the beginning of the list
          });
        },
      ),
    );
  }
}
