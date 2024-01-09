import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/batch.dart';
import 'package:front/models/evaluation_task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class TaskEvaluationTable extends StatefulWidget {
  final List<EvaluationTask> evaluationList;
  final Batch batch;
  final int taskId;
  final String taskType;
  final int userId;

  const TaskEvaluationTable(
      {Key? key,
      required this.evaluationList,
      required this.taskId,
      required this.batch,
      required this.taskType,
      required this.userId})
      : super(key: key);

  @override
  TaskEvaluationTableState createState() => TaskEvaluationTableState();
}

double getTotalMark(String tasktype) {
  switch (tasktype) {
    case "DAILY_TASK":
      return 10.0;
    case "MINI_PROJECT":
      return 50.0;
    case "MID_PROJECT":
      return 100;
    default:
      return 0.0;
  }
}



class TaskEvaluationTableState extends State<TaskEvaluationTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<EvaluationTask> _editedEvaluations = [];
  List<User> trainees = [];
  List<EvaluationTask> shownEvaluations = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(EvaluationTask evaulation) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (ascending) {
        widget.evaluationList
            .sort((a, b) => getField(a).compareTo(getField(b) as T));
      } else {
        widget.evaluationList
            .sort((a, b) => getField(b).compareTo(getField(a) as T));
      }
    });
  }

  void updateList() {
    List<int> ids = [];
    ids = widget.evaluationList.map((e) => e.traineeId!).toList();
    if(trainees.length!=0){
      ids.forEach((element) {
        trainees.removeWhere((e) => e.userId==element);
      });
    }
    if(trainees.length!=0){
      trainees.forEach((t) {
        widget.evaluationList.add(EvaluationTask(
            taskId: widget.taskId,
            batchId: widget.batch.id,
            traineeId: t.userId,
            evaluationType: widget.taskType,
            taskType: widget.taskType,
            evaluatorId: widget.userId));
    });};

  }

  void _updateTask(EvaluationTask evaluation) {
    setState(() {
      if (!_editedEvaluations.contains(evaluation)) {
        _editedEvaluations.add(evaluation);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    trainees = widget.batch.trainees!;
    updateList();
    final dateFormat = DateFormat('yyyy/MM/dd');
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PaginatedDataTable2(
            columnSpacing: 10,
            minWidth: 1700,
            renderEmptyRowsInTheEnd: false,
            fit: FlexFit.tight,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            header: const Text('Evaluations'),
            columns: [
               DataColumn2(
                 fixedWidth: 100,
                label: const Text('Trainee Id'),
                onSort: (columnIndex, ascending) {
                  _sort<num>((task) => task.traineeId ?? 0,
                      columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 250,
                label: const Text('Requirement Understanding'),
                onSort: (columnIndex, ascending) {
                  _sort<num>((task) => task.requirementUnderstanding ?? 0,
                      columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 150,
                label: const Text('Expected Output'),
                onSort: (columnIndex, ascending) {
                  _sort<num>(
                      (task) => task.expectedOutput ?? 0, columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 150,
                label: const Text('Code Quality'),
                onSort: (columnIndex, ascending) {
                  _sort<num>(
                      (task) => task.codeQuality ?? 0, columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 220,
                label: const Text('Demonstration / Presentation'),
                onSort: (columnIndex, ascending) {
                  _sort<num>((task) => task.demonstrationOrPresentation ?? 0,
                      columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 250,
                label: const Text('LiveCoding Or CodeUnderstanding'),
                onSort: (columnIndex, ascending) {
                  _sort<num>((task) => task.liveCodingOrCodeUnderstanding ?? 0,
                      columnIndex, ascending);
                },
              ),
              DataColumn2(
                fixedWidth: 130,
                label: const Text('Obtained Mark'),
                onSort: (columnIndex, ascending) {
                  _sort<num>(
                      (task) => task.obtainedMark ?? 0, columnIndex, ascending);
                },
              ),
              const DataColumn2(
                fixedWidth: 100,
                label: Text('Total Mark'),
              ),
              const DataColumn2(
                fixedWidth: 100,
                label: Text('Actions'),
              ),
            ],
            source: EvaluationTaskDataTableSource(
                taskType: widget.taskType,
                evaluationList: widget.evaluationList,
                editedEvaluationList: _editedEvaluations,
                updateEvaluationTask: _updateTask,
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
        ],
      ),
    );
  }
}

class EvaluationTaskDataTableSource extends DataTableSource {
  final List<EvaluationTask> evaluationList;
  final List<EvaluationTask> editedEvaluationList;
  final Function(EvaluationTask) updateEvaluationTask;
  final BuildContext context;
  final String taskType;


  final Function(void Function()) setState;

  EvaluationTaskDataTableSource({
    required this.taskType,
    required this.evaluationList,
    required this.editedEvaluationList,
    required this.updateEvaluationTask,
    required this.setState,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    var evaluation = evaluationList[index];
    final isEditing = editedEvaluationList.contains(evaluation);
    var formatter = [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
    ];


    return DataRow(
      cells: [
        DataCell(
          Text(evaluation.traineeId?.toString() ?? ''),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.requirementUnderstanding== null
                      ? "0.0"
                      : evaluation.requirementUnderstanding.toString(),
                  onChanged: (value) {
                    evaluation.requirementUnderstanding = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.requirementUnderstanding== null
                  ? "0.0"
                  : evaluation.requirementUnderstanding.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.expectedOutput== null
                      ? "0.0"
                      : evaluation.expectedOutput.toString(),
                  onChanged: (value) {
                    setState((){
                      evaluation.expectedOutput = double.parse(value);
                    });

                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.expectedOutput== null
                  ? "0.0"
                  : evaluation.expectedOutput.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.codeQuality== null
                      ? "0.0"
                      : evaluation.codeQuality.toString(),
                  onChanged: (value) {
                    evaluation.codeQuality = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.codeQuality== null
                  ? "0.0"
                  : evaluation.codeQuality.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.demonstrationOrPresentation== null
                      ? "0.0"
                      : evaluation.demonstrationOrPresentation.toString(),
                  onChanged: (value) {
                    evaluation.demonstrationOrPresentation =
                        double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.demonstrationOrPresentation== null
                  ? "0.0"
                  : evaluation.demonstrationOrPresentation.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.liveCodingOrCodeUnderstanding== null
                      ? "0.0"
                      : evaluation.liveCodingOrCodeUnderstanding.toString(),
                  onChanged: (value) {
                    evaluation.liveCodingOrCodeUnderstanding =
                        double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.liveCodingOrCodeUnderstanding== null
                  ? "0.0"
                  : evaluation.liveCodingOrCodeUnderstanding.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.obtainedMark== null
                      ? "0.0"
                      : evaluation.obtainedMark.toString(),
                  onChanged: (value) {
                    setState((){
                      evaluation.obtainedMark = double.parse(value);
                    });
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.obtainedMark== null
                  ? "0.0"
                  : evaluation.obtainedMark.toString()),
        ),
        DataCell(
          Text(getTotalMark(taskType).toString()),
        ),
        DataCell(
          isEditing
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {

                        var eval ;
                        if(evaluation.id== null){
                          eval = await context.read<AppController>().saveTaskEvaluation(evaluation);
                        }else{
                          eval = await context.read<AppController>().updateTaskEvaluation(evaluation);
                        }
                        print(eval);
                        if(eval!=null){
                          setState(() {
                            editedEvaluationList.remove(evaluation);
                            evaluation = eval;
                          });
                        }

                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          editedEvaluationList.remove(evaluation);
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
                          editedEvaluationList.add(evaluation);
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
  int get rowCount => evaluationList.length;

  @override
  int get selectedRowCount => 0;
}
