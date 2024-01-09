import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/pages/widgets/task_table.dart';
import 'package:provider/provider.dart';

import '../models/batch.dart';
import '../models/task_types.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  String? selectedTaskType;
  String? selectedBatchName;
  int? selectedBatchId;

  List<String> tasks = [];
  List<String> taskTypes = TaskType.values.map((e) => e.name).toList();

  @override
  void initState() {
    super.initState();
    context.read<AppController>().getData();
    context.read<AppController>().getTasks();
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
        // appBar: AppBar(
        //   title: const Text("Task"),
        // ),
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
                                  context.read<AppController>().getTasks(taskType: selectedTaskType,batchId: selectedBatchId);
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
                                      context.read<AppController>().getTasks(taskType: selectedTaskType, batchId: null);
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedTaskType,
                                hint: const Text("Select Task Type"),
                                items: taskTypes.map((String taskType) {
                                  return DropdownMenuItem<String>(
                                    value: taskType,
                                    child: Text(taskType),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTaskType = newValue!;
                                  });
                                  context.read<AppController>().getTasks(taskType: newValue, batchId: selectedBatchId);
                                },
                              ),
                              if (selectedTaskType != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedTaskType = null;
                                      });
                                      context.read<AppController>().getTasks(taskType: null, batchId: selectedBatchId);
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  appController.isTaskLoading
                      ? const Center(child: CircularProgressIndicator())
                      :Expanded(child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: TaskTable(taskList: appController.tasks,selectedBatchId: selectedBatchId,selectedTaskType: selectedTaskType,),
                      )),
                ],
              ),
      ),
    );
  }
}
