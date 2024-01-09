import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/batch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/evaluation_final.dart';
import '../../models/user.dart';

class FinalProjectEvaluationTable extends StatefulWidget {
  final List<EvaluationFinal> evaluationList;
  final Batch batch;
  final int taskId;
  final String taskType;
  final int userId;

  const FinalProjectEvaluationTable(
      {Key? key,
      required this.evaluationList,
      required this.taskId,
      required this.batch,
      required this.taskType,
      required this.userId})
      : super(key: key);

  @override
  FinalProjectEvaluationTableState createState() => FinalProjectEvaluationTableState();
}

String getTotalMark(String tasktype) {
return "100";
}



class FinalProjectEvaluationTableState extends State<FinalProjectEvaluationTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<EvaluationFinal> _editedEvaluations = [];
  List<User> trainees = [];
  List<EvaluationFinal> shownEvaluations = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(EvaluationFinal evaulation) getField,
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
        widget.evaluationList.add(EvaluationFinal(
            batchId: widget.batch.id,
            traineeId: t.userId,
            evaluatorId: widget.userId));
    });};

  }

  void _updateTask(EvaluationFinal evaluation) {
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
      body: PaginatedDataTable2(
        columnSpacing: 10,
        minWidth: 2000,
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
            fixedWidth: 200,
            label: const Text('Requirement Understanding'),
            onSort: (columnIndex, ascending) {
              _sort<num>((task) => task.requirementUnderstanding ?? 0,
                  columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Expected Output'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                  (task) => task.expectedOutput ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 200,
            label: const Text('Code Quality'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                  (task) => task.codeQuality ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 250,
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
            fixedWidth: 150,
            label: const Text('Documentation'),
            onSort: (columnIndex, ascending) {
              _sort<num>((task) => task.designDocument ?? 0,
                  columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 150,
            label: const Text('Presentation'),
            onSort: (columnIndex, ascending) {
              _sort<num>((task) => task.ppt ?? 0,
                  columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 100,
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
    );
  }
}

class EvaluationTaskDataTableSource extends DataTableSource {
  final List<EvaluationFinal> evaluationList;
  final List<EvaluationFinal> editedEvaluationList;
  final Function(EvaluationFinal) updateEvaluationTask;
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
            initialValue: evaluation.designDocument== null
                ? "0.0"
                : evaluation.designDocument.toString(),
            onChanged: (value) {
              setState((){
                evaluation.designDocument = double.parse(value);
              });
              updateEvaluationTask(evaluation);
            },
          )
              : Text(evaluation.designDocument== null
              ? "0.0"
              : evaluation.designDocument.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: formatter,
            initialValue: evaluation.ppt== null
                ? "0.0"
                : evaluation.ppt.toString(),
            onChanged: (value) {
              setState((){
                evaluation.ppt = double.parse(value);
              });
              updateEvaluationTask(evaluation);
            },
          )
              : Text(evaluation.ppt== null
              ? "0.0"
              : evaluation.ppt.toString()),
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
          Text(getTotalMark(taskType)),
        ),
        DataCell(
          isEditing
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        evaluation.setObtainedMarkIfNull;
                        var eval ;
                        if(evaluation.id== null){
                          eval = await context.read<AppController>().saveFinalProjectEvaluation(evaluation);
                        }else{
                          eval = await context.read<AppController>().updateFinalEvaluation(evaluation);
                        }
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
