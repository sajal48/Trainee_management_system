

import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Task.dart';


class TaskTable extends StatefulWidget {
  final List<Task> taskList;
  final int? selectedBatchId;
  final String? selectedTaskType;

  const TaskTable(
      {Key? key,
      required this.taskList,
      this.selectedBatchId,
      this.selectedTaskType})
      : super(key: key);

  @override
  TaskTableState createState() => TaskTableState();
}

class TaskTableState extends State<TaskTable> {
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: PaginatedDataTable2(
        minWidth: 1500,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: const Text('Tasks'),
        columns: [
          const DataColumn2(
            fixedWidth:100,
            label: Text('Batch ID'),
          ),
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
            fixedWidth: 100,
            label: Text('File'),
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
            label: Text('Actions'),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: FloatingActionButton(
          onPressed: (widget.selectedBatchId != null &&
                  widget.selectedTaskType != null)
              ? () {
                  setState(() {
                    Task newTask = Task(
                        assignedBy: context.read<AuthController>().getUserId(),
                        batchId: widget.selectedBatchId,
                        taskType: widget.selectedTaskType,
                        createdAt: dateFormat.format(DateTime.now()));
                    widget.taskList.insert(0, newTask);
                    isNew = true;
                    _editedTasks.add(newTask);
                    _newTasks.add(newTask);
                  });
                }
              : null,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TaskDataTableSource extends DataTableSource {
  final List<Task> taskList;
  final List<Task> editedTasks;
  final List<Task> newTasks;
  final Function(Task) updateTask;
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
    final TextEditingController dateController =
        TextEditingController(text: taskList[index].submissionDate);
    final TextEditingController fileName =
        TextEditingController(text: taskList[index].file?.name);

    return DataRow(
      cells: [
        DataCell(
          Text(task.batchId?.toString() ?? ''),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  initialValue: task.title ?? '',
                  onChanged: (value) {
                    task.title = value;
                    updateTask(task);
                  },
                )
              : Text(task.title ?? ''),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  initialValue: task.description ?? '',
                  onChanged: (value) {
                    task.description = value;
                    updateTask(task);
                  },
                )
              : Text(task.description ?? ''),
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
          isEditing
              ? TextFormField(
                  controller: dateController,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      task.submissionDate = dateFormat.format(selectedDate);
                      updateTask(task);
                      setState(() {
                        dateController.text = dateFormat.format(selectedDate);
                      }); // Format the selected date
                    }
                  },
                )
              : Text(task.submissionDate ?? ''),
        ),
        DataCell(
          isEditing
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        if (isNew){  await context.read<AppController>().addTask(task);}
                        else{
                          await context.read<AppController>().updateTask(task);
                        }

                        setState(() {
                          editedTasks.remove(task);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          if (isNew) {
                            newTasks.remove(task);
                            taskList.remove(task);
                          }
                          editedTasks.remove(task);
                        });
                      },
                    )
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          editedTasks.add(task);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          taskList.remove(task);
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
  int get rowCount => taskList.length;

  @override
  int get selectedRowCount => 0;
}
