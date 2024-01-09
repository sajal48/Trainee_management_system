import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/models/batch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/app_controller.dart';
import '../../models/evaluation_hr.dart';
import '../../models/user.dart';

class HrEvaluationTable extends StatefulWidget {
  final List<EvaluationHr> evaluationList;
  final Batch batch;
  final String taskType;

  const HrEvaluationTable({
    Key? key,
    required this.evaluationList,
    required this.batch,
    required this.taskType,
  }) : super(key: key);

  @override
  HrEvaluationTableState createState() => HrEvaluationTableState();
}

String getTotalMark(String tasktype) {
  return "100";
}

class HrEvaluationTableState extends State<HrEvaluationTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<EvaluationHr> _editedEvaluations = [];
  List<User> trainees = [];
  List<EvaluationHr> shownEvaluations = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(EvaluationHr evaulation) getField,
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
        widget.evaluationList.add(EvaluationHr(
          batchId: widget.batch.id,
          traineeId: t.userId,
        ));
      });
    }
    ;
  }

  void _updateTask(EvaluationHr evaluation) {
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
        minWidth: 800,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: const Text('Evaluations'),
        columns: [
          DataColumn2(
            label: const Text('Trainee Id'),
            onSort: (columnIndex, ascending) {
              _sort<num>((task) => task.traineeId ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Interview Mark'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                  (task) => task.obtainedMark ?? 0, columnIndex, ascending);
            },
          ),
          const DataColumn2(
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
  final List<EvaluationHr> evaluationList;
  final List<EvaluationHr> editedEvaluationList;
  final Function(EvaluationHr) updateEvaluationTask;
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
                  initialValue: evaluation.obtainedMark== null
                      ? "0.0"
                      : evaluation.obtainedMark.toString(),
                  onChanged: (value) {
                    evaluation.obtainedMark = double.parse(value);
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
                        if(evaluation.id== null){
                          eval = await context.read<AppController>().saveHrEvaluation(evaluation);
                        }else{
                          eval = await context.read<AppController>().updateHrEvaluation(evaluation);
                        }
                        if(eval!=null){
                          evaluation = eval;
                          setState(() {
                            editedEvaluationList.remove(evaluation);
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
