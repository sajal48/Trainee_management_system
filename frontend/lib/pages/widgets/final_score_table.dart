import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/final_score.dart';
import '../../models/user.dart';

class FinalScoreTable extends StatefulWidget {
  final List<FinalScore> evaluationList;
  final String taskType;

  const FinalScoreTable({
    Key? key,
    required this.evaluationList,
    required this.taskType,
  }) : super(key: key);

  @override
  FinalScoreTableState createState() => FinalScoreTableState();
}


class FinalScoreTableState extends State<FinalScoreTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<FinalScore> _editedEvaluations = [];
  List<User> trainees = [];
  List<FinalScore> shownEvaluations = [];
  bool isNew = false;

  void _sort<T>(Comparable<T> Function(FinalScore evaulation) getField,
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


  void _updateTask(FinalScore evaluation) {
    setState(() {
      if (!_editedEvaluations.contains(evaluation)) {
        _editedEvaluations.add(evaluation);
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
        columnSpacing: 10,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        header: const Text('Final Score'),
        columns: [
          DataColumn2(
            label: const Text('Trainee Id'),
            onSort: (columnIndex, ascending) {
              _sort<num>((task) => task.traineeId ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text("Total Score"),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.totalScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Daily Task'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                  (task) => task.dailyTask ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Mini Project'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.miniProjectScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Mid Project'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.midProjectScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Final Project'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.finalProjectScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Domain Score'),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.domainScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text("Manager's Score"),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.managersEvaluationScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text("Training Score"),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.trainingTotalScore ?? 0, columnIndex, ascending);
            },
          ),
          DataColumn2(
            fixedWidth: 150,
            label: const Text("Ceo Interview Score"),
            onSort: (columnIndex, ascending) {
              _sort<num>(
                      (task) => task.hrEvaluationScore ?? 0, columnIndex, ascending);
            },
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
  final List<FinalScore> evaluationList;
  final List<FinalScore> editedEvaluationList;
  final Function(FinalScore) updateEvaluationTask;
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
          Text(evaluation.totalScore== null
                  ? "0.0 %"
                  : "${evaluation.totalScore}%"),
        ),
        DataCell(
          Text(evaluation.dailyTask== null
              ? "0.0 %"
              : "${evaluation.dailyTask}%"),
        ),
        DataCell(
          Text(evaluation.miniProjectScore== null
              ? "0.0 %"
              : "${evaluation.miniProjectScore}%"),
        ),
        DataCell(
          Text(evaluation.midProjectScore== null
              ? "0.0 %"
              : "${evaluation.midProjectScore}%"),
        ),
        DataCell(
          Text(evaluation.finalProjectScore== null
              ? "0.0 %"
              : "${evaluation.finalProjectScore}%"),
        ),
        DataCell(
          Text(evaluation.domainScore== null
              ? "0.0 %"
              : "${evaluation.domainScore}%"),
        ),
        DataCell(
          Text(evaluation.managersEvaluationScore== null
              ? "0.0 %"
              : "${evaluation.managersEvaluationScore}%"),
        ),
        DataCell(
          Text(evaluation.trainingTotalScore== null
              ? "0.0 %"
              : "${evaluation.trainingTotalScore}%"),
        ),
        DataCell(
          Text(evaluation.hrEvaluationScore== null
              ? "0.0 %"
              : "${evaluation.hrEvaluationScore}%"),
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
