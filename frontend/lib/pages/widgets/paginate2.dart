import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class Paginate2 extends StatefulWidget {
  final List<User> userList;

  const Paginate2({Key? key, required this.userList}) : super(key: key);

  @override
  Paginate2State createState() => Paginate2State();
}

class Paginate2State extends State<Paginate2> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<User> _editedUsers = [];

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

  void _updateUser(User user) {
    setState(() {
      if (!_editedUsers.contains(user)) {
        _editedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      appBar: AppBar(
        title: Text('User Data Table'),
      ),
      body: PaginatedDataTable2(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: Text('Users'),
        columns: [
          DataColumn2(
            label: Text('Name'),
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.fullName ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Address'),
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.presentAddress ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Email'),
            onSort: (columnIndex, ascending) {
              _sort<String>((user) => user.email ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: Text('Actions'),
          ),
        ],
        source: UserDataTableSource(
          userList: widget.userList,
          editedUsers: _editedUsers,
          updateUser: _updateUser,
          setState: setState,
        ),
        rowsPerPage: _rowsPerPage,
        onPageChanged: (pageIndex) {
          // Handle page change
        },
        onRowsPerPageChanged: (newRowsPerPage) {
          setState(() {
            _rowsPerPage = newRowsPerPage!;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            User newUser = User();
            widget.userList.insert(0, newUser);
            _editedUsers.add(newUser);
          });
        },
      ),
    );
  }
}

class UserDataTableSource extends DataTableSource {
  final List<User> userList;
  final List<User> editedUsers;
  final Function(User) updateUser;
  final Function(void Function()) setState;

  UserDataTableSource({
    required this.userList,
    required this.editedUsers,
    required this.updateUser,
    required this.setState,
  });

  @override
  DataRow? getRow(int index) {
    final user = userList[index];
    final isEditing = editedUsers.contains(user);

    return DataRow(
      cells: [
        DataCell(
          isEditing
              ? TextFormField(
            initialValue: user.fullName ?? '',
            onChanged: (value) {
              user.fullName = value;
              updateUser(user);
            },
          )
              : Text(user.fullName ?? ''),
        ),
        DataCell(
          isEditing
              ? TextFormField(
            initialValue: user.presentAddress ?? '',
            onChanged: (value) {
              user.presentAddress = value;
              updateUser(user);
            },
          )
              : Text(user.presentAddress ?? ''),
        ),
        DataCell(
          isEditing
              ? TextFormField(
            initialValue: user.email ?? '',
            onChanged: (value) {
              user.email = value;
              updateUser(user);
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
                editedUsers.remove(user);
              });
            },
          )
              : Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    editedUsers.add(user);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    userList.remove(user);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.length;

  @override
  int get selectedRowCount => 0;
}
