

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/submission.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class SubmissionTable extends StatefulWidget {
  final List<Submission> taskList;
  final int? selectedBatchId;
  final String? selectedTaskType;

  const SubmissionTable(
      {Key? key,
      required this.taskList,
      this.selectedBatchId,
      this.selectedTaskType})
      : super(key: key);

  @override
  SubmissionTableState createState() => SubmissionTableState();
}

class SubmissionTableState extends State<SubmissionTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<Submission> _editedTasks = [];
  final List<Submission> _newTasks = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(Submission user) getField, int columnIndex,
      bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (ascending) {
        widget.taskList.sort((a, b) => getField(a).compareTo(getField(b) as T));
      } else {
        widget.taskList.sort((a, b) => getField(b).compareTo(getField(a) as T));
      }
    });
  }

  void _updateTask(Submission user) {
    setState(() {
      if (!_editedTasks.contains(user)) {
        _editedTasks.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: PaginatedDataTable2(
        minWidth: 800,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: const Text('Submissions'),
        columns:  [
          DataColumn2(
            label: Text('Trainee ID'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.traineeId, columnIndex, ascending);
            }
          ),

          DataColumn2(
            label: Text('File'),
          ),

        ],
        source: TaskDataTableSource(
            newTasks: _newTasks,
            taskList: widget.taskList,
            editedTasks: _editedTasks,
            updateTask: _updateTask,
            setState: setState,
            context: context),
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

    );
  }
}

class TaskDataTableSource extends DataTableSource {
  final List<Submission> taskList;
  final List<Submission> editedTasks;
  final List<Submission> newTasks;
  final Function(Submission) updateTask;
  final BuildContext context;

  final Function(void Function()) setState;

  TaskDataTableSource({
    required this.newTasks,
    required this.taskList,
    required this.editedTasks,
    required this.updateTask,
    required this.setState,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    final task = taskList[index];
    final isEditing = editedTasks.contains(task);
    final isNew = newTasks.contains(task);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return DataRow(
      cells: [
        DataCell(
          Text(task.traineeId?.toString() ?? ''),
        ),


        DataCell(
          IconButton(onPressed: task.fileId != null ?() {
                context.read<AppController>().downloadFile(task.fileId!);

          }:null, icon :const Icon( Icons.file_download),

          ),
        ),

      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => taskList.length;

  @override
  int get selectedRowCount => 0;
}
