

import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Task.dart';


class MyTaskTable extends StatefulWidget {
  final List<Task> taskList;
  final int? selectedBatchId;
  final String? selectedTaskType;

  const MyTaskTable(
      {Key? key,
      required this.taskList,
      this.selectedBatchId,
      this.selectedTaskType})
      : super(key: key);

  @override
  MyTaskTableState createState() => MyTaskTableState();
}

class MyTaskTableState extends State<MyTaskTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<Task> _editedTasks = [];
  final List<Task> _newTasks = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(Task user) getField, int columnIndex,
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

  void _updateTask(Task user) {
    setState(() {
      if (!_editedTasks.contains(user)) {
        _editedTasks.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    var userId = context.read<AuthController>().userId;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: PaginatedDataTable2(
        minWidth: 1500,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: const Text('Tasks'),
        columns: [
          DataColumn2(
            fixedWidth: 180,
            label: const Text('Title'),
            onSort: (columnIndex, ascending) {
              _sort<String>((task) => task.title ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Description'),
            onSort: (columnIndex, ascending) {
              _sort<String>(
                  (task) => task.description ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Task Type'),
            onSort: (columnIndex, ascending) {
              _sort<String>(
                  (task) => task.taskType ?? '', columnIndex, ascending);
            },
          ),
          const DataColumn2(
            fixedWidth: 200,
            label: Text('Task File'),
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Created At'),
            onSort: (columnIndex, ascending) {
              _sort<String>(
                  (task) => task.createdAt ?? '', columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Submission Date'),
            onSort: (columnIndex, ascending) {
              _sort<String>(
                  (task) => task.submissionDate ?? '', columnIndex, ascending);
            },
          ),
          const DataColumn2(
            label: Text('Submission'),
          ),
        ],
        source: TaskDataTableSource(
            userId: userId!,
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
  final List<Task> taskList;
  final int userId;
  final List<Task> editedTasks;
  final List<Task> newTasks;
  final Function(Task) updateTask;
  final BuildContext context;

  final Function(void Function()) setState;

  TaskDataTableSource({
    required this.userId,
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
    final TextEditingController dateController =
        TextEditingController(text: taskList[index].submissionDate);
    final TextEditingController fileName =
        TextEditingController(text: taskList[index].submissionFile?.name);

    return DataRow(
      cells: [
        DataCell(
          Text(task.title ?? ''),
        ),
        DataCell(
        Text(task.description ?? ''),
        ),
        DataCell(
          Text(task.taskType ?? ''),
        ),
        DataCell(
          isEditing
              ? InkWell(
                  onTap: () async {
                    FilePickerResult? picked =
                        await FilePicker.platform.pickFiles();

                    if (picked != null) {
                      PlatformFile selectedFile = picked.files.first;
                      task.file = selectedFile;
                      updateTask(task);
                      setState(() {
                        fileName.text = selectedFile.name;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: fileName,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'Add file',
                      ),
                    ),
                  ),
                )
              : IconButton(onPressed: task.fileId != null ?() {
                context.read<AppController>().downloadFile(task.fileId!);

          }:null, icon :const Icon( Icons.file_download),

          ),
        ),
        DataCell(
          Text(task.createdAt ?? ''),
        ),
        DataCell(
        Text(task.submissionDate ?? ''),
        ),
        DataCell(
          InkWell(
            onTap: () async {
              FilePickerResult? picked =
              await FilePicker.platform.pickFiles();

              if (picked != null) {
                PlatformFile selectedFile = picked.files.first;
                print(selectedFile.name);
                context.read<AppController>().submitTask(taskId:task.id! ,traineeId:userId,file: selectedFile);
                task.submissionFile = selectedFile;
                updateTask(task);
                setState(() {
                  fileName.text = selectedFile.name;
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: fileName,
                enabled: false,
                decoration: const InputDecoration(
                  hintText: 'Add file',
                ),
              ),
            ),
          )

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
