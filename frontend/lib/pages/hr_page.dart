import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/pages/widgets/hr_evaluation_table.dart';
import 'package:provider/provider.dart';

import '../models/batch.dart';
import '../models/task_types.dart';

class HrEvaluationPage extends StatefulWidget {
  const HrEvaluationPage({super.key});

  @override
  HrEvaluationPageState createState() => HrEvaluationPageState();
}

class HrEvaluationPageState extends State<HrEvaluationPage> {
  String selectedTaskType = "CEO" ;
  String? selectedBatchName;
  int? selectedBatchId;

  List<String> tasks = [];
  List<String> taskTypes = TaskType.values.map((e) => e.name).toList();

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
    final appController = context.watch<AppController>();
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
                            });
                            context.read<AppController>().getEvaluation(taskType:selectedTaskType,batchId: selectedBatchId);
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
                                });

                              },
                              icon: Icon(Icons.clear),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),

                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child:selectedBatchId== null
                ? const Center(
              child: Text("Select a batch for evaluation"),
            )
                : Padding(
              padding: const EdgeInsets.all(18),
              child:   FutureBuilder(
            future: context.read<AppController>().getBatch(selectedBatchId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error occurred"));
                  } else if(!snapshot.hasData){
                    return const Center(child: Text("Not Batch info found for evaluation"));
                  }
                  else{
                    return HrEvaluationTable(
                      evaluationList: context.read<AppController>().evaluationHrs,
                      taskType: selectedTaskType,
                      batch: snapshot.data!);
                  }
                }
              },
            ),
            )),
          ],
        ),
      ),
    );
  }
}
