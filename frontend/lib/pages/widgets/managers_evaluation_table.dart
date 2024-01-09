import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/batch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/evaluation_managers.dart';
import '../../models/user.dart';

class ManagersEvaluationTable extends StatefulWidget {
  final List<EvaluationManagers> evaluationList;
  final Batch batch;
  final String taskType;

  const ManagersEvaluationTable(
      {Key? key,
      required this.evaluationList,
      required this.batch,
      required this.taskType,})
      : super(key: key);

  @override
  ManagersEvaluationTableState createState() => ManagersEvaluationTableState();
}

String getTotalMark(String tasktype) {
  return "85";
}

class ManagersEvaluationTableState extends State<ManagersEvaluationTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<EvaluationManagers> _editedEvaluations = [];
  List<User> trainees = [];
  List<EvaluationManagers> shownEvaluations = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(EvaluationManagers evaulation) getField,
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
    if (trainees.length != 0) {
      ids.forEach((element) {
        trainees.removeWhere((e) => e.userId == element);
      });
    }
    if (trainees.length != 0) {
      trainees.forEach((t) {
        widget.evaluationList.add(EvaluationManagers(
          batchId: widget.batch.id,
          traineeId: t.userId,
        ));
      });
    }
    ;
  }

  void _updateTask(EvaluationManagers evaluation) {
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
          minWidth: 1700,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          header: const Text('Evaluations'),
          columns: [
            DataColumn2(
              fixedWidth: 100,
              label: const Text('Trainee Id'),
              onSort: (columnIndex, ascending) {
                _sort<num>(
                    (task) => task.traineeId ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
              label: const Text('BJit Tools'),
              onSort: (columnIndex, ascending) {
                _sort<num>(
                    (task) => task.bjitTools ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
              label: const Text('Office Rules'),
              onSort: (columnIndex, ascending) {
                _sort<num>(
                    (task) => task.officeRules ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
              label: const Text('Sincerity'),
              onSort: (columnIndex, ascending) {
                _sort<num>(
                    (task) => task.sincerity ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
              label: const Text('Quality'),
              onSort: (columnIndex, ascending) {
                _sort<num>((task) => task.quality ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
              label: const Text('Attendance'),
              onSort: (columnIndex, ascending) {
                _sort<num>(
                    (task) => task.attendance ?? 0, columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 200,
              label: const Text('Communication Skill'),
              onSort: (columnIndex, ascending) {
                _sort<num>((task) => task.communicationSkill ?? 0, columnIndex,
                    ascending);
              },
            ),

            DataColumn2(
              fixedWidth: 250,
              label: const Text('English Language Skill'),
              onSort: (columnIndex, ascending) {
                _sort<num>((task) => task.englishLanguageSkill ?? 0,
                    columnIndex, ascending);
              },
            ),
            DataColumn2(
              fixedWidth: 150,
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
        ));
  }
}

class EvaluationTaskDataTableSource extends DataTableSource {
  final List<EvaluationManagers> evaluationList;
  final List<EvaluationManagers> editedEvaluationList;
  final Function(EvaluationManagers) updateEvaluationTask;
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
                  initialValue: evaluation.bjitTools== null
                      ? "0.0"
                      : evaluation.bjitTools.toString(),
                  onChanged: (value) {
                    evaluation.bjitTools = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.bjitTools== null
                  ? "0.0"
                  : evaluation.bjitTools.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.officeRules== null
                      ? "0.0"
                      : evaluation.officeRules.toString(),
                  onChanged: (value) {
                    setState(() {
                      evaluation.officeRules = double.parse(value);
                    });

                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.officeRules== null
                  ? "0.0"
                  : evaluation.officeRules.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.sincerity== null
                      ? "0.0"
                      : evaluation.sincerity.toString(),
                  onChanged: (value) {
                    evaluation.sincerity = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.sincerity== null
                  ? "0.0"
                  : evaluation.sincerity.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.quality== null
                      ? "0.0"
                      : evaluation.quality.toString(),
                  onChanged: (value) {
                    evaluation.quality = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.quality== null
                  ? "0.0"
                  : evaluation.quality.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.attendance== null
                      ? "0.0"
                      : evaluation.attendance.toString(),
                  onChanged: (value) {
                    evaluation.attendance = double.parse(value);
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.attendance== null
                  ? "0.0"
                  : evaluation.attendance.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.communicationSkill== null
                      ? "0.0"
                      : evaluation.communicationSkill.toString(),
                  onChanged: (value) {
                    setState(() {
                      evaluation.communicationSkill = double.parse(value);
                    });
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.communicationSkill== null
                  ? "0.0"
                  : evaluation.communicationSkill.toString()),
        ),
        DataCell(
          isEditing
              ? TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: formatter,
                  initialValue: evaluation.englishLanguageSkill== null
                      ? "0.0"
                      : evaluation.englishLanguageSkill.toString(),
                  onChanged: (value) {
                    setState(() {
                      evaluation.englishLanguageSkill = double.parse(value);
                    });
                    updateEvaluationTask(evaluation);
                  },
                )
              : Text(evaluation.englishLanguageSkill== null
                  ? "0.0"
                  : evaluation.englishLanguageSkill.toString()),
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
                    setState(() {
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
                        var eval;
                        if (evaluation.id== null) {
                          eval = await context
                              .read<AppController>()
                              .saveManagersEvaluation(evaluation);
                        } else {
                          eval = await context
                              .read<AppController>()
                              .updateManagersEvaluation(evaluation);
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
