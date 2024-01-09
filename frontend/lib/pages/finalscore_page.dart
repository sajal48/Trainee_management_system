import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/pages/widgets/final_score_table.dart';
import 'package:provider/provider.dart';

import '../models/batch.dart';
import '../models/task_types.dart';

class FinalScorePage extends StatefulWidget {
  const FinalScorePage({super.key});

  @override
  FinalScorePageState createState() => FinalScorePageState();
}

class FinalScorePageState extends State<FinalScorePage> {
  String selectedTaskType = "CEO" ;
  String? selectedBatchName;
  int? selectedBatchId;

  List<String> tasks = [];
  List<String> taskTypes = TaskType.values.map((e) => e.name).toList();
  bool? flag ;

  @override
  void initState() {
    super.initState();
    context.read<AppController>().getData();
  }

  int? getBatchId(List<Batch> batchList, String batchName) {
    for (var batch in batchList) {
      if (batch.batchName == batchName) {
        return batch.id!;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String role = context.read<AuthController>().role;
    final appController = context.watch<AppController>();
    final bool isBatchSelected = selectedBatchId != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        body: appController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 50, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedBatchName,
                          hint: const Text("Select Batch"),
                          items: appController.batches.map((batch) {
                            return DropdownMenuItem<String>(
                              value: batch.batchName,
                              child: Text(batch.batchName ?? ""),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBatchName = newValue;
                              selectedBatchId = getBatchId(appController.batches,selectedBatchName!);
                              flag = null;
                            });
                          },
                        ),
                        if (selectedBatchName != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedBatchName = null;
                                  selectedBatchId = null;
                                  flag = null;
                                });
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: isBatchSelected ? () {
                      setState(() {
                        flag = false;
                      });
                    } : null,
                    child: const Text("View"),
                  ),
                  const SizedBox(width: 15,),
                  Visibility(
                    visible: role == "ADMIN",
                    child: ElevatedButton(
                      onPressed: isBatchSelected ? () {
                        setState(() {
                          flag = true;
                        });
                      } : null,
                      child: const Text("Calculate/ReCalculate"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: flag== null
                  ? const Center(
                  child: Text("Click an option to continue"))
                  : Padding(
                    padding: const EdgeInsets.all(18),
                    child: FutureBuilder(
                future: context.read<AppController>().getFinalScore(selectedBatchId!,recalculate: flag!),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error occurred"));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text("Not Batch info found for evaluation"));
                      } else {
                        return FinalScoreTable(
                          evaluationList: snapshot.data!,
                          taskType: selectedTaskType,
                        );
                      }
                    }
                },
              ),
                  )
              ),

          ],
        ),
      ),
    );
  }
}
