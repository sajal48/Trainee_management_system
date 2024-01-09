import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/models/final_score.dart';
import 'package:provider/provider.dart';

import '../models/batch.dart';


class InfographicPage extends StatefulWidget {
  final int traineesCount;
  final int trainersCount;
  final int tasksCount;
  final int batchCount;
  final List<Batch> batches;
  final List<FinalScore> finalEvaluations;

  InfographicPage({
    required this.traineesCount,
    required this.trainersCount,
    required this.tasksCount,
    required this.batchCount,
    required this.finalEvaluations,
    required this.batches
  });

  @override
  State<InfographicPage> createState() => _InfographicPageState();
}

class _InfographicPageState extends State<InfographicPage> {
  List<int> getUniqueBatches() {
    List<int> uniqueBatches = [];
    widget.finalEvaluations.forEach((evaluation) {
      if (!uniqueBatches.contains(evaluation.batchId)) {
        uniqueBatches.add(evaluation.batchId!);
      }
    });
    return uniqueBatches;
  }

  FinalScore getTopPerformerByBatch(int batchId) {
    List<FinalScore> batchEvaluations = widget.finalEvaluations
        .where((evaluation) => evaluation.batchId == batchId)
        .toList();
    batchEvaluations.sort((a, b) => b.totalScore!.compareTo(a.totalScore!));
    return batchEvaluations.isNotEmpty
        ? batchEvaluations.first
        : FinalScore(batchId: batchId, traineeId: 0, totalScore: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'User Info:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(
                                  value: widget.traineesCount.toDouble(),
                                  title: 'Trainees',
                                  color: Colors.blue,
                                ),
                                PieChartSectionData(
                                  value: widget.trainersCount.toDouble(),
                                  title: 'Trainers',
                                  color: Colors.green,
                                ),
                                PieChartSectionData(
                                  value: widget.batchCount.toDouble(),
                                  title: 'Batch',
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                            swapAnimationCurve: Curves.easeInOut,
                            swapAnimationDuration: const Duration(seconds: 2),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      reservedSize: 50,
                                      showTitles: true,
                                      getTitlesWidget: getTitles),
                                ),
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                        toY: widget.traineesCount.toDouble(),
                                        color: Colors.blue)
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                        toY: widget.trainersCount.toDouble(),
                                        color: Colors.green)
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                        toY: widget.batchCount.toDouble(),
                                        color: Colors.orange)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   'Top Performers by Batch:',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(
                  //   height: 300,
                  //   child: Expanded(
                  //     child: ListView.builder(
                  //       itemCount: batchCount,
                  //       itemBuilder: (context, index) {
                  //         int batchId = getUniqueBatches()[index];
                  //         FinalEvaluation topPerformer = getTopPerformerByBatch(batchId);
                  //
                  //         return Card(
                  //           child: ListTile(
                  //             leading: Icon(Icons.star),
                  //             title: Text('Batch $batchId'),
                  //             subtitle: Text('Top Performer: Trainee ${topPerformer.traineeId}'),
                  //             trailing: Text('Score: ${topPerformer.score.toStringAsFixed(2)}'),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  Visibility(
                    visible: context.read<AuthController>().role!="TRAINEE",
                    child: Text(
                      'Top Performers Chart:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Visibility(
                    visible: context.read<AuthController>().role!="TRAINEE",
                    child: SizedBox(
                      height: 500,
                      child: Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: getTitles2,
                                      reservedSize: 50)),
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 50,
                              )),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: getUniqueBatches().map((batchId) {
                              FinalScore topPerformer =
                                  getTopPerformerByBatch(batchId);
                              return BarChartGroupData(
                                x: batchId.toInt(),
                                barRods: [
                                  BarChartRodData(
                                      toY: topPerformer.totalScore!, color: Colors.blue)
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: const Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Trainees', style: style);
        break;
      case 1:
        text = const Text('Trainers', style: style);
        break;
      case 2:
        text = const Text('Batch', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
  String? findBatchName(List<Batch> batches, int id) {
    // Iterate through the list of batches
    for (var batch in batches) {
      if (batch.id == id) {
        return batch.batchName; // Return the name when the id matches
      }
    }
    return null; // Return null if no batch with the given id is found
  }

  Widget getTitles2(double value, TitleMeta meta) {

    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // int batchId = getUniqueBatches()[value.toInt()];
    String batchName = findBatchName(widget.batches,value.toInt())!;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        batchName,
        style: style,
      ),
    );
  }
}
